-- Python overseer task templates
-- Replaces the old test_tasks.lua with a comprehensive set of tasks.
local overseer = require("overseer")

-- Run the current buffer as a Python script; output goes to a bottom split.
overseer.register_template({
	name = "python run (current file)",
	builder = function()
		return {
			cmd = { "python" },
			args = { vim.fn.expand("%:p") },
			cwd = vim.fn.getcwd(),
			components = {
				{ "open_output", direction = "bottom", on_start = "always" },
				{ "unique", replace = true },
				"on_exit_set_status",
				{ "on_complete_dispose", timeout = 60 },
			},
		}
	end,
	condition = { filetype = { "python" } },
})

-- ruff format the whole project in-place.
overseer.register_template({
	name = "python ruff format (project)",
	builder = function()
		return {
			cmd = { "ruff", "format", "." },
			cwd = vim.fn.getcwd(),
			components = {
				{ "on_complete_notify", statuses = { "SUCCESS", "FAILURE" } },
				{ "unique", replace = true },
				"on_exit_set_status",
				{ "on_complete_dispose", timeout = 30 },
			},
		}
	end,
})

-- pytest for the current file with verbose output and diagnostic integration.
overseer.register_template({
	name = "python pytest (current file)",
	builder = function()
		return {
			cmd = { "pytest" },
			args = { vim.fn.expand("%:p"), "-v" },
			cwd = vim.fn.getcwd(),
			components = {
				{ "open_output", direction = "bottom", on_start = "always" },
				{
					"on_output_parse",
					problem_matcher = {
						owner = "pytest",
						fileLocation = "relative",
						severity = "error",
						pattern = {
							{
								regexp = "^(.+):(\\d+): (.+)$",
								file = 1,
								line = 2,
								message = 3,
							},
						},
					},
				},
				{ "on_result_diagnostics", remove_on_restart = true },
				{ "unique", replace = true },
				"on_exit_set_status",
				{ "on_complete_dispose", timeout = 120 },
			},
		}
	end,
	condition = { filetype = { "python" } },
})

-- pytest for the whole project.
overseer.register_template({
	name = "python pytest (project)",
	builder = function()
		return {
			cmd = { "pytest", "-v", "." },
			cwd = vim.fn.getcwd(),
			components = {
				{ "open_output", direction = "bottom", on_start = "always" },
				{ "unique", replace = true },
				"on_exit_set_status",
				{ "on_complete_dispose", timeout = 300 },
			},
		}
	end,
})

-- mypy static type checking — results in quickfix.
overseer.register_template({
	name = "python mypy (project)",
	builder = function()
		return {
			cmd = { "mypy", "." },
			cwd = vim.fn.getcwd(),
			components = {
				{ "on_output_quickfix", open = true, set_diagnostics = true },
				{ "unique", replace = true },
				"on_exit_set_status",
				{ "on_complete_dispose", timeout = 120 },
			},
		}
	end,
})
