-- dbt overseer task templates
-- Tasks are only registered when `dbt` is found on PATH at startup.
local overseer = require("overseer")

if vim.fn.executable("dbt") == 0 then
	return
end

-- dbt run: run all models.
overseer.register_template({
	name = "dbt run",
	builder = function()
		return {
			cmd = { "dbt", "run" },
			cwd = vim.fn.getcwd(),
			components = {
				{ "open_output", direction = "bottom", on_start = "always" },
				{ "on_complete_notify", statuses = { "SUCCESS", "FAILURE" } },
				{ "unique", replace = true },
				"on_exit_set_status",
				{ "on_complete_dispose", timeout = 600 },
			},
		}
	end,
})

-- dbt run (current model): derive the model name from the current filename stem.
overseer.register_template({
	name = "dbt run (current model)",
	builder = function()
		local model = vim.fn.expand("%:t:r")
		return {
			cmd = { "dbt", "run", "--select", model },
			name = "dbt run: " .. model,
			cwd = vim.fn.getcwd(),
			components = {
				{ "open_output", direction = "bottom", on_start = "always" },
				{ "on_complete_notify", statuses = { "SUCCESS", "FAILURE" } },
				{ "unique", replace = true },
				"on_exit_set_status",
				{ "on_complete_dispose", timeout = 120 },
			},
		}
	end,
	condition = { filetype = { "sql", "jinja2" } },
})

-- dbt test: run all tests.
overseer.register_template({
	name = "dbt test",
	builder = function()
		return {
			cmd = { "dbt", "test" },
			cwd = vim.fn.getcwd(),
			components = {
				{ "open_output", direction = "bottom", on_start = "always" },
				{ "on_complete_notify", statuses = { "SUCCESS", "FAILURE" } },
				{ "unique", replace = true },
				"on_exit_set_status",
				{ "on_complete_dispose", timeout = 600 },
			},
		}
	end,
})

-- dbt test (current model): test the model derived from the current filename stem.
overseer.register_template({
	name = "dbt test (current model)",
	builder = function()
		local model = vim.fn.expand("%:t:r")
		return {
			cmd = { "dbt", "test", "--select", model },
			name = "dbt test: " .. model,
			cwd = vim.fn.getcwd(),
			components = {
				{ "open_output", direction = "bottom", on_start = "always" },
				{ "on_complete_notify", statuses = { "SUCCESS", "FAILURE" } },
				{ "unique", replace = true },
				"on_exit_set_status",
				{ "on_complete_dispose", timeout = 120 },
			},
		}
	end,
	condition = { filetype = { "sql", "jinja2" } },
})

-- dbt compile: generate compiled SQL without running.
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

-- dbt deps: install / update dbt packages.
overseer.register_template({
	name = "dbt deps",
	builder = function()
		return {
			cmd = { "dbt", "deps" },
			cwd = vim.fn.getcwd(),
			components = {
				{ "open_output", direction = "bottom", on_start = "always" },
				{ "on_complete_notify", statuses = { "SUCCESS", "FAILURE" } },
				{ "unique", replace = true },
				"on_exit_set_status",
				{ "on_complete_dispose", timeout = 300 },
			},
		}
	end,
})

-- dbt docs generate: regenerate the documentation catalog.
overseer.register_template({
	name = "dbt docs generate",
	builder = function()
		return {
			cmd = { "dbt", "docs", "generate" },
			cwd = vim.fn.getcwd(),
			components = {
				{ "open_output", direction = "bottom", on_start = "always" },
				{ "on_complete_notify", statuses = { "SUCCESS", "FAILURE" } },
				{ "unique", replace = true },
				"on_exit_set_status",
				{ "on_complete_dispose", timeout = 300 },
			},
		}
	end,
})
