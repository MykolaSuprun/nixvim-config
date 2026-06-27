{
  pkgs,
  lib,
  ...
}: {
  # NOTE: lz-n, treesitter, treesitter-textobjects, nvim-autopairs, mini-align,
  # ts-comments, flash, nvim-surround, illuminate, and todo-comments are declared
  # in ../shared/editing.nix and apply to both nixvim and codevim.
  # gitsigns, treesitter-context, grug-far, persistence, and web-devicons are
  # declared in ../shared/plugins.nix and apply to both nixvim and codevim.
  plugins = {
    diffview = {
      enable = true;
      settings = {
        use_icons = true;
        watch_index = true;
      };
    };

    lazygit = {
      enable = true;
      settings = {
        floating_window_scaling_factor = 1;
        floating_window_use_plenary = 1;
      };
    };

    nix-develop.enable = true;

    wezterm = {
      enable = true;
    };

    # web-devicons is declared in ../shared/plugins.nix

    oil = {
      enable = true;
      settings = {
        default_file_explorer = true;
        constrain_cursor = "editable";
        watch_for_changes = true;
        columns = [
          "icon"
        ];
        win_options = {
          signcolumn = "yes:2";
        };
        # float.__raw =
        #   #lua
        #   ''
        #     {
        #       padding = 2,
        #       max_width = 0.8,
        #       max_height = 0.8,
        #       border = "rounded",
        #     }
        #   '';
      };
      luaConfig.post =
        #lua
        ''
          vim.api.nvim_create_autocmd("User", {
          	pattern = "OilActionsPost",
          	callback = function(event)
          		if event.data.actions.type == "move" then
          			Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
          		end
          	end,
          })
        '';
    };

    oil-git-status = {
      enable = true;
    };

    tmux-navigator = {
      enable = true;
      settings.no_mappings = 1;
    };

    colorful-winsep = {
      enable = true;
      settings = {
        border = "rounded";
        highlight = "#7287fd";
        excluded_ft = [
          "NvimTree"
          "lazy"
          "mason"
          "noice"
          "OverseerList"
          "snacks_terminal"
          "snacks_picker_input"
          "snacks_picker_list"
        ];
        animate.enabled = "shift";
      };
    };

    zellij-nav = {
      enable = false;
    };

    noice = {
      enable = true;
    };

    snacks = {
      enable = true;
      settings = {
        animate = {
          enabled = true;
          fps = 120;
        };
        image.enabled = true;
        bigfile = {
          enabled = true;
          notify = true;
        };
        notifier = {
          enabled = true;
          style = "compact";
        };
        explorer.enabled = true;
        quickfile.enabled = true;
        git.enabled = true;
        gitbrowse.enabled = true;
        # uses snacks_indent_enabled global option for toggle functionality
        indent = {
          enabled = true;
          only_scope = true;
          only_current = true;
        };
        scroll = {
          enabled = true;
          inertia = true;
          multiplier = 1.0;
        };
        input = {
          enabled = true;
        };
        picker = {
          enabled = true;
          layout.__raw =
            #lua
            "{ layout = { backdrop = false } }";

          # win = {
          #   input = {
          #     keys = {
          #       __raw =
          #         #lua
          #         ''
          #         '';
          #     };
          #   };
          #   list = {
          #     keys = {
          #       __raw =
          #         #lua
          #         ''
          #         '';
          #     };
          #   };
          # };
        };
      };
    };
    hardtime = {
      enable = true;
      settings.enabled = true;
      lazyLoad = {
        settings = {
          event = ["BufEnter"];
        };
      };
    };
    # ts-comments is in ../shared/editing.nix
    # gitsigns is in ../shared/plugins.nix

    # LLM
    copilot-lua = {
      enable = false;
      settings = {
        suggestion = {
          enabled = false;
          auto_trigger = false;
        };
      };
      lazyLoad = {
        settings = {
          event = ["VimEnter"];
        };
      };
    };

    # Code — nvim-autopairs, mini-align, flash, nvim-surround, illuminate, ts-comments
    # are now in ../shared/editing.nix. Only nixvim-specific code plugins below.

    # Formatting
    conform-nvim = {
      enable = true;
      lazyLoad = {
        settings = {
          event = ["BufEnter"];
        };
      };
      settings = {
        log_level = "error";
        notify_on_error = true;
        notify_no_formatters = true;
        default_format_opts = {
          timeout_ms = 3000;
          async = true;
          quiet = false;
          lsp_format = "fallback";
        };
        format_on_save = {
          timeout_ms = 500;
          lsp_format = "fallback";
        };
        formatters_by_ft = {
          lua = ["stylua"];
          go = ["gofmt"];
          python = ["ruff_format" "ruff_organize_imports"];
          nix = ["alejandra"];
          bash = [
            "shellcheck"
            "shellharden"
            "shfmt"
          ];
          css = ["`css_beautify`"];
          json = ["jq"];
          yaml = ["yamlfmt"];
          sql = ["sqruff"];
          "_" = ["trim_whitespace"];
        };
        formatters = {
          injected = {options = {ignore_errors = true;};};
        };
      };
      luaConfig.post =
        #lua
        ''
          require("conform").setup({
          	format_on_save = function(bufnr)
          		-- Disable with a global or buffer-local variable
          		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          			return
          		end
          		return { timeout_ms = 500, lsp_format = "fallback" }
          	end,
          })

          vim.api.nvim_create_user_command("FormatDisable", function(args)
          	if args.bang then
          		-- FormatDisable! will disable formatting just for this buffer
          		vim.b.disable_autoformat = true
          	else
          		vim.g.disable_autoformat = true
          	end
          end, {
          	desc = "Disable autoformat-on-save",
          	bang = true,
          })
          vim.api.nvim_create_user_command("FormatEnable", function()
              vim.b.disable_autoformat = false
              vim.g.disable_autoformat = false
            end, {
          	desc = "Re-enable autoformat-on-save",
          })
        '';
    };

    otter = {
      enable = true;
      autoActivate = true;
      settings = {
        handle_leading_whitespace = true;
        lsp.diagnostic_update_events = [
          "BufWritePost"
          "InsertLeave"
        ];
      };
      # lazyLoad = {
      #   settings = {
      #     event = ["BufEnter"];
      #   };
    };

    avante = {
      enable = true;
      lazyLoad = {
        settings = {
          event = ["BufEnter"];
        };
      };
      settings = {
        # Changed from "ollama" to "lmstudio"
        provider = "lmstudio";
        auto_suggestions_provider = "lmstudio";

        providers = {
          # LM Studio local configuration
          lmstudio = {
            __inherited_from = "openai";
            endpoint = "http://localhost:1234/v1";
            model = "qwopus3.6-27b-coder-mtp";
            api_key_name = "NVIM_LM_STUDIO_API_KEY";
            # disable_tools = true; # Highly recommended for local models to prevent crashing/hallucinations
          };
          openrouter = {
            __inherited_from = "openai";
            endpoint = "https://openrouter.ai/api/v1";
            api_key_name = "OPENROUTER_API_KEY";
            model = "moonshotai/kimi-k2.6";
          };
          # Hide Copilot from model selector to avoid auth errors
          copilot = {
            hide_in_model_selector = true;
          };
        };
        web_search_engine = {
          provider = "kagi";
        };
        selector = {
          provider = "snacks";
          provider_opts = {
            layout = "select";
          };
        };
        input = {
          provider = "snacks";
          provider_opts = {
            title = "Avante Input";
            icon = " ";
          };
        };
      };
    };
    # grug-far is in ../shared/plugins.nix
    obsidian = {
      enable = true;
      lazyLoad = {
        settings = {
          cmd = "Obsidian";
        };
      };
      settings = {
        workspaces = [
          {
            name = "general-1";
            path = "~/Documents/obsidian/general-1/";
          }
          {
            name = "work-1";
            path = "/mnt/c/obsidian/work-1";
          }
        ];
      };
    };

    # persistence is in ../shared/plugins.nix

    # Diagnostic list panel
    trouble = {
      enable = true;
      settings = {
        auto_close = false;
        auto_preview = true;
        focus = true;
        modes = {
          diagnostics = {
            auto_open = false;
          };
        };
      };
    };

    # Symbol outline panel (LSP + treesitter backends)
    aerial = {
      enable = true;
      settings = {
        backends = ["treesitter" "lsp" "markdown" "man"];
        layout = {
          max_width = [40 0.2];
          width = null;
          min_width = 20;
          default_direction = "prefer_right";
        };
        attach_mode = "window";
        show_guides = true;
        filter_kind = false;
      };
    };

    # File bookmarks with per-project numbered slots
    harpoon = {
      enable = true;
      enableTelescope = false;
    };

    # Center the current window by adding equal padding buffers on each side
    no-neck-pain = {
      enable = true;
      settings = {
        width = 120;
        autocmds = {
          enableOnVimEnter = false;
          enableOnTabEnter = false;
          reloadOnColorSchemeChange = true;
        };
      };
    };

    # Unified test runner — supersedes overseer python test templates
    neotest = {
      enable = true;
      lazyLoad.settings.event = ["BufEnter"];
      adapters.python = {
        enable = true;
        settings = {
          runner = "pytest";
        };
      };
    };
  };

  autoCmd = [
    {
      event = ["VimLeave"];
      pattern = ["*"];
      # Only run zellij mode reset when actually inside a Zellij session
      callback.__raw = ''
        function()
          if os.getenv("ZELLIJ") then
            vim.fn.system("zellij action switch-mode normal")
          end
        end
      '';
    }
  ];

  extraPlugins = with pkgs.vimPlugins; [
    # fyler-nvim
    render-markdown-nvim
  ];

  extraConfigLua =
    #lua
    ''
      -- require("fyler").setup()
    '';
}
