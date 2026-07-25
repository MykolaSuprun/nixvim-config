{pkgs, ...}: {
  lsp = {
    inlayHints.enable = true;
    servers = {
      bashls.enable = true;
      html.enable = true;
      htmx.enable = true;
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
        python = [
          "ruff"
          "codespell"
          "bandit"
        ];
        nix = [
          "statix"
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
      };
    };
    # NOTE: none-ls is intentionally removed in favour of nvim-lint + conform-nvim.
    # See AGENTS.md "Things to avoid".
    blink-cmp = {
      enable = true;
      setupLspCapabilities = true;
      settings = {
        cmdline.enabled = false;
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
          "<CR>" = [
            "select_next"
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
        auto_preview = true;
        auto_refresh = true;
      };
    };
  };
}
