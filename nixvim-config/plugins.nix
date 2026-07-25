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

    nix-develop = {
      # `nix develop` without restarting Neovim. Lazy-load only on .nix buffers.
      enable = true;
      lazyLoad.settings.event = [
        {
          event = "BufReadPost";
          pattern = "*.nix";
        }
      ];
    };

    wezterm = {
      enable = true;
    };

    # sidekick.nvim — AI CLI terminal (opencode / claude / codex / …).
    # NES (Next Edit Suggestions) is intentionally disabled — it requires the
    # Copilot language server, which we deliberately leave off. sidekick is used
    # purely as a managed terminal for external AI coding CLIs with shared prompt
    # context (file / selection / diagnostics). See keymaps.nix <leader>k.
    sidekick = {
      enable = true;
      settings = {
        nes.enabled = false;
        cli = {
          watch = true; # reload files in Neovim when an AI CLI edits them
          win.layout = "right";
          mux = {
            # Persist CLI sessions across Neovim restarts via tmux/zellij.
            # Kept off by default to avoid surprising side-effects; flip to true
            # and ensure tmux (or zellij) is on PATH to enable.
            backend = "tmux";
            enabled = false;
          };
        };
      };
      lazyLoad.settings.event = ["VimEnter"];
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
          event = ["VimEnter"];
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
      # nixvim's `autoActivate = true` injects a *global* LspAttach hook that
      # calls `require('otter').activate()` on every LSP attach. That conflicts
      # with our # BufReadPost lazy-load (for .py etc. otter isn't loaded yet),
      # so we disable it and add our own filetype-guarded, pcall-protected
      # autocmd below in `extraConfigLua`.
      autoActivate = false;
      settings = {
        handle_leading_whitespace = true;
        lsp.diagnostic_update_events = [
          "BufWritePost"
          "InsertLeave"
        ];
      };
      # Load only for files that actually contain embedded languages. Covers dbt
      # SQL models (Jinja blocks), SQL-in-markdown, .sql.jinja, Quarto notebooks.
      lazyLoad.settings.event = [
        {
          event = "BufReadPost";
          pattern = [
            "*.md"
            "*.sql"
            "*.jinja"
            "*.jinja2"
            "*.quarto"
            "*.qmd"
            "*.ipynb"
          ];
        }
      ];
    };

    opencode = {
      enable = true;
      settings = {
        auto_reload = true;
      };
      lazyLoad = {
        settings = {
          event = ["VimEnter"];
        };
      };
    };
    # grug-far is in ../shared/plugins.nix
    # NOTE: avante has been removed in favour of sidekick (AI CLI terminal) +
    # opencode. See AGENTS.md "Things to avoid".
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

    # ── Database client (dbee) ────────────────────────────────────────────
    # dbee is a native Go-driver SQL browser/runner — no Snowflake driver
    # exists upstream (tracked but unmerged: kndndrj/nvim-dbee#23, PRs #109 /
    # #186), so it's only useful here for non-Snowflake connections (e.g. a
    # local Postgres/DuckDB). Snowflake itself is queried via the `snow` CLI,
    # driven by overseer templates (overseer/snowflake_tasks.lua) and
    # betterTerm — see keymaps.nix <leader>Q and AGENTS.md.
    dbee = {
      enable = true;
      lazyLoad.settings.cmd = ["DbeeToggle"];
    };
  };

  # dbt / Snowflake helpers:
  # 1. Jinja-brace highlighting inside .sql model files (filetype stays `sql`
  #    so sqls LSP keeps working — only visual highlighting is added).
  # 2. target/** compiled-SQL buffers are forced readonly to prevent accidental
  #    edits to expanded Jinja output.
  extraFiles = {
    # `on_complete_callback` is not a real overseer.nvim component (verified:
    # overseer ships on_complete_dispose/notify/restart only — an ad-hoc
    # component name silently resolve()s but throws "Unknown component" the
    # moment a task using it is actually constructed). overseer.nvim has no
    # public API to register a component from Lua at runtime — components
    # are only loadable from `lua/overseer/component/<name>.lua` on the
    # runtime path — so this file supplies that missing component for real.
    # Used by overseer/dbt_tasks.lua's "dbt compile (current model) — open
    # compiled SQL" template to auto-open the compiled file after a
    # successful compile.
    "lua/overseer/component/on_complete_callback.lua".text =
      #lua
      ''
        ---@type overseer.ComponentFileDefinition
        return {
          desc = "Calls a user-supplied function with (task, status) when the task completes",
          params = {
            callback = { type = "opaque" },
          },
          constructor = function(params)
            return {
              on_complete = function(_self, task, status)
                params.callback(task, status)
              end,
            }
          end,
        }
      '';
    "ftplugin/sql.lua".text =
      #lua
      ''
        -- Jinja-brace highlighting for dbt models. Keeps `filetype=sql` (so the
        -- `sqls` LSP and sqruff formatter keep working) and only adds distinct
        -- highlighting for `{{ … }}` and `{% … %}` blocks on top of the SQL
        -- syntax. No new treesitter parser or plugin is loaded.
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "sql",
          callback = function()
            if vim.b.sql_jinja_highlighted then return end
            vim.b.sql_jinja_highlighted = true
            vim.cmd("syntax region sqlJinjaStatement matchgroup=sqlJinjaDelim start=/{%/ end=/%}/ contains=@SQL transparent keepend")
            vim.cmd("syntax region sqlJinjaExpr      matchgroup=sqlJinjaDelim start=/{{/ end=/}}/ contains=@SQL transparent keepend")
            vim.cmd("syntax match  sqlJinjaComment  /{#[^#]*#}/")
            vim.cmd("highlight default link sqlJinjaDelim Special")
            vim.cmd("highlight default link sqlJinjaComment Comment")
          end,
        })

        -- Force compiled dbt output under target/ to be read-only to avoid
        -- accidentally editing expanded Jinja instead of the source model.
        vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
          pattern = "*/target/**/*.sql",
          callback = function() vim.bo.readonly = true end,
        })
      '';
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

      -- otter: activate embedded-language LSP only for buffers that (a) have an
      -- embedded language we care about, and (b) actually loaded the otter plugin
      -- via our BufReadPost lazy-load. Protected by pcall so a missing module on
      -- a non-matching buffer (e.g. a .py file) never throws on LspAttach.
      -- This replaces nixvim's `autoActivate = true` global hook, which is
      -- incompatible with lazy-loading (it require()'s otter unconditionally).
      local otter_filetypes = {
        ["markdown"] = true,
        ["quarto"] = true,
        ["ipynb"] = true,
        ["sql"] = true,
        ["jinja"] = true,
        ["jinja2"] = true,
      }
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("otter_autoactivate", { clear = true }),
        callback = function(args)
          if not otter_filetypes[vim.bo[args.buf].filetype] then return end
          pcall(function() require("otter").activate() end)
        end,
      })
    '';
}
