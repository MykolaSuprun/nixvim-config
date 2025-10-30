{
  pkgs,
  lib,
  ...
}: {
  #TODO:lazy load as much as possible
  plugins = {
    lz-n = {
      enable = true;
    };
    treesitter = {
      enable = true;
      nixvimInjections = true;
      settings = {
        indent.enable = true;
        highlight.enable = true;
        incremental_selection = {
          enable = true;
          # keymaps = {
          #   init_selection = false;
          #   node_decremental = "grm";
          #   node_incremental = "grn";
          #   scope_incremental = "grc";
          # };
        };
      };
      lazyLoad = {
        settings = {
          event = ["BufEnter"];
        };
      };
    };
    treesitter-context = {
      enable = true;
      settings = {
        enable = true;
        line_numbers = true;
        max_lines = 3;
        mode = "cursor";
      };
      lazyLoad = {
        settings = {
          event = ["BufEnter"];
        };
      };
    };
    treesitter-refactor.enable = true;
    treesitter-textobjects.enable = true;
    diffview = {
      enable = true;
      useIcons = true;
      watchIndex = true;
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

    web-devicons.enable = true;

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
        float.__raw =
          #lua
          ''
            {
              padding = 2,
              max_width = 0.8,
              max_height = 0.8,
              border = "rounded",
            }
          '';
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

          win = {
            input = {
              keys = {
                __raw =
                  #lua
                  ''
                    {
                      ["<S-k>"] = { "preview_scroll_up", mode = { "i", "n" } },
                      ["<S-j>"] = { "preview_scroll_down", mode = { "i", "n" } },
                    }
                  '';
              };
            };
            list = {
              keys = {
                __raw =
                  #lua
                  ''
                    {
                      ["<S-k>"] = { "preview_scroll_up", mode = { "i", "n" } },
                      ["<S-j>"] = { "preview_scroll_down", mode = { "i", "n" } },
                    }
                  '';
              };
            };
          };
        };
      };
    };

    ts-comments.enable = true;

    # Git
    gitsigns.enable = true;

    # LLM
    copilot-lua = {
      enable = true;
      lazyLoad = {
        settings = {
          event = ["VimEnter"];
          sugesstion.enabled = false;
        };
      };
    };

    # Code
    nvim-autopairs = {
      enable = true;
      lazyLoad = {
        settings = {
          event = ["BufEnter"];
        };
      };
      settings = {
        check_ts = true;
      };
    };
    mini-align = {
      enable = true;
    };
    flash = {
      enable = true;
      settings = {
        label.rainbow.enable = true;
        modes = {
          char = {
            enabled = true;
          };
        };
      };
    };

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
          yaml = ["yamlftm"];
          sql = ["sqlruff"];
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
    avante = {
      enable = true;
      lazyLoad = {
        settings = {
          event = ["BufEnter"];
        };
      };
      settings = {
        auto_suggestions_provider = "copilot";
        provider = "copilot";
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
            # Additional snacks.input options
            title = "Avante Input";
            icon = " ";
          };
        };
      };
    };
  };

  autoCmd = [
    {
      event = [
        "VimLeave"
      ];
      pattern = ["*"];
      command = "silent !zellij action switch-mode normal";
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
