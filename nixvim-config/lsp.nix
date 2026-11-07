_: {
  lsp = {
    inlayHints.enable = true;
    servers = {
      bashls.enable = true;
      # clangd runs clang-tidy internally (--clang-tidy) reading .clang-tidy
      # and compile_commands.json — no separate per-save linter needed.
      # Needs a compilation database: CMake export, `bear -- <build cmd>`,
      # or a hand-written compile_flags.txt in the project root.
      clangd = {
        enable = true;
        # New-style nixvim LSP module: server settings live under `config`
        # (passed to vim.lsp.config).
        config = {
          cmd = [
            "clangd"
            "--background-index"
            "--clang-tidy"
            "--header-insertion=iwyu"
            "--completion-style=detailed"
            "--function-arg-placeholders"
            "--fallback-style=llvm"
          ];
        };
      };
      html.enable = true;
      # htmx-lsp disabled: it emits `LSP[htmx]: Error INVALID_SERVER_MESSAGE`
      # on every markdown buffer (the server returns malformed JSON-RPC ids).
      # Present in ~/.local/state/nvim/lsp.log since 2026-05-23; nothing to do
      # with our config. Re-enable only if upstream fixes the id handling.
      htmx.enable = false;
      gopls.enable = true;
      metals.enable = true;
      cssls.enable = true;
      # NOTE: 'diagnostics' is not a standard LSP server name. If you want
      # diagnostic-languageserver (runs linters via LSP), use 'diagnosticls'.
      # Currently disabled to avoid a silent no-op. nvim-lint already handles linting.
      # diagnosticls.enable = true;
      dockerls.enable = true;
      docker_compose_language_service.enable = true;
      hyprls.enable = true;
      jqls.enable = true;
      jsonls.enable = true;
      lua_ls.enable = true;
      markdown_oxide.enable = true;
      nixd.enable = true;
      statix.enable = true;
      basedpyright.enable = true;
      ruff.enable = true;
      sqls.enable = true;
      systemd_ls.enable = true;
      terraformls.enable = true;
      yamlls.enable = true;
    };
  };
  plugins = {
    lspconfig = {
      enable = true;
    };
    lint = {
      enable = true;
      lintersByFt = {
        # ruff/statix are deliberately NOT listed: their LSPs (lsp.servers.ruff
        # / statix) already publish live per-file diagnostics, and the overseer
        # `ruff check` template covers the project-wide sweep. nvim-lint only
        # adds linters with no LSP equivalent.
        python = [
          "codespell"
          "bandit"
        ];
        nix = [
          "deadnix"
          "codespell"
        ];
        dockerfile = [
          "hadolint"
          # "dockle"
        ];
        json = [
          "codespell"
        ];
        sql = [
          "sqruff"
          "codespell"
        ];
        yaml = [
          "yamllint"
          "codespell"
        ];
        markdown = [
          "markdownlint-cli2"
        ];
        lua = [
          "selene"
          "codespell"
        ];
        zsh = [
          "zsh"
        ];
        # shellcheck moved here from conform's formatters_by_ft (plugins.nix):
        # lint belongs in the lint layer. nvim-lint ships a shellcheck linter;
        # the try_lint autocmd (nixvim lint module) already fires on save.
        bash = [
          "shellcheck"
        ];
        sh = [
          "shellcheck"
        ];
      };
    };
    # NOTE: none-ls is intentionally removed in favour of nvim-lint + conform-nvim.
    # See AGENTS.md "Things to avoid".
    blink-cmp = {
      enable = true;
      setupLspCapabilities = true;
      settings = {
        cmdline.enabled = true;
        # NOTE: codecompanion ships a first-party blink source
        # (lua/codecompanion/providers/completion/blink) that self-registers
        # for the codecompanion / codecompanion_input filetypes on blink >= 0.11
        # — no per_filetype entry needed here. On an older blink you would add
        # `codecompanion = [ "codecompanion" ]` to sources.per_filetype.
        sources = {
          providers.lsp.fallbacks = [];
        };
        completion = {
          accept = {
            create_undo_point = true;
            auto_brackets.enabled = true;
          };
          list = {
            selection = {
              preselect = false;
              auto_insert = true;
            };
          };
          menu = {
            enabled = true;
            auto_show = true;
          };
          documentation = {
            auto_show = true;
            treesitter_highlighting = true;
          };
          ghost_text = {
            enabled = false;
          };
        };
        fuzzy = {
          frecency.enabled = true;
          use_proximity = true;
          # use_typo_resistance = true;
        };
        signature.enabled = true;
        keymap = {
          "<C-h>" = [
            "hide"
          ];
          "<C-n>" = [
            "scroll_documentation_down"
            "fallback"
          ];
          "<C-p>" = [
            "scroll_documentation_up"
            "fallback"
          ];
          "<C-j>" = [
            "select_next"
            "fallback"
          ];
          # preselect = false: Enter only accepts an item you explicitly
          # selected (<C-j>/<C-k>); otherwise it falls through to a newline.
          "<CR>" = [
            "accept"
            "fallback"
          ];
          "<C-k>" = [
            "select_prev"
            "fallback"
          ];
          "<C-space>" = [
            "show"
            "show_documentation"
            "hide_documentation"
          ];
          "<C-l>" = [
            "select_and_accept"
          ];
          "<S-Tab>" = [
            "snippet_backward"
            "fallback"
          ];
          "<Tab>" = [
            "snippet_forward"
            "fallback"
          ];
        };
      };
    };
    trouble = {
      enable = true;
      lazyLoad = {
        settings = {
          event = ["BufEnter"];
        };
      };
      settings = {
        auto_close = false;
        auto_preview = true;
        auto_refresh = true;
        focus = true;
        modes.diagnostics.auto_open = false;
      };
    };
  };
}
