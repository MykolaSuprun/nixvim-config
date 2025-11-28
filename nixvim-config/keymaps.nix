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
    {
      key = "<leader>gL";
      options = {
        silent = true;
        desc = "Git Log";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.git_log() end
        '';
    }
    {
      key = "<leader>gs";
      options = {
        silent = true;
        desc = "Git Status";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.git_status() end
        '';
    }
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
          function() Snacks.picker.git_stash() end
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
    {
      key = "<leader>glt";
      options = {
        silent = true;
        desc = "Toggle blame";
      };
      mode = ["n"];
      action = "<cmd>Gitsigns toggle_current_line_blame<cr>";
    }
    {
      key = "<leader>gll";
      options = {
        silent = true;
        desc = "Git Log Line";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() Snacks.picker.git_log_line() end
        '';
    }
    {
      key = "<leader>glb";
      options = {
        silent = true;
        desc = "Git blame line";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function()
            Snacks.git.blame_line()
          end
        '';
    }
    {
      key = "<leader>glB";
      options = {
        silent = true;
        desc = "Git browse line";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function()
            Snacks.gitbrowse()
          end
        '';
    }
    # Oil
    {
      key = "<leader>e";
      options = {
        silent = true;
        desc = "File explorer (Oil)";
      };
      mode = ["n"];
      action = ''<cmd>:Oil<cr>'';
    }
    # Notiications
    {
      key = "<leader>n";
      options = {
        silent = true;
        desc = "Notifications History";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function()
            Snacks.notifier.show_history()
          end
        '';
    }
    # Visual
    {
      key = "<leader>m";
      options = {
        silent = true;
        desc = "Zen mode";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function()
            Snacks.zen()
          end
        '';
    }
    # Code
    {
      key = "<leader>cff";
      options = {
        silent = true;
        desc = "Format";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''function() require("conform").format() end'';
    }
    {
      key = "<leader>cfF";
      options = {
        silent = true;
        desc = "Format Injected Langs";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function()
            require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
          end
        '';
    }
    {
      key = "<leader>cft";
      options = {
        silent = true;
        desc = "Enable Format On Save";
      };
      mode = ["n"];
      action = "<cmd>:FormatEnable<CR>";
    }
    {
      key = "<leader>cfT";
      options = {
        silent = true;
        desc = "Disable Format On Save";
      };
      mode = ["n"];
      action = "<cmd>:FormatDisable<CR>";
    }
    {
      key = "<leader>cti";
      options = {
        silent = true;
        desc = "Treesitter - applied groups [word]";
      };
      mode = ["n"];
      action = "<cmd>:Inspect<CR>";
    }
    {
      key = "<leader>ctt";
      options = {
        silent = true;
        desc = "Treesitter - inspect tree";
      };
      mode = ["n"];
      action = "<cmd>:InspectTree<CR>";
    }
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
      key = "<leader>uth";
      options = {
        silent = true;
        desc = "Toggle Treesitter highlight";
      };
      mode = ["n"];
      action = "<cmd>:TSBufToggle highlight<CR>";
    }
    # Navigation
    # Tmux pane navigation
    {
      key = "<M-h>";
      options = {
        silent = true;
        desc = "Window - Move Left";
      };
      mode = ["n"];
      action = "<cmd>:TmuxNavigateLeft<CR>";
    }
    {
      key = "<M-l>";
      options = {
        silent = true;
        desc = "Window - Move Right";
      };
      mode = ["n"];
      action = "<cmd>:TmuxNavigateRight<CR>";
    }
    {
      key = "<M-k>";
      options = {
        silent = true;
        desc = "Window - Move Up";
      };
      mode = ["n"];
      action = "<cmd>:TmuxNavigateUp<CR>";
    }
    {
      key = "<M-j>";
      options = {
        silent = true;
        desc = "Window - Move Down";
      };
      mode = ["n"];
      action = "<cmd>:TmuxNavigateDown<CR>";
    }
    {
      key = "<C-\\>";
      options = {
        silent = true;
        desc = "Window - Move to previous";
      };
      mode = ["n"];
      action = "TmuxNavigatePrevious";
    }
    # Flash
    {
      key = "<C-s>";
      options = {
        silent = true;
        desc = "Flash Treesitter Selection";
      };
      mode = ["n"];
      action.__raw =
        #lua
        ''
          function() require("flash").treesitter() end
        '';
    }
    {
      key = "<S-s>";
      options = {
        silent = true;
        desc = "Flash Jump";
      };
      mode = ["n" "x"];
      action.__raw =
        #lua
        ''
          function() require("flash").jump() end
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
    # Pick tab with leader+tab
    {
      key = "<leader><tab>";
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
    # Trouble
    {
      key = "<leader>xx";
      options = {
        silent = true;
        desc = "Diagnostics (Trouble)";
      };
      mode = ["n"];
      action = "<cmd>Trouble diagnostics toggle<CR>";
    }
    {
      key = "<leader>xX";
      options = {
        silent = true;
        desc = "Buffer Diagnostics (Trouble)";
      };
      mode = ["n"];
      action = "<cmd>Trouble diagnostics toggle filter.buf=0<CR>";
    }
    {
      key = "<leader>cs";
      options = {
        silent = true;
        desc = "Symbols (Trouble)";
      };
      mode = ["n"];
      action = "<cmd>Trouble symbols toggle focus=false<cr>";
    }
    {
      key = "<leader>cl";
      options = {
        silent = true;
        desc = "LSP Definitions / references / ... (Trouble)";
      };
      mode = ["n"];
      action = "<cmd>Trouble lsp toggle focus=false win.position=right<cr>";
    }
    {
      key = "<leader>cL";
      options = {
        silent = true;
        desc = "Location List (Trouble)";
      };
      mode = ["n"];
      action = "<cmd>Trouble loclist toggle<cr>";
    }
    {
      key = "<leader>cQ";
      options = {
        silent = true;
        desc = "Quickfix List (Trouble)";
      };
      mode = ["n"];
      action = "<cmd>Trouble qflist toggle<cr>";
    }
    {
      key = "<leader>X";
      options = {
        silent = true;
        desc = "Trouble pick list";
      };
      mode = ["n"];
      action = "<cmd>Trouble<cr>";
    }
    # Copilot
    {
      key = "<leader>Ca";
      options = {
        silent = true;
        desc = "Copilot auth";
      };
      mode = ["n"];
      action = "Copilot auth";
    }
    {
      key = "<leader>Cs";
      options = {
        silent = true;
        desc = "Copilot status";
      };
      mode = ["n"];
      action = "<cmd>Copilot status<cr>";
    }
    {
      key = "<leader>Cp";
      options = {
        silent = true;
        desc = "Copilot panel";
      };
      mode = ["n"];
      action = "<cmd>Copilot panel<cr>";
    }
    {
      key = "<leader>Cv";
      options = {
        silent = true;
        desc = "Copilot version";
      };
      mode = ["n"];
      action = "<cmd>Copilot version<cr>";
    }
  ];
  plugins.which-key.settings.spec = [
    {
      __unkeyed-1 = "<leader>f";
      group = "find";
      # icon = "";
    }
    {
      __unkeyed-1 = "<leader>g";
      group = "git";
      # icon = "";
    }
    {
      __unkeyed-1 = "<leader>gl";
      group = "line";
      # icon = "";
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
      __unkeyed-1 = "<leader>c";
      group = "code";
    }
    {
      __unkeyed-1 = "<leader>C";
      group = "copilot";
    }
    {
      __unkeyed-1 = "<leader>ct";
      group = "treesitter";
    }
    {
      __unkeyed-1 = "<leader>cf";
      group = "format";
    }
    {
      __unkeyed-1 = "<leader>c";
      group = "code";
    }
    {
      __unkeyed-1 = "<leader>t";
      group = "tabs";
      icon = "󰓩";
    }
    {
      __unkeyed-1 = "<leader>a";
      group = "avante";
      icon = "󰞵";
    }
    {
      __unkeyed-1 = "<leader>x";
      group = "trouble";
      icon = "󰞵";
    }
  ];
  lsp.keymaps = [
  ];
}
