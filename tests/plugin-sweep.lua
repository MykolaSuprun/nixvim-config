-- Plugin + keymap sweep for the built nixvim config.
--
-- Companion to tests/headless-smoke.lua. Where the smoke suite asserts
-- specific behaviours, this sweep is broad and shallow: it proves every
-- packaged plugin is *loadable* and every declared keymap *exists*.
--
-- Usage (from the repo root, normally via tests/run.sh):
--   SWEEP_EXPECTED=.tmp/expected-keymaps.tsv \
--     <nixvim>/bin/nvim --headless -c "luafile tests/plugin-sweep.lua"
--
-- ⚠️ WHAT THIS DOES *NOT* PROVE — read before citing it as validation
-- (both of these are how the codecompanion `extensions.history` bug survived
-- a green 286/0 sweep on 2026-10-19):
--   1. It `require()`s modules but NEVER calls `setup()`. Anything that only
--      happens during setup — extension loading, adapter construction, keymap
--      installation — is outside its reach. A plugin can "load" here and still
--      throw on every real startup.
--   2. A plugin name appearing as loaded says nothing about whether its own
--      hooks/autocmds work at runtime.
-- It is a *plugin-load* gate. For "does the config actually come up clean",
-- the test that matters is the real-load assertion in headless-smoke.lua
-- plus an interactive check (`nvim README.md` in a pty, then assert
-- ~/.local/state/nvim/codecompanion.log has no [ERROR]).
--
-- The :messages scan below is captured at the very top, BEFORE any packadd or
-- require. That ordering is deliberate: an earlier version scanned at the end,
-- after ~300 requires had flooded or evicted the real startup output, which is
-- how a startup-time error went unnoticed.
--
-- Exits non-zero (cquit 1) when anything fails.

local pass, fail, warn = 0, 0, 0
local failures = {}

