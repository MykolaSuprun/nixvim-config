-- Post-startup checks: state that only exists after the REAL VimEnter.
--
-- `-c` scripts run before VimEnter, and several plugins (noice, hardtime,
-- the VimEnter-lazy AI stack) only apply their configuration from a VimEnter
-- handler. Firing VimEnter by hand from the sweep blocks headless nvim (every
-- opt plugin has been packadded raw by then), so this suite instead schedules
-- its checks to run on the event loop — i.e. after Neovim's own VimEnter,
-- exactly as in an interactive start.
--
-- Usage (normally via tests/run.sh):
--   nvim --headless -c "luafile tests/post-startup.lua"

local pass, failures = 0, {}

-- print() does not reach stdout once headless nvim is past startup; write
-- directly so the results show up in tests/run.sh output.
local function out(s)
  io.stdout:write(s .. "\n")
end

local function ok(name, cond, detail)
  if cond then
    pass = pass + 1
    out("PASS  " .. name)
  else
    local msg = name .. (detail ~= nil and (" — " .. tostring(detail)) or "")
    failures[#failures + 1] = msg
    out("FAIL  " .. msg)
  end
end

local function run()
  ok("VimEnter has fired", vim.v.vim_did_enter == 1)

  -- hardtime defaults to mouse="" (it broke bufferline hover/right-click and
  -- dap-ui's <2-LeftMouse>); the config sets disable_mouse = false.
  ok("mouse enabled after hardtime loads", vim.o.mouse ~= "", vim.o.mouse)

  -- noice's signature popup duplicated blink's (two windows per `(`).
  local ok_noice, noice_cfg = pcall(require, "noice.config")
  local sig = ok_noice
    and type(noice_cfg.options) == "table"
    and type(noice_cfg.options.lsp) == "table"
    and noice_cfg.options.lsp.signature.enabled
  ok("noice signature help disabled (blink owns it)", sig == false, tostring(sig))

  -- Every Ex command a keymap calls via <cmd>X / :X must exist. A keymap to a
  -- removed command (e.g. :TSModuleInfo after nvim-treesitter moved to
  -- `main`) passes the keymap-existence sweep but fails when pressed.
  -- Checked here, not in the sweep: VimEnter-lazy plugins (codecompanion,
  -- hardtime) only create their commands in setup(), which the sweep's raw
  -- packadd never runs. Cmd-lazy plugins are covered by lz.n's stubs.
  local cmds_file = os.getenv("POST_CMDS")
  if cmds_file and vim.fn.filereadable(cmds_file) == 1 then
    for _, name in ipairs(vim.fn.readfile(cmds_file)) do
      if name ~= "" then
        ok("command exists: :" .. name, vim.fn.exists(":" .. name) == 2)
      end
    end
  else
    out("WARN  POST_CMDS not set/readable — keymap command verification skipped")
  end

  local errs = {}
  for line in vim.fn.execute("messages"):gmatch("[^\n]+") do
    if line:match("E%d%d%d:") or line:match("Error") then
      errs[#errs + 1] = line:sub(1, 160)
    end
  end
  ok("no errors in :messages after VimEnter", #errs == 0, table.concat(errs, " | "):sub(1, 400))

  out(("\n%d checks, %d failures"):format(pass + #failures, #failures))
  vim.cmd(#failures > 0 and "cquit 1" or "qa!")
end

-- Let VimEnter and the lz.n loads it triggers settle first. 1s, because
-- hardtime defers its own setup() (and its :Hardtime command) by 500ms.
vim.schedule(function()
  vim.defer_fn(run, 1000)
end)
