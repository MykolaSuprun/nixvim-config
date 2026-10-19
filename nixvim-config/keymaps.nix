{...}: {
  keymaps = [
    # Pickers
    {
      key = "<leader><leader>";
      options = {
        silent = true;
        desc = "Smart Find Files";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.smart({layout = "ivy_split"}) end
        '';
    }
    {
      key = "<leader>,";
      options = {
        silent = true;
        desc = "Buffers";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.buffers({layout = "ivy_split"}) end
        '';
    }
    {
      key = "<leader>ff";
      options = {
        silent = true;
        desc = "Find Files";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.files({layout = "ivy_split"}) end
        '';
    }
    {
      key = "<leader>fg";
      options = {
        silent = true;
        desc = "Find Git Files";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.git_files({layout = "ivy_split"}) end
        '';
    }
    {
      key = "<leader>fr";
      options = {
        silent = true;
        desc = "Recent";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.recent({layout = "ivy_split"}) end
        '';
    }
    {
      key = "<leader>ft";
      options = {
        silent = true;
        desc = "Treesitter";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.treesitter() end
        '';
    }
    {
      key = "<leader>/";
      options = {
        silent = true;
        desc = "Grep";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.grep({layout = "ivy_split"}) end
        '';
    }
    {
      key = "<leader>:";
      options = {
        silent = true;
        desc = "Command History";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.command_history() end
        '';
    }
    {
      key = "<leader>fn";
      options = {
        silent = true;
        desc = "Notifications History";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.notifications({layout = "vertical"}) end
        '';
    }
    {
      key = "<leader>E";
      options = {
        silent = true;
        desc = "File Explorer (picker)";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.explorer() end
        '';
    }
    {
      key = "<leader>e";
      options = {
        silent = true;
        desc = "File Explorer (oil)";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() require("oil").open() end
        '';
    }
    # Git
    {
      key = "<leader>gb";
      options = {
        silent = true;
        desc = "Git Branches";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.git_branches() end
        '';
    }
    # <leader>gL (Git Log) and <leader>gs (Git Status) are in ../shared/keymaps.nix
    {
      key = "<leader>gS";
      options = {
        silent = true;
        desc = "Git Stash";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.git_stash() end
        '';
    }
    {
      key = "<leader>gd";
      options = {
        silent = true;
        desc = "Git Diff (Hunks)";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.git_diff() end
        '';
    }
    {
      key = "<leader>gf";
      options = {
        silent = true;
        desc = "Git Log File";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.git_log_file() end
        '';
    }
    # Diffview (plugin is command-gated — this bind triggers the lazy load)
    {
      key = "<leader>gv";
      options = {
        silent = true;
        desc = "Git Diffview (working tree)";
      };
      mode = ["n"];
      action = "<cmd>DiffviewOpen<CR>";
    }
    # clangd: switch between C/C++ source and header (clangd_extensions,
    # loaded on BufEnter). No-op error message outside C-family buffers.
    {
      key = "<leader>ch";
      options = {
        silent = true;
        desc = "Switch C/C++ source/header";
      };
      mode = ["n"];
      action = "<cmd>ClangdSwitchSourceHeader<CR>";
    }
    {
      key = "<leader>fd";
      options = {
        silent = true;
        desc = "Project Diagnostics";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.diagnostics() end
        '';
    }
    {
      key = "<leader>fD";
      options = {
        silent = true;
        desc = "Buffer Diagnostics";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.diagnostics_buffer() end
        '';
    }
    # Grep
    {
      key = "<leader>sb";
      options = {
        silent = true;
        desc = "Grep Current Buffer";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.grep({ buffers = true, layout = "ivy_split" }) end
        '';
    }
    {
      key = "<leader>sB";
      options = {
        silent = true;
        desc = "Grep Open Buffers";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.grep_buffers() end
        '';
    }
    {
      key = "<leader>sd";
      options = {
        silent = true;
        desc = "Diagnostics";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.diagnostics() end
        '';
    }
    {
      key = "<leader>sD";
      options = {
        silent = true;
        desc = "Buffer Diagnostics";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.diagnostics_buffer() end
        '';
    }
    {
      key = "<leader>sw";
      options = {
        silent = true;
        desc = "Grep Word/Selection";
      };
      mode = ["n" "x"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.grep_word() end
        '';
    }
    # Search

    {
      key = "<leader>s\"";
      options = {
        silent = true;
        desc = "Registers";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.registers() end
        '';
    }
    {
      key = "<leader>s/";
      options = {
        silent = true;
        desc = "Search History";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.search_history() end
        '';
    }
    {
      key = "<leader>sa";
      options = {
        silent = true;
        desc = "Autocmds";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.autocmds() end
        '';
    }
    {
      key = "<leader>sc";
      options = {
        silent = true;
        desc = "Commands";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.commands() end
        '';
    }
    {
      key = "<leader>sh";
      options = {
        silent = true;
        desc = "Help Pages";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.help() end
        '';
    }
    {
      key = "<leader>sH";
      options = {
        silent = true;
        desc = "Highlights";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.highlights() end
        '';
    }
    {
      key = "<leader>si";
      options = {
        silent = true;
        desc = "Icons";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.icons() end
        '';
    }
    {
      key = "<leader>sj";
      options = {
        silent = true;
        desc = "Jumps";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.jumps() end
        '';
    }
    {
      key = "<leader>sk";
      options = {
        silent = true;
        desc = "Keymaps";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.keymaps() end
        '';
    }
    {
      key = "<leader>sl";
      options = {
        silent = true;
        desc = "Location List";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.loclist() end
        '';
    }
    {
      key = "<leader>sm";
      options = {
        silent = true;
        desc = "Marks";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.marks() end
        '';
    }
    {
      key = "<leader>sM";
      options = {
        silent = true;
        desc = "Man Pages";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.man() end
        '';
    }
    {
      key = "<leader>sq";
      options = {
        silent = true;
        desc = "Quickfix List";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.qflist() end
        '';
    }
    {
      key = "<leader>sr";
      options = {
        silent = true;
        desc = "Resume";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.resume() end
        '';
    }
    {
      key = "<leader>su";
      options = {
        silent = true;
        desc = "Undo History";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.undo() end
        '';
    }
    # LSP
    {
      key = "gd";
      options = {
        silent = true;
        desc = "Goto Definition";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.lsp_definitions() end
        '';
    }
    {
      key = "gD";
      options = {
        silent = true;
        desc = "Goto Declaration";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.lsp_declarations() end
        '';
    }
    {
      key = "gr";
      options = {
        silent = true;
        desc = "References";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.lsp_references() end
        '';
    }
    {
      key = "gI";
      options = {
        silent = true;
        desc = "Goto Implementation";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.lsp_implementations() end
        '';
    }
    {
      key = "gy";
      options = {
        silent = true;
        desc = "Goto Type Definition";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.lsp_type_definition() end
        '';
    }
    {
      key = "<leader>ss";
      options = {
        silent = true;
        desc = "LSP Symbols";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.lsp_symbols() end
        '';
    }
    {
      key = "<leader>sS";
      options = {
        silent = true;
        desc = "LSP Workspace Symbols";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.lsp_workspace_symbols() end
        '';
    }

    # To do
    {
      key = "<leader>st";
      options = {
        silent = true;
        desc = "Todo";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.todo_comments() end
        '';
    }
    {
      key = "<leader>sT";
      options = {
        silent = true;
        desc = "Todo/Fix/Fixme";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end
        '';
    }
    # Git
    {
      key = "<leader>gg";
      options = {
        silent = true;
        desc = "Lazygit";
      };
      mode = ["n"];
      action = "<cmd>:LazyGit<CR>";
    }
    # <leader>glt/gll/glb/glB and <leader>n are in ../shared/keymaps.nix
    # Visual — center active window with equal side padding (no UI hiding)
    {
      key = "<leader>m";
      options = {
        silent = true;
        desc = "Center / No-neck-pain toggle";
      };
      mode = ["n"];
      action = "<cmd>NoNeckPain<CR>";
    }
    # Code — <leader>cff/cfF/cft/cfT/cti/ctt are in ../shared/keymaps.nix
    {
      key = "<leader>ctm";
      options = {
        silent = true;
        desc = "Treesitter - module info";
      };
      mode = ["n"];
      action = "<cmd>:TSModuleInfo<CR>";
    }
    # UI
    {
      key = "<leader>uC";
      options = {
        silent = true;
        desc = "Colorschemes";
      };
      mode = ["n"];
      action = "<cmd>:lua Snacks.picker.colorschemes()<CR>";
    }
    # Toggle indent guides
    {
      key = "<leader>umr";
      options = {
        silent = true;
        desc = "Toggle markdown rendering";
      };
      mode = ["n"];
      action = "<cmd>:RenderMarkdown toggle<CR>";
    }
    {
      key = "<leader>umR";
      options = {
        silent = true;
        desc = "Toggle markdown rendering [buffer]";
      };
      mode = ["n"];
      action = "<cmd>:RenderMarkdown buf_toggle<CR>";
    }
    # NoNeckPain (plugin is command-gated — this bind triggers the lazy load)
    {
      key = "<leader>uN";
      options = {
        silent = true;
        desc = "Toggle window centering (no-neck-pain)";
      };
      mode = ["n"];
      action = "<cmd>NoNeckPain<CR>";
    }
    # snacks dim / zen (modules enabled in plugins.nix)
    {
      key = "<leader>uD";
      options = {
        silent = true;
        desc = "Toggle dim (snacks)";
      };
      mode = ["n"];
      action.__raw = ''function() require("snacks").toggle.dim():toggle() end'';
    }
    {
      key = "<leader>uz";
      options = {
        silent = true;
        desc = "Toggle zen mode (snacks)";
      };
      mode = ["n"];
      action.__raw = ''function() require("snacks").toggle.zen():toggle() end'';
    }
    {
      key = "<leader>ui";
      options = {
        silent = true;
        desc = "Toggle indent guides";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function()
            if vim.g.snacks_indent_enabled then
              Snacks.indent.disable()
              vim.g.snacks_indent_enabled = false
              Snacks.notifier.notify("Indent guides disabled", { title = "Snacks Indent" })
            else
              Snacks.indent.enable()
              vim.g.snacks_indent_enabled = true
              Snacks.notifier.notify("Indent guides enabled", { title = "Snacks Indent" })
            end
          end
        '';
    }
    {
      key = "<leader>uht";
      options = {
        silent = true;
        desc = "Toggle Hardtime";
      };
      mode = ["n"];
      action = "<cmd>:Hardtime toggle<CR>";
    }
    {
      key = "<leader>uhr";
      options = {
        silent = true;
        desc = "Hardtime report";
      };
      mode = ["n"];
      action = "<cmd>:Hardtime report<CR>";
    }
    {
      key = "<leader>uth";
      options = {
        silent = true;
        desc = "Toggle Treesitter highlight";
      };
      mode = ["n"];
      action = "<cmd>:TSBufToggle highlight<CR>";
    }
    # Navigation
    # NOTE: tmux-navigator and the <M-h/j/k/l> pane-navigation keymaps were
    # removed. In-editor window navigation is now handled by window-picker
    # (<leader>w) and standard <C-w> motions. Harpoon lives under <leader>h.
    # Flash (<C-s>/<S-s>) are in ../shared/keymaps.nix

    # ── Window pick (<leader>w / <S-Space>) ──────────────────────────────────
    # <leader>w or <S-Space> → nvim-window-picker (jump to a window by big
    # floating letter). <S-Space> is a faster single-key alternative.
    {
      key = "<leader>w";
      options = {
        silent = true;
        desc = "Pick Window (window-picker)";
      };
      mode = ["n"];
      action.__raw = ''
        function()
          local winid = require("window-picker").pick_window()
          if winid then vim.api.nvim_set_current_win(winid) end
        end
      '';
    }
    {
      key = "<S-Space>";
      options = {
        silent = true;
        desc = "Pick Window (window-picker)";
      };
      mode = ["n"];
      action.__raw = ''
        function()
          local winid = require("window-picker").pick_window()
          if winid then vim.api.nvim_set_current_win(winid) end
        end
      '';
    }
    # Tabs
    # Bufferline tab navigation with Shift+H/L
    {
      key = "<S-h>";
      options = {
        silent = true;
        desc = "Previous Tab";
      };
      mode = ["n"];
      action = "<cmd>BufferLineCyclePrev<CR>";
    }
    {
      key = "<S-l>";
      options = {
        silent = true;
        desc = "Next Tab";
      };
      mode = ["n"];
      action = "<cmd>BufferLineCycleNext<CR>";
    }
    # Pick tab — <leader><S-tab>. Moved off <leader><tab> (now the agents
    # group). <S-tab> is a distinct keycode from <Tab>/<C-i>, so jumplist
    # forward-jump is unaffected.
    {
      key = "<leader><S-tab>";
      options = {
        silent = true;
        desc = "Pick Tab";
      };
      mode = ["n"];
      action = "<cmd>BufferLinePick<CR>";
    }
    # Tab operations with leader-t prefix
    {
      key = "<leader>tn";
      options = {
        silent = true;
        desc = "New Tab";
      };
      mode = ["n"];
      action = {
        __raw = ''
          function()
            local current_tab = vim.fn.tabpagenr()
            vim.cmd("tabnew")
            -- vim.cmd("tabmove " .. current_tab)
          end
        '';
      };
    }
    {
      key = "<leader>tc";
      options = {
        silent = true;
        desc = "Close Tab";
      };
      mode = ["n"];
      action = "<cmd>tabclose<CR>";
    }
    {
      key = "<leader>to";
      options = {
        silent = true;
        desc = "Close Other Tabs";
      };
      mode = ["n"];
      action = "<cmd>tabonly<CR>";
    }
    {
      key = "<leader>th";
      options = {
        silent = true;
        desc = "Move Tab Left";
      };
      mode = ["n"];
      action = "<cmd>-tabmove<CR>";
    }
    {
      key = "<leader>tl";
      options = {
        silent = true;
        desc = "Move Tab Right";
      };
      mode = ["n"];
      action = "<cmd>+tabmove<CR>";
    }
    {
      key = "<leader>tf";
      options = {
        silent = true;
        desc = "First Tab";
      };
      mode = ["n"];
      action = "<cmd>tabfirst<CR>";
    }
    {
      key = "<leader>t$";
      options = {
        silent = true;
        desc = "Last Tab";
      };
      mode = ["n"];
      action = "<cmd>tablast<CR>";
    }
    {
      key = "<leader>t1";
      options = {
        silent = true;
        desc = "Tab 1";
      };
      mode = ["n"];
      action = "<cmd>1tabnext<CR>";
    }
    {
      key = "<leader>t2";
      options = {
        silent = true;
        desc = "Tab 2";
      };
      mode = ["n"];
      action = "<cmd>2tabnext<CR>";
    }
    {
      key = "<leader>t3";
      options = {
        silent = true;
        desc = "Tab 3";
      };
      mode = ["n"];
      action = "<cmd>3tabnext<CR>";
    }
    {
      key = "<leader>t4";
      options = {
        silent = true;
        desc = "Tab 4";
      };
      mode = ["n"];
      action = "<cmd>4tabnext<CR>";
    }
    {
      key = "<leader>t5";
      options = {
        silent = true;
        desc = "Tab 5";
      };
      mode = ["n"];
      action = "<cmd>5tabnext<CR>";
    }
    {
      key = "<leader>t6";
      options = {
        silent = true;
        desc = "Tab 6";
      };
      mode = ["n"];
      action = "<cmd>6tabnext<CR>";
    }
    {
      key = "<leader>t7";
      options = {
        silent = true;
        desc = "Tab 7";
      };
      mode = ["n"];
      action = "<cmd>7tabnext<CR>";
    }
    {
      key = "<leader>t8";
      options = {
        silent = true;
        desc = "Tab 8";
      };
      mode = ["n"];
      action = "<cmd>8tabnext<CR>";
    }
    {
      key = "<leader>t9";
      options = {
        silent = true;
        desc = "Tab 9";
      };
      mode = ["n"];
      action = "<cmd>9tabnext<CR>";
    }
    # Trouble (<leader>xx/xX/xS/cl/cL/cQ/xp) are in ../shared/keymaps.nix
    # NOTE: avante keymap removed — avante disabled. The AI surface is now
    # sidekick (CLI agents, <leader><tab>) + codecompanion (chat / inline /
    # ACP, <leader>a) + herdr-nvim (herdr bridge, <leader>h). See AGENTS.md.

    # ── sidekick (AI CLI agents) — <leader><tab> ───────────────────────────
    # sidekick.nvim manages external AI coding CLIs (claude / opencode / …) in
    # its own terminal window. These maps are static — the old runtime
    # backend-swapper (lua/agent_backend.lua) is gone together with herd.nvim.
    # <c-.> is sidekick's own suggested focus bind and works from normal,
    # terminal, insert and visual mode.
    {
      key = "<leader><tab>t";
      options = {
        silent = true;
        desc = "Sidekick: toggle CLI terminal";
      };
      mode = ["n"];
      action.__raw = ''function() require("sidekick.cli").toggle() end'';
    }
    {
      key = "<leader><tab>s";
      options = {
        silent = true;
        desc = "Sidekick: select CLI";
      };
      mode = ["n"];
      action.__raw = ''function() require("sidekick.cli").select({ filter = { installed = true } }) end'';
    }
    {
      key = "<leader><tab>f";
      options = {
        silent = true;
        desc = "Sidekick: focus terminal";
      };
      mode = ["n"];
      action.__raw = ''function() require("sidekick.cli").focus() end'';
    }
    {
      key = "<leader><tab>p";
      options = {
        silent = true;
        desc = "Sidekick: pick prompt";
      };
      mode = ["n" "x"];
      action.__raw = ''function() require("sidekick.cli").prompt() end'';
    }
    {
      key = "<leader><tab>x";
      options = {
        silent = true;
        desc = "Sidekick: send this";
      };
      mode = ["n" "x"];
      action.__raw = ''function() require("sidekick.cli").send({ msg = "{this}" }) end'';
    }
    {
      key = "<leader><tab>e";
      options = {
        silent = true;
        desc = "Sidekick: send file";
      };
      mode = ["n"];
      action.__raw = ''function() require("sidekick.cli").send({ msg = "{file}" }) end'';
    }
    {
      key = "<leader><tab>v";
      options = {
        silent = true;
        desc = "Sidekick: send selection";
      };
      mode = ["x"];
      action.__raw = ''function() require("sidekick.cli").send({ msg = "{selection}" }) end'';
    }
    {
      key = "<leader><tab>d";
      options = {
        silent = true;
        desc = "Sidekick: detach CLI";
      };
      mode = ["n"];
      action.__raw = ''function() require("sidekick.cli").close() end'';
    }
    {
      key = "<c-.>";
      options = {
        silent = true;
        desc = "Sidekick: focus CLI";
      };
      mode = ["n" "t" "i" "x"];
      action.__raw = ''function() require("sidekick.cli").focus() end'';
    }

    # ── codecompanion (chat / inline / code-review / ACP) — <leader>a ───────
    # Entry points only: codecompanion's own bindings are buffer-local to its
    # chat/inline windows (g1-g4 approvals, gv diff, <C-s> send, ga adapter/
    # model, gr regenerate, gR goto file, ]h/[h hunks — full table in
    # KEYBINDS.md), so nothing here can collide with them.
    #
    # NOTE: upstream's getting-started suggests `v ga` for "add selection to
    # chat". That is NOT usable here — mini.align owns `ga`/`gA` in normal AND
    # visual mode. Our visual-selection entry point is `<leader>av` instead.
    #
    # On `<cmd>`: it does NOT hand the visual range to the command's
    # `line1`/`line2` (verified — a `range=true` probe sees {4,4}, the cursor
    # line). It does not need to: codecompanion reads the selection itself in
    # `utils.context.get_visual_selection()` via `vim.fn.mode()` + `v`/`.`
    # marks, and `<cmd>` is precisely what PRESERVES visual mode (`:` exits it
    # first, which is why the `:`-form sees nothing). Verified live: from a
    # visual selection over lines 2-3, a `<cmd>` mapping gives the plugin
    # `{ "two", "three" } sl=2 el=3`. Keep `<cmd>` here.
    {
      key = "<leader>aa";
      options = {
        silent = true;
        desc = "CodeCompanion: toggle chat";
      };
      mode = ["n"];
      action = "<cmd>CodeCompanionChat Toggle<cr>";
    }
    {
      key = "<leader>aA";
      options = {
        silent = true;
        desc = "CodeCompanion: action palette (prompts / tools / chat)";
      };
      mode = ["n" "x"];
      action = "<cmd>CodeCompanionActions<cr>";
    }
    # Visual: push the selection into the current chat (creates one if absent).
    # This is the replacement for upstream's `v ga`, and the reason the old
    # x-mode `aa` bind was misleading: Toggle never sent the selection.
    {
      key = "<leader>av";
      options = {
        silent = true;
        desc = "CodeCompanion: add selection to chat";
      };
      mode = ["x"];
      action = "<cmd>CodeCompanionChat Add<cr>";
    }
    # Inline edit: normal mode opens the input prompt; visual mode seeds it with
    # the selection. Same command — `CodeCompanion.inline` calls
    # `ui.open_input` when no prompt arg is given (verified in the source).
    {
      key = "<leader>ai";
      options = {
        silent = true;
        desc = "CodeCompanion: inline edit (selection / prompt)";
      };
      mode = ["n" "x"];
      action = "<cmd>CodeCompanion<cr>";
    }
    # Code review: visual = review the selection's diff, normal = the whole
    # branch. `CodeCompanionCodeReview` ignores the visual range either way
    # (it opens its own review window / diffs against the branch).
    {
      key = "<leader>ar";
      options = {
        silent = true;
        desc = "CodeCompanion: code review (selection / branch)";
      };
      mode = ["n" "x"];
      action = "<cmd>CodeCompanionCodeReview<cr>";
    }
    # Saved chats (restore / open previous sessions). NOTE: `:CodeCompanionChat`
    # with no args creates a NEW chat — the picker is the `sessions()` API.
    {
      key = "<leader>as";
      options = {
        silent = true;
        desc = "CodeCompanion: saved chats";
      };
      mode = ["n"];
      action.__raw = ''function() require("codecompanion").sessions() end'';
    }
    # Prompt the LLM to write a shell/editor command for the cmdline.
    {
      key = "<leader>ac";
      options = {
        silent = true;
        desc = "CodeCompanion: generate a command";
      };
      mode = ["n"];
      action = "<cmd>CodeCompanionCmd<cr>";
    }

    # ── herdr-nvim (herdr bridge) — <leader>h ──────────────────────────────
    # herdr-nvim's annotation flow: comment lines/selections, list them, paste
    # or auto-submit them into any agent pane, and drop bare path:line refs.
    # Needs nvim running INSIDE a herdr session (herdr exports
    # HERDR_WORKSPACE_ID / HERDR_TAB_ID) and the herdr binary on PATH. The
    # plugin's own default <leader>a* maps are disabled in extra-plugins.nix —
    # that namespace belongs to codecompanion now. `comment`/`ref` honor the
    # command range, so the visual-mode binds carry the selection automatically.
    {
      key = "<leader>hc";
      options = {
        silent = true;
        desc = "Herdr: comment line/selection";
      };
      mode = ["n" "x"];
      action = "<cmd>Herdr comment<cr>";
    }
    {
      key = "<leader>hl";
      options = {
        silent = true;
        desc = "Herdr: list comments";
      };
      mode = ["n"];
      action = "<cmd>Herdr list<cr>";
    }
    {
      key = "<leader>hs";
      options = {
        silent = true;
        desc = "Herdr: paste comments to agent input";
      };
      mode = ["n"];
      action = "<cmd>Herdr send<cr>";
    }
    {
      key = "<leader>hS";
      options = {
        silent = true;
        desc = "Herdr: send comments (auto-submit)";
      };
      mode = ["n"];
      action = "<cmd>Herdr submit<cr>";
    }
    {
      key = "<leader>hi";
      options = {
        silent = true;
        desc = "Herdr: insert file:line reference";
      };
      mode = ["n" "x"];
      action = "<cmd>Herdr ref<cr>";
    }

    # ── obsidian + overseer (<leader>O — capital) ──────────────────────────
    # Shared prefix: bare <leader>O opens the Obsidian command menu
    # (`:Obsidian` with no args → show_menu, verified v3.16.6); <leader>O +
    # <sub> runs an overseer command. Neovim waits `timeoutlen` (300ms) to
    # disambiguate, so every overseer bind pays that delay — accepted cost.
    # Keep Obsidian directs on otherwise-free keys (Oq/Of) to avoid deepening it.
    {
      key = "<leader>O";
      options = {
        silent = true;
        desc = "Obsidian command menu";
      };
      mode = ["n"];
      action = "<cmd>Obsidian<cr>";
    }
    # Obsidian directs (menu above stays the front door; these skip it)
    {
      key = "<leader>Oq";
      options = {
        silent = true;
        desc = "Obsidian: quick switch note";
      };
      mode = ["n"];
      action = "<cmd>Obsidian quick_switch<cr>";
    }
    {
      key = "<leader>Of";
      options = {
        silent = true;
        desc = "Obsidian: search vault";
      };
      mode = ["n"];
      action = "<cmd>Obsidian search<cr>";
    }
    # Overseer
    {
      key = "<leader>Ot";
      options = {
        silent = true;
        desc = "Toggle active/running tasks list";
      };
      mode = ["n"];
      action = "<cmd>OverseerToggle<CR>";
    }
    {
      key = "<leader>Or";
      options = {
        silent = true;
        desc = "Run task (Pick a template to run)";
      };
      mode = ["n"];
      action = "<cmd>OverseerRun<CR>";
    }
    {
      key = "<leader>Oa";
      options = {
        silent = true;
        desc = "Task action (for active tasks)";
      };
      mode = ["n"];
      action = "<cmd>OverseerTaskAction<CR>";
    }
    {
      key = "<leader>Oo";
      options = {
        silent = true;
        desc = "Open active tasks list";
      };
      mode = ["n"];
      action = "<cmd>OverseerOpen<CR>";
    }
    {
      key = "<leader>Oc";
      options = {
        silent = true;
        desc = "Close active tasks list";
      };
      mode = ["n"];
      action = "<cmd>OverseerClose<CR>";
    }
    {
      key = "<leader>Os";
      options = {
        silent = true;
        desc = "Run shell command as task";
      };
      mode = ["n"];
      action = "<cmd>OverseerShell<CR>";
    }
    # Search and replace, persistence, and gitsigns hunks are in ../shared/keymaps.nix

    # Neotest
    {
      key = "<leader>Tr";
      options = {
        silent = true;
        desc = "Run Nearest Test";
      };
      mode = ["n"];
      action.__raw = ''function() require("neotest").run.run() end'';
    }
    {
      key = "<leader>Tf";
      options = {
        silent = true;
        desc = "Run Test File";
      };
      mode = ["n"];
      action.__raw = ''function() require("neotest").run.run(vim.fn.expand("%")) end'';
    }
    {
      key = "<leader>Ts";
      options = {
        silent = true;
        desc = "Toggle Test Summary";
      };
      mode = ["n"];
      action.__raw = ''function() require("neotest").summary.toggle() end'';
    }
    {
      key = "<leader>To";
      options = {
        silent = true;
        desc = "Show Test Output";
      };
      mode = ["n"];
      action.__raw = ''function() require("neotest").output.open({ enter = true }) end'';
    }
    {
      key = "]T";
      options = {
        silent = true;
        desc = "Next Failed Test";
      };
      mode = ["n"];
      action.__raw = ''function() require("neotest").jump.next({ status = "failed" }) end'';
    }
    {
      key = "[T";
      options = {
        silent = true;
        desc = "Prev Failed Test";
      };
      mode = ["n"];
      action.__raw = ''function() require("neotest").jump.prev({ status = "failed" }) end'';
    }
    # Gitsigns hunk navigation is in ../shared/keymaps.nix

    # ── DAP ────────────────────────────────────────────────────────────────
    {
      key = "<F5>";
      options = {
        silent = true;
        desc = "Debug: Continue";
      };
      mode = ["n"];
      action.__raw = ''function() require("dap").continue() end'';
    }
    {
      key = "<F10>";
      options = {
        silent = true;
        desc = "Debug: Step Over";
      };
      mode = ["n"];
      action.__raw = ''function() require("dap").step_over() end'';
    }
    {
      key = "<F11>";
      options = {
        silent = true;
        desc = "Debug: Step Into";
      };
      mode = ["n"];
      action.__raw = ''function() require("dap").step_into() end'';
    }
    {
      key = "<F12>";
      options = {
        silent = true;
        desc = "Debug: Step Out";
      };
      mode = ["n"];
      action.__raw = ''function() require("dap").step_out() end'';
    }
    {
      key = "<leader>db";
      options = {
        silent = true;
        desc = "Toggle Breakpoint";
      };
      mode = ["n"];
      action.__raw = ''function() require("dap").toggle_breakpoint() end'';
    }
    {
      key = "<leader>dB";
      options = {
        silent = true;
        desc = "Conditional Breakpoint";
      };
      mode = ["n"];
      action.__raw = ''
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end
      '';
    }
    {
      key = "<leader>du";
      options = {
        silent = true;
        desc = "Toggle DAP UI";
      };
      mode = ["n"];
      action.__raw = ''function() require("dapui").toggle() end'';
    }
    {
      key = "<leader>de";
      options = {
        silent = true;
        desc = "Evaluate Expression";
      };
      mode = ["n" "v"];
      action.__raw = ''function() require("dapui").eval() end'';
    }
    {
      key = "<leader>dc";
      options = {
        silent = true;
        desc = "Run to Cursor";
      };
      mode = ["n"];
      action.__raw = ''function() require("dap").run_to_cursor() end'';
    }
    {
      key = "<leader>dl";
      options = {
        silent = true;
        desc = "Run Last Debug Config";
      };
      mode = ["n"];
      action.__raw = ''function() require("dap").run_last() end'';
    }
    {
      key = "<leader>dL";
      options = {
        silent = true;
        desc = "Launch OSV (Lua/Neovim DAP server)";
      };
      mode = ["n"];
      action.__raw = ''function() require("osv").launch({ port = 8086 }) end'';
    }

    # ── Aerial (symbol outline) ─────────────────────────────────────────────
    {
      key = "<leader>cs";
      options = {
        silent = true;
        desc = "Symbols Outline (Aerial)";
      };
      mode = ["n"];
      action = "<cmd>AerialToggle<CR>";
    }
    {
      key = "{";
      options = {
        silent = true;
        desc = "Prev Symbol (Aerial)";
      };
      mode = ["n"];
      action.__raw = ''function() require("aerial").prev() end'';
    }
    {
      key = "}";
      options = {
        silent = true;
        desc = "Next Symbol (Aerial)";
      };
      mode = ["n"];
      action.__raw = ''function() require("aerial").next() end'';
    }

    # ── Harpoon (<leader>h) ─────────────────────────────────────────────────
    # Moved from <leader>w (now window-picker) to <leader>h.
    {
      key = "<leader>Ha";
      options = {
        silent = true;
        desc = "Harpoon: Add File";
      };
      mode = ["n"];
      action.__raw = ''function() require("harpoon"):list():add() end'';
    }
    {
      key = "<leader>Hh";
      options = {
        silent = true;
        desc = "Harpoon: Quick Menu";
      };
      mode = ["n"];
      action.__raw = ''
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end
      '';
    }
    {
      key = "<leader>H1";
      options = {
        silent = true;
        desc = "Harpoon: File 1";
      };
      mode = ["n"];
      action.__raw = ''function() require("harpoon"):list():select(1) end'';
    }
    {
      key = "<leader>H2";
      options = {
        silent = true;
        desc = "Harpoon: File 2";
      };
      mode = ["n"];
      action.__raw = ''function() require("harpoon"):list():select(2) end'';
    }
    {
      key = "<leader>H3";
      options = {
        silent = true;
        desc = "Harpoon: File 3";
      };
      mode = ["n"];
      action.__raw = ''function() require("harpoon"):list():select(3) end'';
    }
    {
      key = "<leader>H4";
      options = {
        silent = true;
        desc = "Harpoon: File 4";
      };
      mode = ["n"];
      action.__raw = ''function() require("harpoon"):list():select(4) end'';
    }
    {
      key = "<leader>Hp";
      options = {
        silent = true;
        desc = "Harpoon: Prev File";
      };
      mode = ["n"];
      action.__raw = ''function() require("harpoon"):list():prev() end'';
    }
    {
      key = "<leader>Hn";
      options = {
        silent = true;
        desc = "Harpoon: Next File";
      };
      mode = ["n"];
      action.__raw = ''function() require("harpoon"):list():next() end'';
    }

    # ── Terminal ─────────────────────────────────────────────────────────────
    # <C-\> is bound in normal mode ONLY. Binding it in terminal mode shadowed
    # the built-in <C-\><C-n> escape sequence, which is why exiting terminal
    # mode felt broken. Use <S-Esc> in terminal mode to send <C-\><C-n> and
    # return to normal mode.
    {
      key = "<C-\\>";
      options = {
        silent = true;
        desc = "Toggle Terminal";
      };
      mode = ["n"];
      action.__raw = ''function() Snacks.terminal.toggle() end'';
    }
    {
      key = "<S-Esc>";
      options = {
        silent = true;
        desc = "Terminal: exit to normal mode";
      };
      mode = ["t"];
      action = "<C-\\><C-n>";
    }
    # <C-/> — float terminal toggle. Moved off <leader>tf, which collided with
    # "First Tab" in the <leader>t tabs group (later mapping won, so First Tab
    # was unreachable). <C-\> stays the quick throwaway toggle.
    {
      key = "<C-/>";
      options = {
        silent = true;
        desc = "Toggle Float Terminal";
      };
      mode = ["n"];
      action.__raw = ''function() Snacks.terminal.toggle() end'';
    }

    # ── Overseer extras ──────────────────────────────────────────────────────
    # overseer v2 removed the OverseerRestartLast / OverseerQuickAction commands
    # (CHANGELOG: "remove OverseerQuickAction command"); the replacements are
    # the task actions (restart / watch) run via run_action on the last task.
    {
      key = "<leader>OR";
      options = {
        silent = true;
        desc = "Restart Last Task";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function()
            local overseer = require("overseer")
            local tasks = overseer.list_tasks({ unique = false })
            if #tasks == 0 then
              vim.notify("Overseer: no tasks", vim.log.levels.INFO)
              return
            end
            overseer.run_action(tasks[1], "restart")
          end
        '';
    }
    {
      key = "<leader>Ow";
      options = {
        silent = true;
        desc = "Watch (Restart on Save)";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function()
            local overseer = require("overseer")
            local tasks = overseer.list_tasks({ unique = false })
            if #tasks == 0 then
              vim.notify("Overseer: no tasks", vim.log.levels.INFO)
              return
            end
            overseer.run_action(tasks[1], "watch")
          end
        '';
    }

    # ── betterTerm (persistent send-to-terminal) — <leader>X ───────────────
    # Tabbed persistent terminals for interactive dbt / Snowflake / airflow
    # shells. Toggle the primary terminal with <leader>Xt; send the current
    # line / visual selection / whole file to terminal 1 with Xs/Xv/Xf.
    # (snacks.terminal keeps the quick throwaway toggle on <C-\>.)
    {
      key = "<leader>Xt";
      options = {
        silent = true;
        desc = "BetterTerm: toggle primary terminal";
      };
      mode = ["n"];
      action.__raw = ''function() require("betterTerm").open() end'';
    }
    {
      key = "<leader>Xx";
      options = {
        silent = true;
        desc = "BetterTerm: select terminal";
      };
      mode = ["n"];
      action.__raw = ''function() require("betterTerm").select() end'';
    }
    {
      key = "<leader>Xr";
      options = {
        silent = true;
        desc = "BetterTerm: rename current terminal";
      };
      mode = ["n"];
      action.__raw = ''function() require("betterTerm").rename() end'';
    }
    {
      key = "<leader>Xk";
      options = {
        silent = true;
        desc = "BetterTerm: kill current terminal";
      };
      mode = ["n"];
      action.__raw = ''function() require("betterTerm").close() end'';
    }
    {
      key = "<leader>X1";
      options = {
        silent = true;
        desc = "BetterTerm: toggle terminal 1";
      };
      mode = ["n"];
      action.__raw = ''function() require("betterTerm").open(1) end'';
    }
    {
      key = "<leader>X2";
      options = {
        silent = true;
        desc = "BetterTerm: toggle terminal 2";
      };
      mode = ["n"];
      action.__raw = ''function() require("betterTerm").open(2) end'';
    }
    {
      key = "<leader>X3";
      options = {
        silent = true;
        desc = "BetterTerm: toggle terminal 3";
      };
      mode = ["n"];
      action.__raw = ''function() require("betterTerm").open(3) end'';
    }
    {
      key = "<leader>X4";
      options = {
        silent = true;
        desc = "BetterTerm: toggle terminal 4";
      };
      mode = ["n"];
      action.__raw = ''function() require("betterTerm").open(4) end'';
    }
    {
      key = "<leader>X5";
      options = {
        silent = true;
        desc = "BetterTerm: toggle terminal 5";
      };
      mode = ["n"];
      action.__raw = ''function() require("betterTerm").open(5) end'';
    }
    {
      key = "<leader>Xs";
      options = {
        silent = true;
        desc = "BetterTerm: send current line";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function()
            local line = vim.api.nvim_get_current_line()
            require("betterTerm").send(line, 1)
          end
        '';
    }
    {
      key = "<leader>Xv";
      options = {
        silent = true;
        desc = "BetterTerm: send visual selection";
      };
      mode = ["x"];
      action.__raw =
        #lua
        ''
          function()
            local text = require("overseer_helpers").visual_selection()
            if not text then return end
            require("betterTerm").send(text, 1)
          end
        '';
    }
    {
      key = "<leader>Xf";
      options = {
        silent = true;
        desc = "BetterTerm: send whole file";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function()
            local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
            require("betterTerm").send(table.concat(lines, "\n"), 1)
          end
        '';
    }

    # ── database (dbee + Snowflake + sqlit) — <leader>Q ──────────────────
    # dbee has no Snowflake driver (see plugins.nix). Interactive paths:
    #   * Qr/Qv/Qb (Snowflake via `snow` CLI) and Qs{r,v,b} (any sqlit
    #     connection) run line/selection/buffer via lua/sql_runner.lua —
    #     confirm-gated, host-preferred on OrbStack, results shown in
    #     query_result's resize-safe float (CSV parsed + re-rendered on
    #     resize — NOT the tools' static ASCII tables, which break on
    #     terminal resize).
    #   * Qsi opens the sqlit TUI (a proper resize-safe Textual app) in a
    #     snacks.terminal float.
    # Overseer templates (describe/list/connection test/run compiled dbt SQL)
    # stay reachable via <leader>Or / Qo — see overseer/snowflake_tasks.lua.
    {
      key = "<leader>Qd";
      options = {
        silent = true;
        desc = "Dbee: toggle UI";
      };
      mode = ["n"];
      action.__raw = ''function() vim.cmd("DbeeToggle") end'';
    }
    {
      key = "<leader>Qo";
      options = {
        silent = true;
        desc = "Snowflake: browse all templates (OverseerRun)";
      };
      mode = ["n"];
      action = "<cmd>OverseerRun<CR>";
    }
    {
      key = "<leader>Qr";
      options = {
        silent = true;
        desc = "Snowflake: run current line (confirm → float)";
      };
      mode = ["n"];
      action.__raw = ''
        function()
          require("sql_runner").snow_line()
        end
      '';
    }
    {
      key = "<leader>Qv";
      options = {
        silent = true;
        desc = "Snowflake: run visual selection (confirm → float)";
      };
      mode = ["x"];
      action.__raw = ''
        function()
          require("sql_runner").snow_selection()
        end
      '';
    }
    {
      key = "<leader>Qb";
      options = {
        silent = true;
        desc = "Snowflake: run whole buffer (confirm → float)";
      };
      mode = ["n"];
      action.__raw = ''
        function()
          require("sql_runner").snow_buffer()
        end
      '';
    }
    {
      key = "<leader>Qsr";
      options = {
        silent = true;
        desc = "sqlit: run current line (confirm → float)";
      };
      mode = ["n"];
      action.__raw = ''
        function()
          require("sql_runner").sqlit_line()
        end
      '';
    }
    {
      key = "<leader>Qsv";
      options = {
        silent = true;
        desc = "sqlit: run visual selection (confirm → float)";
      };
      mode = ["x"];
      action.__raw = ''
        function()
          require("sql_runner").sqlit_selection()
        end
      '';
    }
    {
      key = "<leader>Qsb";
      options = {
        silent = true;
        desc = "sqlit: run whole buffer (confirm → float)";
      };
      mode = ["n"];
      action.__raw = ''
        function()
          require("sql_runner").sqlit_buffer()
        end
      '';
    }
    {
      key = "<leader>Qsi";
      options = {
        silent = true;
        desc = "sqlit: open TUI (terminal float)";
      };
      mode = ["n"];
      action.__raw = ''
        function()
          require("sql_runner").sqlit_tui()
        end
      '';
    }
    {
      key = "<leader>Qt";
      options = {
        silent = true;
        desc = "Snowflake: connection test";
      };
      mode = ["n"];
      action.__raw = ''
        function()
          require("overseer").run_task({ name = "snowflake: connection test" })
        end
      '';
    }

    # ── nix-develop — <leader>N ───────────────────────────────────────────
    # Run `nix develop` without restarting Neovim. Lazy-loads on .nix buffers.
    {
      key = "<leader>Nd";
      options = {
        silent = true;
        desc = "nix-develop: run nix develop";
      };
      mode = ["n"];
      action.__raw = ''function() require("nix-develop").develop() end'';
    }
  ];
  # Shared which-key groups (c/cf/ct/g/gh/gl/r/x/q) are in ../shared/keymaps.nix
  plugins.which-key.settings.spec = [
    {
      __unkeyed-1 = "<leader>f";
      group = "find";
    }
    {
      __unkeyed-1 = "<leader>u";
      group = "ui";
    }
    {
      __unkeyed-1 = "<leader>um";
      group = "markdown";
    }
    {
      __unkeyed-1 = "<leader>ut";
      group = "treesitter";
    }
    {
      __unkeyed-1 = "<leader>s";
      group = "search (Grep)";
    }
    {
      __unkeyed-1 = "<leader>d";
      group = "debug";
      icon = "";
    }
    # <leader>H is now harpoon (moved off <leader>h — now herdr-nvim); <leader>w is window-picker (direct map, no
    # sub-keys — so no which-key group spec for it).
    {
      __unkeyed-1 = "<leader>H";
      group = "harpoon";
      icon = "󰛢";
    }
    {
      __unkeyed-1 = "<leader>h";
      group = "herdr";
      icon = "";
    }
    {
      __unkeyed-1 = "<leader>a";
      group = "ai";
      icon = "";
    }
    {
      __unkeyed-1 = "<leader><tab>";
      group = "agents";
      icon = "󰚩";
    }
    {
      __unkeyed-1 = "<leader>t";
      group = "tabs";
      icon = "󰓩";
    }
    # NOTE: <leader>O (capital) is shared — bare key opens the Obsidian
    # command menu, sub-keys Ot/Or/Oa/Oo/Oc/Os/Ow run overseer, Oq/Of are
    # Obsidian directs. See AGENTS.md.
    {
      __unkeyed-1 = "<leader>O";
      group = "Obsidian/overseer";
      icon = "󰓧";
    }
    {
      __unkeyed-1 = "<leader>N";
      group = "nix-develop";
      icon = "󱄅";
    }
    {
      __unkeyed-1 = "<leader>Q";
      group = "database";
      icon = "󰆼";
    }
    {
      __unkeyed-1 = "<leader>Qs";
      group = "sqlit";
      icon = "󰆼";
    }
    {
      __unkeyed-1 = "<leader>X";
      group = "betterTerm (send to terminal)";
      icon = "󰆄";
    }
    {
      __unkeyed-1 = "<leader>T";
      group = "test (neotest)";
      icon = "󰙨";
    }
  ];
  lsp.keymaps = [
  ];
}
