-- C/C++ overseer task templates (clang ecosystem).
-- Tools come from extraPackages in dependencies.nix (clang-tools, cmake,
-- cppcheck, bear), so no PATH guards are needed here.
local overseer = require("overseer")

local cc_filetypes = { "c", "cpp", "objc", "objcpp" }

local default_components = {
	{ "unique", replace = true },
	"on_exit_set_status",
	{ "on_complete_dispose", timeout = 300 },
}

-- cmake configure: fresh build dir with the compilation database exported
-- for clangd (compile_commands.json lands in build/, which clangd finds
-- automatically; symlink to project root if your layout differs).
overseer.register_template({
	name = "cmake configure",
	builder = function()
		return {
			cmd = { "cmake", "-S", ".", "-B", "build", "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON" },
			cwd = vim.fn.getcwd(),
			components = {
				{ "on_output_quickfix", open = true, set_diagnostics = true },
				{ "open_output", direction = "bottom", on_start = "always" },
				unpack(default_components),
			},
		}
	end,
	condition = { filetype = cc_filetypes },
})

-- cmake build: incremental build of the configured build dir.
overseer.register_template({
	name = "cmake build",
	builder = function()
		return {
			cmd = { "cmake", "--build", "build", "-j" },
			cwd = vim.fn.getcwd(),
			components = {
				{ "on_output_quickfix", open = true, set_diagnostics = true },
				unpack(default_components),
			},
		}
	end,
	condition = { filetype = cc_filetypes },
})

-- ctest: run the project test suite through CMake's test runner
-- (framework-agnostic; neotest-gtest covers per-test runs).
overseer.register_template({
	name = "ctest",
	builder = function()
		return {
			cmd = { "ctest", "--test-dir", "build", "--output-on-failure" },
			cwd = vim.fn.getcwd(),
			components = {
				{ "open_output", direction = "bottom", on_start = "always" },
				unpack(default_components),
			},
		}
	end,
	condition = { filetype = cc_filetypes },
})

-- make: plain Makefile projects.
overseer.register_template({
	name = "make",
	builder = function()
		local jobs = vim.loop.available_parallelism()
		return {
			cmd = { "make", "-j" .. tostring(jobs) },
			cwd = vim.fn.getcwd(),
			components = {
				{ "on_output_quickfix", open = true, set_diagnostics = true },
				unpack(default_components),
			},
		}
	end,
	condition = { filetype = cc_filetypes },
})

-- bear + make: record a full build into compile_commands.json so clangd
-- gets accurate flags on non-CMake projects. Run after a clean when flags
-- change.
overseer.register_template({
	name = "bear make (regenerate compile_commands.json)",
	builder = function()
		local jobs = vim.loop.available_parallelism()
		return {
			cmd = { "bear", "--", "make", "-j" .. tostring(jobs) },
			cwd = vim.fn.getcwd(),
			components = {
				{ "open_output", direction = "bottom", on_start = "always" },
				unpack(default_components),
			},
		}
	end,
	condition = { filetype = cc_filetypes },
})

-- clang-tidy on the current file, using the build dir's compilation
-- database. In-editor tidy diagnostics already come from clangd itself;
-- this template is for a deliberate re-check with full output.
overseer.register_template({
	name = "clang-tidy (current file)",
	builder = function()
		local file = vim.fn.expand("%:p")
		return {
			cmd = { "clang-tidy", "-p", "build", file },
			cwd = vim.fn.getcwd(),
			components = {
				{
					"on_output_parse",
					problem_matcher = {
						owner = "clang-tidy",
						fileLocation = "absolute",
						pattern = {
							{
								regexp = "^(.+):(\\d+):(\\d+): (warning|error): (.*)$",
								file = 1,
								line = 2,
								column = 3,
								severity = 4,
								message = 5,
							},
						},
					},
				},
				{ "on_result_diagnostics", remove_on_restart = true },
				unpack(default_components),
			},
		}
	end,
	condition = { filetype = cc_filetypes },
})

-- cppcheck across the whole project via the compilation database.
-- Independent bug-finder from clang's analyzers — catches different issues.
overseer.register_template({
	name = "cppcheck (project)",
	builder = function()
		return {
			cmd = {
				"cppcheck",
				"--project=build/compile_commands.json",
				"--enable=warning,style,performance,portability",
				"--inline-suppr",
				"--suppress=missingIncludeSystem",
				"-j" .. tostring(vim.loop.available_parallelism()),
			},
			cwd = vim.fn.getcwd(),
			components = {
				{
					"on_output_parse",
					problem_matcher = {
						owner = "cppcheck",
						fileLocation = "relative",
						pattern = {
							{
								regexp = "^(.+):(\\d+):(\\d+): \\w+: (.*)$",
								file = 1,
								line = 2,
								column = 3,
								message = 4,
							},
						},
					},
				},
				{ "on_result_diagnostics", remove_on_restart = true },
				unpack(default_components),
			},
		}
	end,
	condition = { filetype = cc_filetypes },
})
