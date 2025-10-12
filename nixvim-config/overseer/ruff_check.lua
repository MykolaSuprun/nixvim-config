-- Define a Ruff task
require("overseer").register_template({
	name = "ruff check",
	builder = function()
		return {
			cmd = { "ruff" },
			args = { "check", "." },
			components = { "on_output_parse", "default" },
		}
	end,
	condition = {
		filetype = { "python" },
	},
})
