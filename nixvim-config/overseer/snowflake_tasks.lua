-- Snowflake overseer task templates, driven by the `snow` CLI (snowflake-cli).
-- Templates only register when `snow` is on PATH. Connections come from
-- `~/.snowflake/config.toml` (or $SNOWFLAKE_HOME) connection profiles — never
-- from inline --password flags, so no credential ever appears in overseer's
-- task list, shell history, or `:OverseerRun` picker.
--
-- Safety model:
-- * Read-only templates (`describe`, `list`, `preview`) run unprompted.
-- * Anything that executes arbitrary/current-buffer SQL goes through
--   `vim.fn.confirm` first, since a dbt/.sql buffer can contain
--   DROP/DELETE/TRUNCATE/MERGE and overseer has no undo.
-- * No template ever runs a whole *project* of SQL files unattended (unlike
--   dbt run/build, there is no dbt-style DAG/state guarding what executes).
-- * For a persistent interactive session, use betterTerm (<leader>Xt) + bare
--   `snow sql` (the REPL; `-i` is --stdin, not --interactive), not an overseer
--   template — overseer output panes are one-shot and not meant for a
--   back-and-forth session.
local overseer = require("overseer")
-- Host-tool resolution (lua/host_tool.lua): inside an OrbStack machine,
-- `snow` runs on the macOS host via the `mac` shim when a host install
-- exists — externalbrowser OAuth then uses the Mac browser + Keychain.
local host_tool = require("host_tool")

-- Shared component bundle (lua/overseer_helpers.lua).
local bottom_output = require("overseer_helpers").bottom_output

