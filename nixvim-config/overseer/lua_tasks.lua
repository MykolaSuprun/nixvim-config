-- Lua overseer task templates
local overseer = require("overseer")

-- stylua: format the current file in-place.
overseer.register_template({
	name = "lua stylua format (file)",
	builder = function()
		return {
			cmd = { "stylua", vim.fn.expand("%:p") },
			components = {
				{ "on_complete_notify", statuses = { "SUCCESS", "FAILURE" } },
				{ "unique", replace = true },
				"on_exit_set_status",
				{ "on_complete_dispose", timeout = 30 },
			},
		}
	end,
	condition = { filetype = { "lua" } },
})

-- stylua: format the entire project.
overseer.register_template({
	name = "lua stylua format (project)",
	builder = function()
		return {
			cmd = { "stylua", "." },
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

-- selene: lint with diagnostic integration (matches the selene linter in lsp.nix).
overseer.register_template({
	name = "lua selene lint",
	builder = function()
		return {
			cmd = { "selene", "." },
			cwd = vim.fn.getcwd(),
			components = {
				{
					"on_output_parse",
					problem_matcher = {
						owner = "selene",
						fileLocation = "relative",
						pattern = {
							{
								-- selene output: path/to/file.lua:10:5: error[undeclared_variable]: ...
								regexp = "^(.+):(\\d+):(\\d+): (\\w+)\\[(.+)\\]: (.+)$",
								file = 1,
								line = 2,
								column = 3,
								severity = 4,
								code = 5,
								message = 6,
							},
						},
					},
				},
				{ "on_result_diagnostics", remove_on_restart = true },
				{ "unique", replace = true },
				"on_exit_set_status",
				{ "on_complete_dispose", timeout = 30 },
			},
		}
	end,
})
