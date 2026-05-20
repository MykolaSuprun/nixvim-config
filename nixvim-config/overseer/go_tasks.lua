-- Go overseer task templates
local overseer = require("overseer")

-- go build: compile all packages.
overseer.register_template({
	name = "go build",
	builder = function()
		return {
			cmd = { "go", "build", "./..." },
			cwd = vim.fn.getcwd(),
			components = {
				{ "on_output_quickfix", open = true, set_diagnostics = true },
				{ "unique", replace = true },
				"on_exit_set_status",
				{ "on_complete_dispose", timeout = 120 },
			},
		}
	end,
	condition = { filetype = { "go" } },
})

-- go test: run all tests in the project.
overseer.register_template({
	name = "go test (project)",
	builder = function()
		return {
			cmd = { "go", "test", "-v", "./..." },
			cwd = vim.fn.getcwd(),
			components = {
				{ "open_output", direction = "bottom", on_start = "always" },
				{ "unique", replace = true },
				"on_exit_set_status",
				{ "on_complete_dispose", timeout = 300 },
			},
		}
	end,
	condition = { filetype = { "go" } },
})

-- go test: run tests for the current file's package only.
overseer.register_template({
	name = "go test (current package)",
	builder = function()
		local pkg_dir = vim.fn.expand("%:p:h")
		return {
			cmd = { "go", "test", "-v", pkg_dir },
			cwd = vim.fn.getcwd(),
			components = {
				{ "open_output", direction = "bottom", on_start = "always" },
				{ "unique", replace = true },
				"on_exit_set_status",
				{ "on_complete_dispose", timeout = 120 },
			},
		}
	end,
	condition = { filetype = { "go" } },
})

-- go vet: static analysis.
overseer.register_template({
	name = "go vet",
	builder = function()
		return {
			cmd = { "go", "vet", "./..." },
			cwd = vim.fn.getcwd(),
			components = {
				{ "on_output_quickfix", open = true, set_diagnostics = true },
				{ "unique", replace = true },
				"on_exit_set_status",
				{ "on_complete_dispose", timeout = 60 },
			},
		}
	end,
	condition = { filetype = { "go" } },
})

-- golangci-lint: comprehensive linting with diagnostic integration.
overseer.register_template({
	name = "go golangci-lint",
	builder = function()
		return {
			cmd = { "golangci-lint", "run", "./..." },
			cwd = vim.fn.getcwd(),
			components = {
				{
					"on_output_parse",
					problem_matcher = {
						owner = "golangci-lint",
						fileLocation = "relative",
						pattern = {
							{
								regexp = "^(.+):(\\d+):(\\d+): (.+)$",
								file = 1,
								line = 2,
								column = 3,
								message = 4,
							},
						},
					},
				},
				{ "on_result_diagnostics", remove_on_restart = true },
				{ "unique", replace = true },
				"on_exit_set_status",
				{ "on_complete_dispose", timeout = 300 },
			},
		}
	end,
	condition = { filetype = { "go" } },
})
