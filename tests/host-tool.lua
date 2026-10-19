-- Isolated tool-resolution and SQL-cancellation tests. No subprocess, browser,
-- OrbStack command, or database connection is started by this suite.
-- Run through tests/run.sh against the built config. NIXVIM_TEST_HOST_TOOL_LUA
-- can point at an extracted source module while iterating before a rebuild.

local failures = {}
local checks = 0

local function check(name, ok, detail)
	checks = checks + 1
	if ok then
		print("PASS  " .. name)
	else
		local message = name .. (detail and (" — " .. tostring(detail)) or "")
		failures[#failures + 1] = message
		print("FAIL  " .. message)
	end
end

local function module_path(name)
	local path = name == "host_tool" and vim.env.NIXVIM_TEST_HOST_TOOL_LUA
	return path or assert(vim.api.nvim_get_runtime_file("lua/" .. name .. ".lua", false)[1], name .. " module missing")
end

local function load_module(name, stub, dependencies)
	local chunk = assert(loadfile(module_path(name)))
	setfenv(
		chunk,
		setmetatable({
			vim = stub,
			require = function(dependency)
				return assert(dependencies and dependencies[dependency], "unexpected dependency: " .. dependency)
			end,
		}, { __index = _G })
	)
	return chunk()
end

local function host_fixture(options)
	options = options or {}
	local probes = {}
	local filesystem_checks = 0
	local executables = options.executables or {}
	local stub = {
		g = { host_tools_prefer_local = options.prefer_local },
		env = vim.deepcopy(options.env or {}),
		uv = {
			os_uname = function()
				return { sysname = options.sysname or "Darwin", release = options.release or "test" }
			end,
		},
		fn = {
			executable = function(name)
				return executables[name] and 1 or 0
			end,
			system = function(argv)
				probes[#probes + 1] = vim.deepcopy(argv)
			end,
			isdirectory = function()
				filesystem_checks = filesystem_checks + 1
				return 1
			end,
		},
		v = { shell_error = options.host_missing and 1 or 0 },
		deepcopy = vim.deepcopy,
		list_extend = vim.list_extend,
	}
	return load_module("host_tool", stub), stub, probes, function()
		return filesystem_checks
	end
end

local native, native_vim, native_probes, native_fs_checks = host_fixture({ executables = { mac = true } })
check("native macOS ignores a same-named mac command", native.is_orbstack() == false)
native.setup()
check("native setup leaves connection and browser configuration untouched", next(native_vim.env) == nil)
check("native setup does not inspect guest mounts", native_fs_checks() == 0)
check(
	"standalone native sqlit retains the bundled PATH fallback",
	vim.deep_equal(native.runner("sqlit"), {
		prefix = { "sqlit" },
		host = false,
	})
)
check("native resolution never probes OrbStack", #native_probes == 0)

local binary = "/test/home manager/bin/sqlit"
local configured, _, configured_probes = host_fixture({
	executables = { mac = true, [binary] = true, ["/test/bin/snow"] = true },
	env = { NIXVIM_SQLIT_BINARY = binary, NIXVIM_SNOW_BINARY = "/test/bin/snow" },
})
check(
	"native sqlit uses the Home Manager executable",
	vim.deep_equal(configured.runner("sqlit"), {
		prefix = { binary },
		host = false,
	})
)
check("native snow supports its own optional executable", configured.cmd("snow")[1] == "/test/bin/snow")
check(
	"configured argv preserves spaces and SQL as literal arguments",
	vim.deep_equal(
		configured.cmd("sqlit", { "query", "-q", "select '$HOME; `id`'" }),
		{ binary, "query", "-q", "select '$HOME; `id`'" }
	)
)
check("configured native tools never probe OrbStack", #configured_probes == 0)

for _, case in ipairs({
	{ path = "relative/bin/sqlit", message = "must be an absolute executable path" },
	{ path = "/missing/sqlit", message = "is not executable" },
}) do
	local invalid = host_fixture({ env = { NIXVIM_SQLIT_BINARY = case.path } })
	local ok, err = pcall(invalid.runner, "sqlit")
	check(
		"invalid explicit override fails clearly: " .. case.path,
		not ok
			and tostring(err):find("NIXVIM_SQLIT_BINARY", 1, true) ~= nil
			and tostring(err):find(case.message, 1, true) ~= nil,
		err
	)
end

local empty = host_fixture({ env = { NIXVIM_SQLIT_BINARY = "" } })
check("an empty override keeps standalone resolution", empty.runner("sqlit").prefix[1] == "sqlit")
local linux, _, linux_probes = host_fixture({ sysname = "Linux" })
check("ordinary Linux keeps local tools", not linux.runner("snow").host and #linux_probes == 0)

local guest, _, guest_probes = host_fixture({
	sysname = "Linux",
	executables = { mac = true },
	-- A local-only path may not exist in a guest; the host preference must win.
	env = { NIXVIM_SQLIT_BINARY = "/mac-only/sqlit" },
})
check(
	"OrbStack retains macOS host preference",
	vim.deep_equal(guest.runner("sqlit"), {
		prefix = { "mac", "sqlit" },
		host = true,
	})
)
guest.runner("sqlit")
check("OrbStack probes each host tool once", #guest_probes == 1)
check(
	"OrbStack probes through its login shell",
	vim.deep_equal(guest_probes[1], {
		"mac",
		"sh",
		"-lc",
		"command -v sqlit >/dev/null 2>&1",
	})
)

local kernel_guest = host_fixture({ sysname = "Linux", release = "6.12-orbstack-1" })
check("OrbStack kernel detection remains available", kernel_guest.runner("snow").host)
local guest_fallback = host_fixture({
	sysname = "Linux",
	host_missing = true,
	executables = { mac = true, [binary] = true },
	env = { NIXVIM_SQLIT_BINARY = binary },
})
check(
	"a missing OrbStack host tool uses the configured local fallback",
	vim.deep_equal(guest_fallback.runner("sqlit"), { prefix = { binary }, host = false })
)
local forced, _, forced_probes = host_fixture({
	sysname = "Linux",
	prefer_local = true,
	executables = { mac = true, [binary] = true },
	env = { NIXVIM_SQLIT_BINARY = binary },
})
check(
	"prefer_local uses the configured local tool without a host probe",
	forced.runner("sqlit").prefix[1] == binary and #forced_probes == 0
)

-- Guard the existing arbitrary-SQL confirmation boundary using cancelled runs.
-- A resolver or process call would be a test failure; no query is executed.
local confirmations, resolutions, processes = 0, 0, 0
local runner_vim = {
	env = { SQLIT_CONFIG_DIR = "/test/config/sqlit" },
	fn = {
		confirm = function(_, _, default)
			confirmations = confirmations + 1
			assert(default == 2, "SQL confirmation must default to Cancel")
			return 2
		end,
		filereadable = function()
			return 1
		end,
		readfile = function()
			return { '[{"name":"test-connection"}]' }
		end,
	},
	json = vim.json,
	islist = vim.islist,
	ui = {
		select = function(items, _, callback)
			callback(items[1])
		end,
	},
	system = function()
		processes = processes + 1
	end,
}
local sql_runner = load_module("sql_runner", runner_vim, {
	host_tool = {
		runner = function()
			resolutions = resolutions + 1
			error("cancelled SQL reached tool resolution")
		end,
	},
	query_result = {},
})
sql_runner.snow_run("DROP TABLE example")
sql_runner.sqlit_run("DELETE FROM example")
check("snow and sqlit arbitrary SQL still ask before execution", confirmations == 2)
check("cancelled SQL never resolves or starts a tool", resolutions == 0 and processes == 0)

print(("\n%d checks, %d failures"):format(checks, #failures))
if #failures > 0 then
	vim.cmd("cquit 1")
else
	vim.cmd("qa!")
end
