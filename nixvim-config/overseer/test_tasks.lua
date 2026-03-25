-- Register python run template for the current buffer
local overseer = require("overseer")

overseer.register_template({
	name = "python run (current file)",
	builder = function()
		return {
			cmd = { "python" },
			args = { vim.fn.expand("%:p") },
			cwd = vim.fn.getcwd(),
			components = {
				"default",
				{ "on_complete_dispose", timeout = 30 },
			},
		}
	end,
	condition = {
		filetype = { "python" },
	},
})

overseer.register_template({
	name = "python test (pytest - current file)",
	builder = function()
		return {
			cmd = { "pytest" },
			args = { vim.fn.expand("%:p"), "-v" },
			cwd = vim.fn.getcwd(),
			components = {
				"default",
				{ "on_complete_dispose", timeout = 30 },
			},
		}
	end,
	condition = {
		filetype = { "python" },
	},
})
