-- dbt overseer task templates
-- Tasks are only registered when `dbt` is found on PATH at startup.
-- Output goes to a bottom split via the `open_output` component (overseer's
-- own rendering — does NOT use snacks.terminal or betterTerm). For interactive
-- snowsql / astro shells use betterTerm (<leader>Xt> + send keys).
local overseer = require("overseer")

-- Shared component bundle for a bottom-split dbt run/build/test.
local function bottom_output(dispose_timeout)
	return {
		{ "open_output", direction = "bottom", on_start = "always" },
		{ "on_complete_notify", statuses = { "SUCCESS", "FAILURE" } },
		{ "unique", replace = true },
		"on_exit_set_status",
		{ "on_complete_dispose", timeout = dispose_timeout or 600 },
	}
end

-- dbt target dir — compiled SQL lands under target/compiled/<project>/...
-- We open the compiled file for the current model in a vertical split.
local function open_compiled_model(model)
	-- `dbt compile` writes to target/compiled/<project_name>/<subpath>/<model>.sql.
	-- project_name comes from dbt_project.yml; fall back to searching target/
	-- recursively for a file named <model>.sql.
	local results = vim.fn.split(vim.fn.systemlist(
		"find target/compiled -type f -name '"
			.. model
			.. ".sql' 2>/dev/null | head -n1"
	), "\n")
	local path = results[1]
	if not path or path == "" then
		vim.notify(
			"dbt: compiled SQL not found for '" .. model .. "'. Run `dbt compile` first.",
			vim.log.levels.WARN,
			{ title = "dbt compile" }
		)
		return
	end
	vim.cmd("vsplit " .. path)
	vim.cmd("setlocal readonly nomodifiable")
end

if vim.fn.executable("dbt") == 1 then

-- ── run / build / test ────────────────────────────────────────────────────
overseer.register_template({
	name = "dbt run",
	builder = function()
		return { cmd = { "dbt", "run" }, cwd = vim.fn.getcwd(), components = bottom_output() }
	end,
})

overseer.register_template({
	name = "dbt run (current model)",
	builder = function()
		local model = vim.fn.expand("%:t:r")
		return {
			cmd = { "dbt", "run", "--select", model },
			name = "dbt run: " .. model,
			cwd = vim.fn.getcwd(),
			components = bottom_output(120),
		}
	end,
	condition = { filetype = { "sql", "jinja2" } },
})

-- dbt build = run + test + seed + snapshot in one pass (modern default).
overseer.register_template({
	name = "dbt build",
	builder = function()
		return { cmd = { "dbt", "build" }, cwd = vim.fn.getcwd(), components = bottom_output() }
	end,
})

overseer.register_template({
	name = "dbt build (current model)",
	builder = function()
		local model = vim.fn.expand("%:t:r")
		return {
			cmd = { "dbt", "build", "--select", model },
			name = "dbt build: " .. model,
			cwd = vim.fn.getcwd(),
			components = bottom_output(120),
		}
	end,
	condition = { filetype = { "sql", "jinja2" } },
})

overseer.register_template({
	name = "dbt test",
	builder = function()
		return { cmd = { "dbt", "test" }, cwd = vim.fn.getcwd(), components = bottom_output() }
	end,
})

overseer.register_template({
	name = "dbt test (current model)",
	builder = function()
		local model = vim.fn.expand("%:t:r")
		return {
			cmd = { "dbt", "test", "--select", model },
			name = "dbt test: " .. model,
			cwd = vim.fn.getcwd(),
			components = bottom_output(120),
		}
	end,
	condition = { filetype = { "sql", "jinja2" } },
})

-- ── compile / show (the killer workflow) ─────────────────────────────────
-- Compiles, then opens target/compiled/.../<model>.sql in a vertical split,
-- read-only. Review expanded Jinja, copy/paste into DBUI to run on Snowflake.
overseer.register_template({
	name = "dbt compile (current model) — open compiled SQL",
	builder = function()
		local model = vim.fn.expand("%:t:r")
		return {
			cmd = { "dbt", "compile", "--select", model },
			name = "dbt compile: " .. model,
			cwd = vim.fn.getcwd(),
			components = {
				{ "on_complete_notify", statuses = { "SUCCESS", "FAILURE" } },
				{ "unique", replace = true },
				"on_exit_set_status",
				{ "on_complete_dispose", timeout = 120 },
				{
					"on_complete_callback",
					callback = function(task, status)
						if status == "SUCCESS" then
							vim.schedule(function() open_compiled_model(model) end)
						end
					end,
				},
			},
		}
	end,
	condition = { filetype = { "sql", "jinja2" } },
})

