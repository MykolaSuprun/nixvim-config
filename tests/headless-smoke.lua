-- Headless smoke tests for the nixvim-config session changes (2026-09-22).
--
-- Run from the repo root:
--   tests/run.sh
-- or directly:
--   nvim --headless -c "luafile tests/headless-smoke.lua"
--
-- Exits non-zero when any check fails (cquit 1).
--
-- Covers: keymaps (opencode/agentic/snacks), overseer helpers + template
-- builders, dap-python adapter, render-markdown config, snacks dim/zen,
-- blink cmdline, nvim-lint ownership, herd opencode cmd, otter lazy spec,
-- opencode input-window keymaps.

local failures = {}
local checks = 0

local function check(name, ok, detail)
  checks = checks + 1
  if ok then
    print("PASS  " .. name)
  else
    local msg = name .. (detail ~= nil and (" — " .. tostring(detail)) or "")
    failures[#failures + 1] = msg
    print("FAIL  " .. msg)
  end
end

local function has_map(mode, lhs)
  for _, m in ipairs(vim.api.nvim_get_keymap(mode)) do
    if m.lhs == lhs then
      return m
    end
  end
  return nil
end

-- ── 1. keymaps ──────────────────────────────────────────────────────────
local L = vim.g.mapleader
for _, k in ipairs({ "OR", "Ow", "os", "oC", "oA", "uD", "uz" }) do
  check("keymap <leader>" .. k .. " (normal)", has_map("n", L .. k) ~= nil)
end
for _, k in ipairs({ "at", "an", "ar" }) do
  check("keymap <leader>" .. k .. " (normal)", has_map("n", L .. k) ~= nil)
  check("keymap <leader>" .. k .. " not in insert", has_map("i", L .. k) == nil)
end

-- ── 2. overseer helpers ─────────────────────────────────────────────────
local ok_ov, overseer = pcall(require, "overseer")
check("overseer loads", ok_ov, overseer)
if ok_ov then
  check("overseer.run_action is a function", type(overseer.run_action) == "function")
end

local ok_oh, helpers = pcall(require, "overseer_helpers")
check("overseer_helpers loads", ok_oh, helpers)
if ok_oh then
  local comps = helpers.bottom_output(60)
  check(
    "bottom_output(60) -> 5 components",
    type(comps) == "table" and #comps == 5,
    type(comps) == "table" and #comps or comps
  )
  vim.cmd("enew!")
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { "line one", "line two", "line three" })
  vim.fn.setpos("'<", { 0, 1, 1, 0 })
  vim.fn.setpos("'>", { 0, 2, 4, 0 })
  local sel = helpers.visual_selection()
  check("visual_selection returns marked text", sel == "line one\nline", vim.inspect(sel))
end

-- ── 3. overseer template files (sandboxed load) ─────────────────────────
-- Loads each template file with a stubbed `overseer.register_template` so the
-- builders can be exercised without a real task. `vim.fn.executable` and
-- `vim.fn.confirm` are stubbed so registration and confirm-gated builders are
-- deterministic regardless of which CLIs are on PATH.
local function capture_templates(path)
  local captured = {}
  local vim_proxy = setmetatable({
    fn = setmetatable({
      executable = function()
        return 1
      end,
      confirm = function()
        return 1
      end,
    }, { __index = vim.fn }),
  }, { __index = vim })
  local env = setmetatable({
    require = function(m)
      if m == "overseer" then
        return {
          register_template = function(defn)
            captured[#captured + 1] = defn
          end,
        }
      end
      return require(m)
    end,
    vim = vim_proxy,
  }, { __index = _G })
  local chunk = assert(loadfile(path, "t", env))
  chunk()
  return captured
end

local template_files = {
  "ruff_check.lua",
  "python_tasks.lua",
  "nix_tasks.lua",
  "go_tasks.lua",
  "lua_tasks.lua",
  "cc_tasks.lua",
  "dbt_tasks.lua",
  "snowflake_tasks.lua",
  "airflow_tasks.lua",
}

for _, f in ipairs(template_files) do
  local path = "nixvim-config/overseer/" .. f
  local ok, captured = pcall(capture_templates, path)
  check("template file loads: " .. f, ok, captured)
  if ok then
    check("template file registers templates: " .. f, #captured >= 1, #captured)
  end
end

-- snowflake flags (D13)
local ok_sf, sf = pcall(capture_templates, "nixvim-config/overseer/snowflake_tasks.lua")
if ok_sf then
  local describe, run_line, run_sel
  for _, t in ipairs(sf) do
    if t.name and t.name:find("describe") then
      describe = t
    elseif t.name and t.name:find("current line") then
      run_line = t
    elseif t.name and t.name:find("selection") then
      run_sel = t
    end
  end
  check("snowflake describe template registered", describe ~= nil)
  if describe then
    local task = describe.builder()
    local cmd = table.concat(task.cmd or {}, " ")
    check("snowflake describe --format JSON", cmd:find("%-%-format JSON") ~= nil, cmd)
    check("snowflake describe --enhanced-exit-codes", cmd:find("%-%-enhanced%-exit%-codes") ~= nil, cmd)
  end
  check("snowflake run-current-line template registered", run_line ~= nil)
  if run_line then
    vim.cmd("enew!")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { "select 1" })
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
    local task = run_line.builder()
    local cmd = table.concat(task.cmd or {}, " ")
    check("snowflake run-current-line --enhanced-exit-codes", cmd:find("%-%-enhanced%-exit%-codes") ~= nil, cmd)
  end
  check("snowflake run-selection template registered", run_sel ~= nil)
  if run_sel then
    vim.cmd("enew!")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { "select 1", "select 2" })
    vim.fn.setpos("'<", { 0, 1, 1, 0 })
    vim.fn.setpos("'>", { 0, 2, 8, 0 })
    local task = run_sel.builder()
    local cmd = table.concat(task.cmd or {}, " ")
    check("snowflake run-selection --enhanced-exit-codes", cmd:find("%-%-enhanced%-exit%-codes") ~= nil, cmd)
  end
