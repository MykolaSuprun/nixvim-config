# Shared keymaps — imported by both nixvim-config and codevim-config.
# These keymaps work identically in full Neovim and VSCode embedded mode.
# Requires: gitsigns, grug-far, persistence, snacks, conform-nvim, trouble
# (all available in both configs via shared/plugins.nix and per-config plugins).
_: {
  keymaps = [
    # --- Diagnostic navigation ---
    # vim.diagnostic is populated automatically by vscode-neovim in VSCode embedded mode.
    # [d / ]d are Neovim's built-in defaults; the float on jump comes from
    # `diagnostic.settings.jump.on_jump` (shared/options.nix), which also
    # applies to the error-only jumps below.
    {
      key = "[e";
      options = {
        silent = true;
        desc = "Previous Error";
      };
      mode = ["n"];
      action.__raw = ''function() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR }) end'';
    }
    {
      key = "]e";
      options = {
        silent = true;
        desc = "Next Error";
      };
      mode = ["n"];
      action.__raw = ''function() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR }) end'';
    }

    # --- Flash (pure editing, works natively in both) ---
    {
      key = "<C-s>";
      options = {
        silent = true;
        desc = "Flash Treesitter Selection";
      };
      mode = ["n"];
      action.__raw = ''function() require("flash").treesitter() end'';
    }
    # Normal mode only: visual `S` belongs to nvim-surround (add surrounding),
    # which overwrote this map in `x` mode anyway.
    {
      key = "<S-s>";
      options = {
        silent = true;
        desc = "Flash Jump";
      };
      mode = ["n"];
      action.__raw = ''function() require("flash").jump() end'';
    }

    # --- Git line info (gitsigns + snacks) ---
    {
      key = "<leader>glt";
      options = {
        silent = true;
        desc = "Toggle Line Blame";
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
      action.__raw = ''function() Snacks.picker.git_log_line() end'';
    }
    {
      key = "<leader>glb";
      options = {
        silent = true;
        desc = "Git Blame Line";
      };
      mode = ["n"];
      action.__raw = ''function() Snacks.git.blame_line() end'';
    }
    {
      key = "<leader>glB";
      options = {
        silent = true;
        desc = "Git Browse Line";
      };
      mode = ["n"];
      action.__raw = ''function() Snacks.gitbrowse() end'';
    }

    # --- Git pickers (snacks) ---
    {
      key = "<leader>gL";
      options = {
        silent = true;
        desc = "Git Log";
      };
      mode = ["n"];
      action.__raw = ''function() Snacks.picker.git_log() end'';
    }
    {
      key = "<leader>gs";
      options = {
        silent = true;
        desc = "Git Status";
      };
      mode = ["n"];
      action.__raw = ''function() Snacks.picker.git_status() end'';
    }

    # --- Notifications ---
    {
      key = "<leader>n";
      options = {
        silent = true;
        desc = "Notifications History";
      };
      mode = ["n"];
      action.__raw = ''function() Snacks.notifier.show_history() end'';
    }

    # --- Format (conform) ---
    {
      key = "<leader>cff";
      options = {
        silent = true;
        desc = "Format";
      };
      mode = ["n"];
      action.__raw = ''function() require("conform").format() end'';
    }
    {
      key = "<leader>cfF";
      options = {
        silent = true;
        desc = "Format Injected Langs";
      };
      mode = ["n"];
      action.__raw = ''
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
      action = "<cmd>FormatEnable<CR>";
    }
    {
      key = "<leader>cfT";
      options = {
        silent = true;
        desc = "Disable Format On Save";
      };
      mode = ["n"];
      action = "<cmd>FormatDisable<CR>";
    }

    # --- Treesitter inspect ---
    {
      key = "<leader>cti";
      options = {
        silent = true;
        desc = "Treesitter Inspect";
      };
      mode = ["n"];
      action = "<cmd>Inspect<CR>";
    }
    {
      key = "<leader>ctt";
      options = {
        silent = true;
        desc = "Treesitter Inspect Tree";
      };
      mode = ["n"];
      action = "<cmd>InspectTree<CR>";
    }

    # --- Gitsigns hunk navigation ---
    {
      key = "]h";
      options = {
        silent = true;
        desc = "Next Hunk";
      };
      mode = ["n"];
      action = "<cmd>Gitsigns nav_hunk next<cr>";
    }
    {
      key = "[h";
      options = {
        silent = true;
        desc = "Previous Hunk";
      };
      mode = ["n"];
      action = "<cmd>Gitsigns nav_hunk prev<cr>";
    }
    {
      key = "<leader>ghs";
      options = {
        silent = true;
        desc = "Stage Hunk";
      };
      mode = ["n" "x"];
      action = "<cmd>Gitsigns stage_hunk<cr>";
    }
    {
      key = "<leader>ghr";
      options = {
        silent = true;
        desc = "Reset Hunk";
      };
      mode = ["n" "x"];
      action = "<cmd>Gitsigns reset_hunk<cr>";
    }
    {
      key = "<leader>ghp";
      options = {
        silent = true;
        desc = "Preview Hunk";
      };
      mode = ["n"];
      action = "<cmd>Gitsigns preview_hunk<cr>";
    }

    # --- Session (persistence) ---
    {
      key = "<leader>qs";
      options = {
        silent = true;
        desc = "Restore Session";
      };
      mode = ["n"];
      action.__raw = ''function() require("persistence").load() end'';
    }
    {
      key = "<leader>ql";
      options = {
        silent = true;
        desc = "Restore Last Session";
      };
      mode = ["n"];
      action.__raw = ''function() require("persistence").load({ last = true }) end'';
    }
    {
      key = "<leader>qd";
      options = {
        silent = true;
        desc = "Don't Save Session";
      };
      mode = ["n"];
      action.__raw = ''function() require("persistence").stop() end'';
    }

    # --- Find and replace (grug-far) ---
    {
      key = "<leader>rr";
      options = {
        silent = true;
        desc = "Find and Replace (ast-grep)";
      };
      mode = ["n"];
      action.__raw = ''function() require("grug-far").open({ engine = "astgrep" }) end'';
    }
    {
      key = "<leader>rR";
      options = {
        silent = true;
        desc = "Find and Replace (ripgrep)";
      };
      mode = ["n"];
      action.__raw = ''function() require("grug-far").open({ engine = "ripgrep" }) end'';
    }
    {
      key = "<leader>rw";
      options = {
        silent = true;
        desc = "Find and Replace Word";
      };
      mode = ["n"];
      action.__raw = ''function() require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } }) end'';
    }
    {
      key = "<leader>rf";
      options = {
        silent = true;
        desc = "Find and Replace in File (ast-grep)";
      };
      mode = ["n"];
      action.__raw = ''function() require("grug-far").open({ engine = "astgrep", prefills = { paths = vim.fn.expand("%") } }) end'';
    }
    {
      key = "<leader>rF";
      options = {
        silent = true;
        desc = "Find and Replace in File (ripgrep)";
      };
      mode = ["n"];
      action.__raw = ''function() require("grug-far").open({ engine = "ripgrep", prefills = { paths = vim.fn.expand("%") } }) end'';
    }
    {
      key = "<leader>rv";
      options = {
        silent = true;
        desc = "Find and Replace in Selection";
      };
      mode = ["x"];
      # `:` (not <cmd>) so the visual range reaches the range command.
      action = ":GrugFarWithin<cr>";
    }

    # --- Trouble (diagnostic list) ---
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
      key = "<leader>xS";
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
        desc = "LSP References / Definitions (Trouble)";
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
      key = "<leader>xp";
      options = {
        silent = true;
        desc = "Trouble Picker";
      };
      mode = ["n"];
      action = "<cmd>Trouble<cr>";
    }
  ];

  plugins.which-key.settings.spec = [
    {
      __unkeyed-1 = "<leader>c";
      group = "code";
    }
    {
      __unkeyed-1 = "<leader>cf";
      group = "format";
    }
    {
      __unkeyed-1 = "<leader>ct";
      group = "treesitter";
    }
    {
      __unkeyed-1 = "<leader>g";
      group = "git";
    }
    {
      __unkeyed-1 = "<leader>gh";
      group = "hunk";
      icon = "";
    }
    {
      __unkeyed-1 = "<leader>gl";
      group = "line";
    }
    {
      __unkeyed-1 = "<leader>r";
      group = "find and Replace";
      icon = "";
    }
    {
      __unkeyed-1 = "<leader>x";
      group = "trouble";
    }
    {
      __unkeyed-1 = "<leader>q";
      group = "session";
      icon = "󰃘";
    }
  ];
}