-- Ask before running anything that executes arbitrary SQL text. Returns true
-- if the user confirmed, false otherwise. `preview` is shown truncated so a
-- large buffer/selection doesn't blow up the confirm dialog.
local function confirm_run_sql(preview)
	local snippet = preview:gsub("%s+", " "):sub(1, 200)
	local choice = vim.fn.confirm(
		"Run this against Snowflake?\n\n" .. snippet .. (#preview > 200 and " …" or ""),
		"&Run\n&Cancel",
		2 -- default to Cancel
	)
	return choice == 1
end

-- overseer's template.lua indexes the builder's return value unconditionally
-- (`task_defn.components = ...`) — a builder MUST NOT return nil. When the
-- user declines confirm_run_sql, hand back this harmless no-op task instead
-- of the real Snowflake command.
local function cancelled_task(name)
	vim.notify("snowflake: cancelled — nothing was sent to Snowflake", vim.log.levels.INFO, { title = name })
	return {
		cmd = { "true" },
		name = name .. " (cancelled)",
		components = { "on_exit_set_status", { "on_complete_dispose", timeout = 1 } },
	}
end

if vim.fn.executable("snow") == 1 then

-- ── read-only exploration (safe to run unprompted) ───────────────────────
overseer.register_template({
	name = "snowflake: describe current table/view (cursor word)",
	builder = function()
		-- <cword> stops at '.', so a qualified name (DB.SCHEMA.TABLE) would be
		-- truncated to its last segment; <cWORD> keeps the dots but can include
		-- trailing punctuation (e.g. the ';' in "select * from DB.S.T;"), so
		-- strip non-identifier characters from both ends.
		local object = vim.fn.expand("<cWORD>"):gsub("^[^%w_]+", ""):gsub("[^%w_%.]+$", "")
		return {
			cmd = host_tool.cmd("snow", { "sql", "-q", "describe table " .. object, "--format", "JSON", "--enhanced-exit-codes" }),
			name = "snowflake describe: " .. object,
			cwd = vim.fn.getcwd(),
			components = bottom_output(60),
		}
	end,
	condition = { filetype = { "sql", "jinja2" } },
})

overseer.register_template({
	name = "snowflake: list warehouses",
	builder = function()
		return {
			cmd = host_tool.cmd("snow", { "object", "list", "warehouse" }),
			cwd = vim.fn.getcwd(),
			components = bottom_output(60),
		}
	end,
})

overseer.register_template({
	name = "snowflake: list databases",
	builder = function()
		return {
			cmd = host_tool.cmd("snow", { "object", "list", "database" }),
			cwd = vim.fn.getcwd(),
			components = bottom_output(60),
		}
	end,
})

overseer.register_template({
	name = "snowflake: list tables (prompt database.schema)",
	builder = function(params)
		local scope = params and params.schema or ""
		local cmd = host_tool.cmd("snow", { "object", "list", "table" })
		if scope ~= "" then
			-- "--in schema <db.schema>" scopes the listing; `scope` is passed
			-- as a single argv element (no shell involved), so this is safe
			-- even if it contains spaces/quotes.
			table.insert(cmd, "--in")
			table.insert(cmd, "schema")
			table.insert(cmd, scope)
		end
		return {
			cmd = cmd,
			name = "snowflake list tables" .. (scope ~= "" and ": " .. scope or ""),
			cwd = vim.fn.getcwd(),
			components = bottom_output(60),
		}
	end,
	-- params must be keyed by name (`{ schema = {...} }`), not
	-- `{ key = "schema" }` — see dbt_tasks.lua "dbt run (tag prompt)".
	params = {
		schema = { desc = "db.schema to scope to (optional)", optional = true },
	},
})

overseer.register_template({
	name = "snowflake: connection test",
	builder = function()
		return {
			cmd = host_tool.cmd("snow", { "connection", "test" }),
			cwd = vim.fn.getcwd(),
			components = bottom_output(60),
		}
	end,
})

overseer.register_template({
	name = "snowflake: connection list",
	builder = function()
		return {
			cmd = host_tool.cmd("snow", { "connection", "list" }),
			cwd = vim.fn.getcwd(),
			components = bottom_output(30),
		}
	end,
})

-- ── running SQL (confirm before every one — see confirm_run_sql) ─────────
overseer.register_template({
	name = "snowflake: run current line",
	builder = function()
		local line = vim.api.nvim_get_current_line()
		if not confirm_run_sql(line) then
			return cancelled_task("snowflake run: current line")
		end
		return {
			cmd = host_tool.cmd("snow", { "sql", "-q", line, "--enable-templating", "NONE", "--enhanced-exit-codes" }),
			name = "snowflake run: current line",
			cwd = vim.fn.getcwd(),
			components = bottom_output(120),
		}
	end,
	condition = { filetype = { "sql", "jinja2" } },
})

overseer.register_template({
	name = "snowflake: run visual selection",
	builder = function()
		local query = require("overseer_helpers").visual_selection()
		if not query then
			return cancelled_task("snowflake run: selection")
		end
		if not confirm_run_sql(query) then
			return cancelled_task("snowflake run: selection")
		end
		return {
			cmd = host_tool.cmd("snow", { "sql", "-q", query, "--enable-templating", "NONE", "--enhanced-exit-codes" }),
			name = "snowflake run: selection",
			cwd = vim.fn.getcwd(),
			components = bottom_output(120),
		}
	end,
	condition = { filetype = { "sql", "jinja2" } },
})

-- Runs the *compiled* SQL file (target/compiled/…/<model>.sql), never the
-- dbt source model directly — the source still has unexpanded Jinja
-- ({{ ref(...) }}, {% ... %}) that `snow sql` cannot execute as-is.
overseer.register_template({
	name = "snowflake: run compiled SQL for current dbt model",
	builder = function()
		local model = vim.fn.expand("%:t:r")
		-- vim.fs.find (pure Lua directory walk) rather than shelling out to
		-- `find` — `model` comes from the current buffer name and must never
		-- be spliced into a shell command string. See dbt_tasks.lua
		-- open_compiled_model for the same reasoning.
		local matches = vim.fs.find(model .. ".sql", { path = "target/compiled", type = "file", limit = 1 })
		local path = matches[1]
		if not path or path == "" then
			vim.notify(
				"snowflake: no compiled SQL found for '" .. model .. "'. Run `dbt compile` first.",
				vim.log.levels.WARN,
				{ title = "snowflake run compiled" }
			)
			return cancelled_task("snowflake run compiled: " .. model)
		end
		local preview = table.concat(vim.fn.readfile(path, "", 5), "\n")
		if not confirm_run_sql(preview) then
			return cancelled_task("snowflake run compiled: " .. model)
		end
		-- A host-run `snow` can't see VM paths: route the compiled SQL through
		-- the OrbStack shared mount and pass the host-visible path instead.
		local runner = host_tool.runner("snow")
		local arg_path = runner.host and host_tool.write_query_tmp(true, table.concat(vim.fn.readfile(path), "\n")) or path
		return {
			cmd = host_tool.cmd("snow", { "sql", "-f", arg_path, "--enable-templating", "NONE", "--enhanced-exit-codes" }),
			name = "snowflake run compiled: " .. model,
			cwd = vim.fn.getcwd(),
			components = bottom_output(300),
		}
	end,
	condition = { filetype = { "sql", "jinja2" } },
})

end -- vim.fn.executable("snow")