end

-- ── 4. dap-python adapter (W12) ─────────────────────────────────────────
local dap = require("dap")
check("dap.adapters.python is a function", type(dap.adapters.python) == "function")
local adapter
dap.adapters.python(function(a)
  adapter = a
end, { request = "launch" })
check("python adapter resolves", adapter ~= nil and adapter.type == "executable")
if adapter then
  check("python adapter uses python313 env", adapter.command:find("python3%-3%.13") ~= nil, adapter.command)
  check(
    "python adapter runs debugpy.adapter",
    table.concat(adapter.args, " ") == "-m debugpy.adapter",
    table.concat(adapter.args, " ")
  )
  check("python adapter path is executable", vim.fn.executable(adapter.command) == 1, adapter.command)
end

-- ── 5. render-markdown (M2/M5) ──────────────────────────────────────────
local ok_rm, rm = pcall(require, "render-markdown")
check("render-markdown loads", ok_rm, rm)
if ok_rm then
  check("render-markdown initialized", rm.initialized == true)
  local cfg = require("render-markdown.state").config
  check("render-markdown code.width=block", cfg ~= nil and cfg.code.width == "block")
  check("render-markdown code.sign=false", cfg ~= nil and cfg.code.sign == false)
  check("render-markdown code.right_pad=1", cfg ~= nil and cfg.code.right_pad == 1)
  check("render-markdown heading.sign=false", cfg ~= nil and cfg.heading.sign == false)
  check(
    "render-markdown heading icons blank",
    cfg ~= nil and cfg.heading.icons[1] == "",
    cfg ~= nil and vim.inspect(cfg.heading.icons)
  )
  check("render-markdown completions.lsp.enabled", cfg ~= nil and cfg.completions.lsp.enabled == true)
end

-- ── 6. snacks dim/zen (P1) ──────────────────────────────────────────────
local snacks = require("snacks")
check("snacks.toggle.dim is a function", type(snacks.toggle.dim) == "function")
check("snacks.toggle.zen is a function", type(snacks.toggle.zen) == "function")
check("snacks dim module enabled", snacks.config.dim.enabled == true)
check("snacks zen module enabled", snacks.config.zen.enabled == true)

-- ── 7. blink cmdline (P6) ───────────────────────────────────────────────
check("blink cmdline.enabled", require("blink.cmp.config").cmdline.enabled == true)

-- ── 8. nvim-lint ownership (W3) ─────────────────────────────────────────
local lint = require("lint")
check(
  "lint python has no ruff",
  not vim.tbl_contains(lint.linters_by_ft.python or {}, "ruff"),
  vim.inspect(lint.linters_by_ft.python)
)
check(
  "lint nix has no statix",
  not vim.tbl_contains(lint.linters_by_ft.nix or {}, "statix"),
  vim.inspect(lint.linters_by_ft.nix)
)

-- ── 9. herd opencode cmd (W15) ──────────────────────────────────────────
local herd_cmd = require("herd.config").get().tools.opencode.cmd
check(
  "herd opencode cmd is --continue",
  table.concat(herd_cmd, " ") == "opencode --continue",
  table.concat(herd_cmd, " ")
)

-- ── 10. otter lazy spec (J10) ───────────────────────────────────────────
local otter_spec = require("lz.n").lookup("otter.nvim")
check("otter lazy spec found", otter_spec ~= nil)
if otter_spec then
  local patterns = otter_spec.event and otter_spec.event.pattern or {}
  check("otter pattern excludes *.ipynb", not vim.tbl_contains(patterns, "*.ipynb"), vim.inspect(patterns))
end

-- ── 11. opencode input-window keymaps (0eb7abb) ─────────────────────────
local lzn = require("lz.n")
if lzn.lookup("opencode-nvim") then
  pcall(lzn.trigger_load, "opencode-nvim")
  vim.wait(2000, function()
    return package.loaded["opencode"] ~= nil
  end, 50)
end
local oc = require("opencode.config").values
check("opencode ~ disabled", oc.keymap.input_window["~"] == false, vim.inspect(oc.keymap.input_window["~"]))
check("opencode <C-p> palette mapped", oc.keymap.input_window["<C-p>"] ~= nil)

-- ── 12. conform markdown (M14) ──────────────────────────────────────────
local conform = require("conform")
check(
  "conform markdown uses injected",
  vim.tbl_contains(conform.formatters_by_ft.markdown or {}, "injected"),
  vim.inspect(conform.formatters_by_ft.markdown)
)

-- ── summary ─────────────────────────────────────────────────────────────
print(string.format("\n%d checks, %d failures", checks, #failures))
if #failures > 0 then
  for _, f in ipairs(failures) do
    print("  FAILED: " .. f)
  end
  vim.cmd("cquit 1")
else
  vim.cmd("qa!")
end