local function ok(name, cond, detail)
  if cond then
    pass = pass + 1
    print("PASS  " .. name)
  else
    fail = fail + 1
    local msg = name .. (detail and (" — " .. tostring(detail)) or "")
    failures[#failures + 1] = msg
    print("FAIL  " .. msg)
  end
end

local function note(name, detail)
  warn = warn + 1
  print("WARN  " .. name .. (detail and (" — " .. tostring(detail)) or ""))
end

local function readdir(path)
  if vim.fn.isdirectory(path) ~= 1 then
    return {}
  end
  return vim.fn.readdir(path)
end

-- ── 0. startup messages, captured FIRST ───────────────────────────────────
-- Do not move this below the plugin loop: the loop requires hundreds of modules
-- and would bury/evict the genuine startup output.
local startup_msgs = vim.fn.execute("messages")

-- ── 1. locate the pack dir ────────────────────────────────────────────────
local packdir
for _, p in ipairs(vim.split(vim.o.packpath, ",")) do
  if p:match("vim%-pack%-dir") then
    packdir = p
    break
  end
end
ok("pack dir found on packpath", packdir ~= nil, vim.o.packpath)
if not packdir then
  vim.cmd("cquit 1")
end

local base = packdir .. "/pack/myNeovimPackages"
local eager = readdir(base .. "/start")
local lazy = readdir(base .. "/opt")
print(("pack dir: %s  (%d eager, %d lazy)"):format(packdir, #eager, #lazy))

-- ── 2. load every plugin ──────────────────────────────────────────────────
local function modules_of(dir)
  local mods = {}
  local lua = dir .. "/lua"
  for _, e in ipairs(readdir(lua)) do
    if e:match("%.lua$") then
      mods[#mods + 1] = e:gsub("%.lua$", "")
    elseif vim.fn.filereadable(lua .. "/" .. e .. "/init.lua") == 1 then
      mods[#mods + 1] = e
    else
      -- one level deeper: lua/<pkg>/<mod>.lua → module <pkg>.<mod>
      -- (lz.n ships lua/lz/n.lua, mini.align ships lua/mini/align.lua, …)
      for _, f in ipairs(readdir(lua .. "/" .. e)) do
        if f:match("%.lua$") then
          mods[#mods + 1] = e .. "." .. f:gsub("%.lua$", "")
        elseif vim.fn.filereadable(lua .. "/" .. e .. "/" .. f .. "/init.lua") == 1 then
          mods[#mods + 1] = e .. "." .. f
        end
      end
    end
  end
  table.sort(mods)
  return mods
end

-- dir name → module name where they differ (nvim-config is our generated
-- config, not a plugin, so it is skipped entirely).
-- NOTE: nui.nvim has no top-level `nui` module (only nui.menu, nui.popup, …)
-- and vim-windowswap is pure vimscript — both are discovered by the scan
-- below (or correctly reported as "no lua module").
local MODULE_ALIAS = {
  ["harpoon2"] = "harpoon",
}

local all = {}
for _, n in ipairs(eager) do
  all[n] = "start"
end
for _, n in ipairs(lazy) do
  if not all[n] then
    all[n] = "opt"
  end
end

local names = vim.tbl_keys(all)
table.sort(names)
local loaded, no_module = 0, {}

for _, name in ipairs(names) do
  if name == "nvim-config" then
    goto continue
  end
  local dir = base .. "/" .. all[name] .. "/" .. name
  if all[name] == "opt" then
    pcall(vim.cmd, "packadd " .. name)
  end
  local mods = MODULE_ALIAS[name] and { MODULE_ALIAS[name] } or modules_of(dir)
  if #mods == 0 then
    no_module[#no_module + 1] = name
    note("no lua module to require: " .. name .. " (" .. all[name] .. ")")
  else
    local loaded_any, errs = false, {}
    for _, m in ipairs(mods) do
      local good, err = pcall(require, m)
      if good then
        loaded_any = true
      else
        errs[#errs + 1] = m .. ": " .. tostring(err)
      end
    end
    ok("plugin loads: " .. name, loaded_any, table.concat(errs, " | "):sub(1, 240))
    if loaded_any then
      loaded = loaded + 1
    end
  end
  ::continue::
end
print(("plugins: %d discovered, %d loaded, %d without a module"):format(#names, loaded, #no_module))

-- ── 3. keymap verification ────────────────────────────────────────────────
-- maparg (not nvim_get_keymap): it resolves the key notation the same way Vim
-- does at definition time, so case variants (<c-.> vs <C-.>, <C-s> vs <C-S>,
-- <tab> vs <Tab>) and escapes compare equal. nvim_get_keymap reports a
-- canonicalised lhs that does NOT round-trip against the nix source strings.
local function has_lhs(mode, lhs)
  return vim.fn.maparg(lhs, mode) ~= ""
end

local expected = vim.env.SWEEP_EXPECTED
if expected and vim.fn.filereadable(expected) == 1 then
  local L = vim.g.mapleader
  local LL = vim.g.maplocalleader
  local checked = 0
  for _, line in ipairs(vim.fn.readfile(expected)) do
    local key, modes = line:match("^([^\t]+)\t(.+)$")
    if key then
      local lhs = key:gsub("<leader>", L):gsub("<localleader>", LL)
      for m in modes:gmatch("%S") do
        -- %S not "." — a stray space in the modes column would otherwise be
        -- treated as a mode and produce a nonsense "<key> [ ]" check.
        checked = checked + 1
        ok(("keymap %s [%s]"):format(key, m), has_lhs(m, lhs))
      end
    end
  end
  print(("keymap checks: %d (from %s)"):format(checked, expected))
else
  note("SWEEP_EXPECTED not set/readable — keymap verification skipped")
end

-- ── 4. ownership checks ───────────────────────────────────────────────────
-- These assert WHO owns each <leader>a* / <leader>h* key, not merely that a key
-- is free. That distinction matters: an earlier version checked key *absence*,
-- which stopped being valid the moment we bound <leader>ac/ai/ar/as to
-- codecompanion — herdr-nvim's own defaults use the SAME sub-keys (c/l/s/S/i
-- under prefix "<leader>a"). The `desc` field identifies the real owner.
local L = vim.g.mapleader

local function desc_of(mode, lhs)
  local m = vim.fn.maparg(lhs, mode, false, true)
  return (m and m.desc) or nil
end

-- herdr-nvim's opt-out defaults (prefix = "<leader>a", keymaps = true). We set
-- keymaps = false, so every one of these sub-keys must now belong to
-- codecompanion — or be unbound. A herdr desc here means the opt-out regressed.
local herdr_descs = 0
for _, k in ipairs({ "ac", "al", "as", "aS", "ai" }) do
  local d = desc_of("n", L .. k) or desc_of("x", L .. k)
  if d and d:match("herdr") then
    herdr_descs = herdr_descs + 1
  end
end
ok("herdr-nvim default <leader>a* keymaps disabled (no herdr desc)", herdr_descs == 0)

-- codecompanion owns the whole <leader>a surface it declares.
for _, k in ipairs({ "aa", "aA", "av", "ai", "ar", "as", "ac" }) do
  local d = desc_of("n", L .. k) or desc_of("x", L .. k)
  ok("<leader>" .. k .. " owned by codecompanion", d ~= nil and d:match("CodeCompanion") ~= nil, d)
end

-- The removed AI surfaces must not have left keymaps behind.
ok("no opencode remnant (<leader>o free)", desc_of("n", L .. "o") == nil)
ok(
  "no agentic remnant (<leader>at/an free)",
  desc_of("n", L .. "at") == nil and desc_of("n", L .. "an") == nil
)
ok("no <leader>C dashboard remnant", desc_of("n", L .. "C") == nil)

-- harpoon moved <leader>h -> <leader>H; herdr-nvim took <leader>h.
ok("harpoon not on <leader>h (h is herdr's)", desc_of("n", L .. "hh") == nil)
local hh = desc_of("n", L .. "Hh")
ok("harpoon present on <leader>H", hh ~= nil and hh:match("Harpoon") ~= nil, hh)
ok(
  "herdr bridge on <leader>h",
  has_lhs("n", L .. "hc") and has_lhs("n", L .. "hS")
)

-- ── 5. startup error scan (uses the messages captured at step 0) ──────────
local errs = {}
for line in startup_msgs:gmatch("[^\n]+") do
  if line:match("E%d%d%d:") or line:match("Failed to load") or line:match("Error detected") then
    errs[#errs + 1] = line:sub(1, 160)
  end
end
ok("no startup errors in :messages", #errs == 0, table.concat(errs, " | "):sub(1, 400))

-- ── 6. summary ────────────────────────────────────────────────────────────
print(("\n=== SWEEP: %d passed, %d failed, %d warnings ==="):format(pass, fail, warn))
if fail > 0 then
  print("failures:")
  for _, f in ipairs(failures) do
    print("  - " .. f)
  end
  vim.cmd("cquit 1")
end
-- Explicit quit: packadding every lazy plugin leaves timers/autocmds behind, so
-- headless nvim would otherwise idle forever after the summary instead of
-- exiting (the caller's `-c q` never runs because the event loop stays alive).
vim.cmd("qa!")
