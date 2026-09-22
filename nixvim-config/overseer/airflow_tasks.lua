-- Airflow overseer task templates.
-- Astro CLI templates register when `astro` is on PATH (preferred). Fallback
-- vanilla `airflow` CLI templates register only when `astro` is absent but
-- `airflow` is present, so the two never clobber each other.
local overseer = require("overseer")

-- Shared component bundle (lua/overseer_helpers.lua).
local bottom_output = require("overseer_helpers").bottom_output

-- ── Astro CLI (preferred — wraps Airflow with a better dev loop) ──────────
if vim.fn.executable("astro") == 1 then

-- `astro dev parse` validates every DAG in the project parses without error.
overseer.register_template({
	name = "astro dev parse",
	builder = function()
		return {
			cmd = { "astro", "dev", "parse" },
			cwd = vim.fn.getcwd(),
			components = bottom_output(120),
		}
	end,
})

-- `astro dev test` runs pytest inside the astro runtime (DAG integrity tests).
overseer.register_template({
	name = "astro dev test (project)",
	builder = function()
		return {
			cmd = { "astro", "dev", "test" },
			cwd = vim.fn.getcwd(),
			components = bottom_output(600),
		}
	end,
})

-- `astro dev run <airflow-command>` forwards everything after `run` as an
-- Airflow CLI subcommand + its own args (see e.g. `astro dev run users
-- create --role Admin ...` in Astronomer's docs) — it does NOT take
-- `<dag> <task> <date>` as bare positional args the way `airflow tasks test`
-- does. An earlier version of this template passed dag/task/date straight
-- after `run`, which astro would have tried to interpret as an Airflow
-- subcommand name and failed (or, worse, silently done nothing useful) —
-- the fix is to spell out the real Airflow subcommand (`tasks test` /
-- `dags test`) so `astro dev run` has something valid to forward.
overseer.register_template({
	name = "astro dev run: tasks test (prompt dag/task/date)",
	builder = function(params)
		local dag = params and params.dag or ""
		local task = params and params.task or ""
		local date = params and params.date or ""
		local args = { "dev", "run", "tasks", "test", dag, task }
		if date ~= "" then
			table.insert(args, date)
		end
		return {
			cmd = { "astro" },
			args = args,
			name = "astro dev run tasks test: " .. dag .. "/" .. task,
			cwd = vim.fn.getcwd(),
			components = bottom_output(600),
		}
	end,
	-- params must be keyed by name (`{ dag = {...} }`), not `{ key = "dag" }`
	-- — see dbt_tasks.lua "dbt run (tag prompt)" for why.
	params = {
		dag = { desc = "DAG id", optional = false },
		task = { desc = "Task id", optional = false },
		date = { desc = "Logical date, e.g. 2025-01-01", optional = true },
	},
})

overseer.register_template({
	name = "astro dev run: dags test (prompt dag/date)",
	builder = function(params)
		local dag = params and params.dag or ""
		local date = params and params.date or ""
		local args = { "dev", "run", "dags", "test", dag }
		if date ~= "" then
			table.insert(args, date)
		end
		return {
			cmd = { "astro" },
			args = args,
			name = "astro dev run dags test: " .. dag,
			cwd = vim.fn.getcwd(),
			components = bottom_output(600),
		}
	end,
	params = {
		dag = { desc = "DAG id", optional = false },
		date = { desc = "Logical date, e.g. 2025-01-01", optional = true },
	},
})

end -- astro

-- ── Vanilla Airflow CLI fallback (only when astro is NOT on PATH) ─────────
if vim.fn.executable("astro") == 0 and vim.fn.executable("airflow") == 1 then

overseer.register_template({
	name = "airflow dags list",
	builder = function()
		return {
			cmd = { "airflow", "dags", "list" },
			cwd = vim.fn.getcwd(),
			components = bottom_output(60),
		}
	end,
})

overseer.register_template({
	name = "airflow dags test (prompt dag + date)",
	builder = function(params)
		local dag = params and params.dag or ""
		local date = (params and params.date ~= "" and params.date) or "2025-01-01"
		return {
			cmd = { "airflow", "dags", "test", dag, date },
			name = "airflow dags test: " .. dag,
			cwd = vim.fn.getcwd(),
			components = bottom_output(600),
		}
	end,
	params = {
		dag = { desc = "DAG id", optional = false },
		date = { desc = "Logical date, e.g. 2025-01-01", optional = true },
	},
})

overseer.register_template({
	name = "airflow tasks test (prompt dag/task/date)",
	builder = function(params)
		local dag = params and params.dag or ""
		local task = params and params.task or ""
		local date = (params and params.date ~= "" and params.date) or "2025-01-01"
		return {
			cmd = { "airflow", "tasks", "test", dag, task, date },
			name = "airflow tasks test: " .. dag .. "/" .. task,
			cwd = vim.fn.getcwd(),
			components = bottom_output(600),
		}
	end,
	params = {
		dag = { desc = "DAG id", optional = false },
		task = { desc = "Task id", optional = false },
		date = { desc = "Logical date, e.g. 2025-01-01", optional = true },
	},
})

end -- vanilla airflow