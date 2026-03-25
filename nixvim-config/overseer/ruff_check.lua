-- Register the ruff check template with proper output parsing and diagnostics integration
require("overseer").register_template({
	name = "ruff check",
	builder = function(params)
		return {
			cmd = { "ruff" },
			-- Use concise format so each violation is on a single parseable line:
			-- path/to/file.py:line:col: CODE message
			args = { "check", "--output-format=concise", "." },
			cwd = vim.fn.getcwd(),
			components = {
				{
					"on_output_parse",
					-- VS Code-style problem matcher for ruff's concise output format:
					-- e.g. "src/foo.py:10:5: E501 Line too long (91 > 88 characters)"
					problem_matcher = {
						owner = "ruff",
						fileLocation = "relative",
						severity = "warning",
						pattern = {
							{
								regexp = "^(.+):(\\d+):(\\d+): (\\S+) (.+)$",
								file = 1,
								line = 2,
								column = 3,
								code = 4,
								message = 5,
							},
						},
					},
				},
				-- Display parsed diagnostics in neovim's diagnostic system
				{
					"on_result_diagnostics",
					remove_on_restart = true,
				},
				-- Ensure only one ruff check task runs at a time
				{
					"unique",
					replace = true,
				},
				"on_exit_set_status",
				{ "on_complete_dispose", timeout = 30 },
			},
		}
	end,
	condition = {
		filetype = { "python" },
	},
})

-- Auto-run ruff check whenever a Python file is saved
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*.py",
	callback = function()
		require("overseer").run_template({
			name = "ruff check",
			-- Take the first match without showing a picker
			first = true,
		})
	end,
})
