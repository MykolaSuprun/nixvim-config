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
      diagnostics.enable = true;
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
      teraformls.enable = true;
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
          "flake8"
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
          "jsonlint"
          "codespell"
        ];
        sql = [
          "sqruff"
          "codespell"
        ];
        yaml = [
          "yamllint"
          "yq"
        ];
        markdown = [
          "markdownlint-cli2"
        ];
        lua = [
          "selene"
        ];
        zsh = [
          "zsh"
        ];
      };
    };
    none-ls = {
      enable = false;
      lazyLoad = {
        settings = {
          event = ["BufEnter"];
        };
      };
      settings = {
        code_actions = {
          gitrebase.enable = true;
          gitsigns.enable = true;
          proselint.enable = true;
          refactoring.enable = true;
          statix.enable = true;
        };
        completion = {
          luasnip.enable = true;
          nvim_snippets.enable = true;
          spell.enable = true;
          tags.enable = true;
        };
        diagnostics = {
          codespell.enable = true;
          deadnix.enable = true;
          dotenv_linter.enable = true;
          golangci_lint.enable = true;
          hadolint.enable = true;
          markdownlint_cli2.enable = true;
          pydoclint.enable = true;
          pylint.enable = true;
          selene.enable = true;
          sqruff.enable = true;
          statix.enable = true;
          tidy.enable = true;
          todo_comments = true;
          yamllint.enable = true;
          zsh.enable = true;
        };
        hover = {
          dictionary.enable = true;
          printenv.enable = true;
        };
      };
    };
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
  # cmp = {
  #   enable = true;
  #   autoEnableSources = true;
  #   settings = {
  #     sources = [
  #       { name = "nvim_lsp"; }
  #       { name = "path"; }
  #       { name = "buffer"; }
  #     ];
  #     mapping = {
  #       "<C-j>" = "cmp.mapping(cmp.mapping.select_next_item())";
  #       "<C-k>" = "cmp.mapping(cmp.mapping.select_prev_item())";
  #       "<C-n>" = "cmp.mapping.scroll_docs(4)";
  #       "<C-p>" = "cmp.mapping.scroll_docs(-4)";
  #       "<C-h>" = "cmp.mapping.abort()";
  #       "<C-l>" = "cmp.mapping.confirm({ select = true })";
  #       "<CR>" = "cmp.mapping.confirm({ select = true })";
  #       "<C-Space>" = "cmp.mapping.complete()";
  #     };
  #   };
  # };
}