overseer.register_template({
	name = "dbt compile",
	builder = function()
		return {
			cmd = { "dbt", "compile" },
			cwd = vim.fn.getcwd(),
			components = {
				{ "on_complete_notify", statuses = { "SUCCESS", "FAILURE" } },
				{ "unique", replace = true },
				"on_exit_set_status",
				{ "on_complete_dispose", timeout = 120 },
			},
		}
	end,
})

-- dbt show — preview compiled SQL inline without materialising the model.
overseer.register_template({
	name = "dbt show (current model)",
	builder = function()
		local model = vim.fn.expand("%:t:r")
		return {
			cmd = { "dbt", "show", "--select", model, "--limit", "20" },
			name = "dbt show: " .. model,
			cwd = vim.fn.getcwd(),
			components = bottom_output(120),
		}
	end,
	condition = { filetype = { "sql", "jinja2" } },
})

-- ── selector variants (run with parents / children / state / tag) ────────
overseer.register_template({
	name = "dbt run (current model + parents)",
	builder = function()
		local model = vim.fn.expand("%:t:r")
		return {
			cmd = { "dbt", "run", "--select", "+" .. model },
			name = "dbt run: +" .. model,
			cwd = vim.fn.getcwd(),
			components = bottom_output(300),
		}
	end,
	condition = { filetype = { "sql", "jinja2" } },
})

overseer.register_template({
	name = "dbt run (current model + children)",
	builder = function()
		local model = vim.fn.expand("%:t:r")
		return {
			cmd = { "dbt", "run", "--select", model .. "+" },
			name = "dbt run: " .. model .. "+",
			cwd = vim.fn.getcwd(),
			components = bottom_output(300),
		}
	end,
	condition = { filetype = { "sql", "jinja2" } },
})

overseer.register_template({
	name = "dbt run (state:modified — slim CI)",
	builder = function()
		-- Requires `--state <path>` to a previous manifest. Edit if you keep
		-- state elsewhere (e.g. target/prev_run). Runs only models changed
		-- since the state manifest — ideal for fast slim CI builds.
		return {
			cmd = { "dbt", "run", "--select", "state:modified", "--state", "target/prev_run" },
			cwd = vim.fn.getcwd(),
			components = bottom_output(300),
		}
	end,
})

overseer.register_template({
	name = "dbt run (tag prompt)",
	builder = function(params)
		local tag = params and params.tag or ""
		return {
			cmd = { "dbt", "run", "--select", "tag:" .. tag },
			name = "dbt run: tag:" .. tag,
			cwd = vim.fn.getcwd(),
			components = bottom_output(300),
		}
	end,
	params = {
		{ key = "tag", desc = "Tag name to run", optional = false },
	},
})

-- ── seed / snapshot / deps / docs ────────────────────────────────────────
overseer.register_template({
	name = "dbt seed",
	builder = function()
		return { cmd = { "dbt", "seed" }, cwd = vim.fn.getcwd(), components = bottom_output(300) }
	end,
})

overseer.register_template({
	name = "dbt snapshot",
	builder = function()
		return { cmd = { "dbt", "snapshot" }, cwd = vim.fn.getcwd(), components = bottom_output(300) }
	end,
})

overseer.register_template({
	name = "dbt deps",
	builder = function()
		return { cmd = { "dbt", "deps" }, cwd = vim.fn.getcwd(), components = bottom_output(300) }
	end,
})

overseer.register_template({
	name = "dbt docs generate",
	builder = function()
		return {
			cmd = { "dbt", "docs", "generate" },
			cwd = vim.fn.getcwd(),
			components = bottom_output(300),
		}
	end,
})

-- ── fast pre-flight checks (no DB connection) ────────────────────────────
overseer.register_template({
	name = "dbt parse",
	builder = function()
		return {
			cmd = { "dbt", "parse" },
			cwd = vim.fn.getcwd(),
			components = bottom_output(60),
		}
	end,
})

overseer.register_template({
	name = "dbt ls",
	builder = function()
		return {
			cmd = { "dbt", "ls" },
			cwd = vim.fn.getcwd(),
			components = bottom_output(60),
		}
	end,
})

overseer.register_template({
	name = "dbt debug",
	builder = function()
		return {
			cmd = { "dbt", "debug" },
			cwd = vim.fn.getcwd(),
			components = bottom_output(60),
		}
	end,
})
end -- vim.fn.executable("dbt")