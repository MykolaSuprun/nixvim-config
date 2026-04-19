# codevim plugins — a curated subset of nixvim plugins that work correctly
# inside VSCode's embedded Neovim session.
#
# Excluded (VSCode handles these natively):
#   noice, bufferline, lualine, catppuccin, oil, lazygit, diffview,
#   tmux-navigator, wezterm, copilot-lua, avante, obsidian, overseer,
#   otter, hardtime, nix-develop, image, ueberzug
#
# Inherited from ../shared/editing.nix (already active):
#   lz-n, treesitter, treesitter-textobjects, nvim-autopairs, mini-align,
#   ts-comments, flash, nvim-surround, illuminate, todo-comments
# Inherited from ../shared/plugins.nix (already active):
#   gitsigns, treesitter-context, grug-far, persistence, web-devicons
{...}: {
  plugins = {
    which-key = {
      enable = true;
      settings = {
        preset = "helix";
        notify = true;
      };
    };

    # snacks — minimal VSCode-compatible subset
    snacks = {
      enable = true;
      settings = {
        # Disable features that conflict with or duplicate VSCode
        animate.enabled = false;
        scroll.enabled = false;
        image.enabled = false;
        indent.enabled = false;
        explorer.enabled = false;
        zen.enabled = false;
        # Enable VSCode-compatible features
        bigfile = {
          enabled = true;
          notify = true;
        };
        notifier = {
          enabled = true;
          style = "compact";
        };
        git.enabled = true;
        gitbrowse.enabled = true;
        quickfile.enabled = true;
        input.enabled = true;
        picker = {
          enabled = true;
          layout.__raw = "{ layout = { backdrop = false } }";
        };
      };
    };

    # Formatting — disabled by default so VSCode's own formatters run.
    # Enable with <leader>cft or :FormatEnable if you prefer Neovim formatting.
    conform-nvim = {
      enable = true;
      lazyLoad.settings.event = ["BufEnter"];
      settings = {
        log_level = "error";
        notify_on_error = true;
        notify_no_formatters = false;
        default_format_opts = {
          timeout_ms = 3000;
          async = true;
          quiet = false;
          lsp_format = "fallback";
        };
        formatters_by_ft = {
          lua = ["stylua"];
          python = ["ruff_format" "ruff_organize_imports"];
          "_" = ["trim_whitespace"];
        };
        formatters = {
          injected.options.ignore_errors = true;
        };
      };
      luaConfig.post =
        #lua
        ''
          -- Format-on-save is DISABLED by default in codevim.
          -- VSCode handles formatting unless you explicitly enable Neovim formatting.
          vim.g.disable_autoformat = true

          vim.api.nvim_create_user_command("FormatDisable", function(args)
            if args.bang then
              vim.b.disable_autoformat = true
            else
              vim.g.disable_autoformat = true
            end
          end, { desc = "Disable autoformat-on-save", bang = true })

          vim.api.nvim_create_user_command("FormatEnable", function()
            vim.b.disable_autoformat = false
            vim.g.disable_autoformat = false
          end, { desc = "Re-enable autoformat-on-save" })

          require("conform").setup({
            format_on_save = function(bufnr)
              if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
              end
              return { timeout_ms = 500, lsp_format = "fallback" }
            end,
          })
        '';
    };

    # Diagnostic list view — reads from vim.diagnostic which vscode-neovim
    # automatically populates with all VSCode diagnostics.
    trouble = {
      enable = true;
      lazyLoad.settings.event = ["BufEnter"];
      settings = {
        auto_preview = false; # VSCode already shows inline previews
        auto_refresh = true;
      };
    };
    # web-devicons is declared in ../shared/plugins.nix
  };
}
