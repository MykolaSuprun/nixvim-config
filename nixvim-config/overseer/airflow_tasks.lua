-- Airflow overseer task templates.
-- Astro CLI templates register when `astro` is on PATH (preferred). Fallback
-- vanilla `airflow` CLI templates register only when `astro` is absent but
-- `airflow` is present, so the two never clobber each other.
local overseer = require("overseer")

local function bottom_output(dispose_timeout)
	return {
		{ "open_output", direction = "bottom", on_start = "always" },
		{ "on_complete_notify", statuses = { "SUCCESS", "FAILURE" } },
		{ "unique", replace = true },
		"on_exit_set_status",
		{ "on_complete_dispose", timeout = dispose_timeout or 300 },
	}
end

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

overseer.register_template({
	name = "astro dev test (prompt dag/test/date)",
	builder = function(params)
		local args = { "dev", "run" }
		if params and params.dag and params.dag ~= "" then
			table.insert(args, params.dag)
			if params.task and params.task ~= "" then
				table.insert(args, params.task)
			end
			if params.date and params.date ~= "" then
				table.insert(args, params.date)
			end
		end
		local name = "astro dev run"
		if params and params.dag and params.dag ~= "" then
			name = name .. ": " .. params.dag
			if params.task and params.task ~= "" then
				name = name .. " " .. params.task
			end
		end
		return {
			cmd = { "astro" },
			args = args,
			name = name,
			cwd = vim.fn.getcwd(),
			components = bottom_output(600),
		}
	end,
	params = {
		{ key = "dag", desc = "DAG id", optional = false },
		{ key = "task", desc = "Task id (optional)", optional = true },
		{ key = "date", desc = "Logical date, e.g. 2025-01-01", optional = true },
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
		{ key = "dag", desc = "DAG id", optional = false },
		{ key = "date", desc = "Logical date, e.g. 2025-01-01", optional = true },
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
		{ key = "dag", desc = "DAG id", optional = false },
		{ key = "task", desc = "Task id", optional = false },
		{ key = "date", desc = "Logical date, e.g. 2025-01-01", optional = true },
	},
})

end -- vanilla airflow