-- Nix overseer task templates
local overseer = require("overseer")

-- alejandra: format the current file in-place.
overseer.register_template({
	name = "nix alejandra format (file)",
	builder = function()
		return {
			cmd = { "alejandra", vim.fn.expand("%:p") },
			components = {
				{ "on_complete_notify", statuses = { "SUCCESS", "FAILURE" } },
				{ "unique", replace = true },
				"on_exit_set_status",
				{ "on_complete_dispose", timeout = 30 },
			},
		}
	end,
	condition = { filetype = { "nix" } },
})

-- alejandra: format the entire project.
overseer.register_template({
	name = "nix alejandra format (project)",
	builder = function()
		return {
			cmd = { "alejandra", "." },
			cwd = vim.fn.getcwd(),
			components = {
				{ "on_complete_notify", statuses = { "SUCCESS", "FAILURE" } },
				{ "unique", replace = true },
				"on_exit_set_status",
				{ "on_complete_dispose", timeout = 60 },
			},
		}
	end,
})

-- statix: lint with diagnostic integration.
overseer.register_template({
	name = "nix statix check",
	builder = function()
		return {
			cmd = { "statix", "check", "." },
			cwd = vim.fn.getcwd(),
			components = {
				{ "open_output", direction = "bottom", on_start = "if_no_on_output_quickfix" },
				{ "on_output_quickfix", open = false, set_diagnostics = true },
				{ "on_result_diagnostics", remove_on_restart = true },
				{ "unique", replace = true },
				"on_exit_set_status",
				{ "on_complete_dispose", timeout = 30 },
			},
		}
	end,
})

-- deadnix: find dead code in Nix files.
overseer.register_template({
	name = "nix deadnix",
	builder = function()
		return {
			cmd = { "deadnix", "." },
			cwd = vim.fn.getcwd(),
			components = {
				{ "open_output", direction = "bottom", on_start = "always" },
				{ "unique", replace = true },
				"on_exit_set_status",
				{ "on_complete_dispose", timeout = 30 },
			},
		}
	end,
})

-- nix flake check: validate the whole flake (can be slow).
overseer.register_template({
	name = "nix flake check",
	builder = function()
		return {
			cmd = { "nix", "flake", "check" },
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

-- nix build: build the default package.
overseer.register_template({
	name = "nix build",
	builder = function()
		return {
			cmd = { "nix", "build", "." },
			cwd = vim.fn.getcwd(),
			components = {
				{ "open_output", direction = "bottom", on_start = "always" },
				{ "on_complete_notify", statuses = { "SUCCESS", "FAILURE" } },
				{ "unique", replace = true },
				"on_exit_set_status",
				{ "on_complete_dispose", timeout = 1800 },
			},
		}
	end,
})
