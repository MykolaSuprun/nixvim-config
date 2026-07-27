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

    # NOTE: tmux-navigator was removed — <M-h/j/k/l> pane navigation has been
    # dropped in favour of in-editor window navigation (<leader>h/j/k/l) and
    # the herd/sidekick agent backends. See AGENTS.md "Things to avoid".

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

          # Custom picker actions: send selected items to an AI agent.
          #   <a-o> → opencode.nvim (require("opencode").format/prompt)
          #   <a-a> → sidekick.nvim (require("sidekick.cli.picker.snacks").send)
          # `actions` and `win.input.keys` are deep-merged with snacks defaults,
          # so `__raw` here only adds our two actions/keys on top of the built-ins.
          actions.__raw =
            #lua
            ''
              {
                opencode_send = function(picker)
                  local items = vim.tbl_map(function(item)
                    return item.file
                        and require("opencode").format({ path = item.file, from = item.pos, to = item.end_pos })
                        or item.text
                  end, picker:selected({ fallback = true }))
                  require("opencode").prompt(table.concat(items, ", ") .. " ")
                end,
                sidekick_send = function(picker)
                  require("sidekick.cli.picker.snacks").send(picker)
                end,
              }
            '';
          win.input.keys.__raw =
            #lua
            ''
              {
                ["<a-o>"] = { "opencode_send", mode = { "n", "i" } },
                ["<a-a>"] = { "sidekick_send", mode = { "n", "i" } },
              }
            '';
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

    # opencode.nvim — integrates the OpenCode AI CLI. The nixvim module only
    # sets `vim.g.opencode_opts = cfg.settings` (it does NOT call setup()).
    # `auto_reload` is not a real option — opencode.nvim auto-sets `vim.o.autoread`
    # and reloads edited buffers via its `events.reload` default, so we rely on
    # the defaults. The `server.start` function (snacks.terminal-backed) cannot
    # round-trip through `vim.g` (Neovim can't store functions in `vim.g`), so
    # it is injected in `extraConfigLua` below via `require("opencode.config").opts`.
    opencode = {
      enable = true;
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
    # ── Agent backend runtime keymap swapper ─────────────────────────────
    # Both sidekick and herd bind their keys under `<leader><tab>*`. Which
    # backend is active is stored in `vim.g.agents_backend` and toggled via
    # the `<leader>S` dashboard (lua/config_dashboard.lua). This module
    # unmaps the previous backend's `<leader><tab>*` keys and maps the new
    # one's at runtime. Setup is invoked from extra-plugins.nix on VimEnter
    # (after sidekick/herd have lazy-loaded).
    "lua/agent_backend.lua".text =
      #lua
      ''
        local M = {}

        M.backends = {
          sidekick = {
            map = function()
              local cli = require("sidekick.cli")
              local opts = function(desc) return { desc = desc, silent = true } end
              vim.keymap.set("n", "<leader><tab>t", function() cli.toggle() end, opts("Sidekick: toggle"))
              vim.keymap.set("n", "<leader><tab>s", function() cli.select({ filter = { installed = true } }) end, opts("Sidekick: select"))
              vim.keymap.set("n", "<leader><tab>f", function() cli.focus() end, opts("Sidekick: focus"))
              vim.keymap.set({ "n", "x" }, "<leader><tab>p", function() cli.prompt() end, opts("Sidekick: pick prompt"))
              vim.keymap.set({ "n", "x" }, "<leader><tab>x", function() cli.send({ msg = "{this}" }) end, opts("Sidekick: send this"))
              vim.keymap.set("n", "<leader><tab>e", function() cli.send({ msg = "{file}" }) end, opts("Sidekick: send file"))
              vim.keymap.set("n", "<leader><tab>d", function() cli.close() end, opts("Sidekick: detach"))
            end,
            unmap = function()
              for _, k in ipairs({ "t", "s", "f", "p", "x", "e", "d" }) do
                pcall(vim.keymap.del, "n", "<leader><tab>" .. k)
                pcall(vim.keymap.del, "x", "<leader><tab>" .. k)
              end
            end,
          },
          herd = {
            map = function()
              local herd = require("herd")
              local opts = function(desc) return { desc = desc, silent = true } end
              vim.keymap.set("n", "<leader><tab>t", function() herd.toggle() end, opts("Herd: toggle"))
              vim.keymap.set("n", "<leader><tab>s", function() herd.select() end, opts("Herd: select"))
              vim.keymap.set("n", "<leader><tab>S", function() herd.dashboard() end, opts("Herd: dashboard"))
              vim.keymap.set("x", "<leader><tab>", function() herd.send() end, opts("Herd: send selection"))
              -- herd-only extras (no default keymaps in herd.nvim): push the
              -- current buffer's LSP diagnostics to the active agent, and jump
              -- to path:line references the agent emitted in its recent output.
              vim.keymap.set("n", "<leader><tab>D", function() herd.diagnostics() end, opts("Herd: send diagnostics"))
              vim.keymap.set("n", "<leader><tab>j", function() herd.jump() end, opts("Herd: jump to references"))
            end,
            unmap = function()
              for _, k in ipairs({ "t", "s", "S", "D", "j" }) do
                pcall(vim.keymap.del, "n", "<leader><tab>" .. k)
              end
              pcall(vim.keymap.del, "x", "<leader><tab>")
            end,
          },
        }

        function M.get()
          return vim.g.agents_backend
        end

        function M.set(name)
          if not M.backends[name] then return end
          local prev = M.get()
          if prev and M.backends[prev] then M.backends[prev].unmap() end
          vim.g.agents_backend = name
          M.backends[name].map()
        end

        function M.setup()
          -- Auto-detect the default backend:
          --   * When Neovim runs INSIDE a herdr session, herdr owns the pane
          --     lifecycle — herd.nvim's float mode would fight it, so default
          --     to sidekick (which uses its own terminal, independent of herdr).
          --   * Otherwise (standalone nvim), default to herd so the user gets
          --     the herdr-backed dashboard/status hooks.
          -- Detection: herdr sets HERDR_TAB_ID / HERDR_WORKSPACE_ID on any pane
          -- it spawns (documented in MomePP/herd.nvim "Native mode"). Either
          -- being set means we're inside herdr.
          local inside_herdr = vim.env.HERDR_TAB_ID ~= nil or vim.env.HERDR_WORKSPACE_ID ~= nil
          local default = inside_herdr and "sidekick" or "herd"
          M.set(vim.g.agents_backend or default)
        end

        return M
      '';

    # ── Agent backend toggle dashboard (<leader>C) ────────────────────────
    # A small nui.menu TUI. Currently exposes one group — `agents-backend` —
    # with a sidekick/herd submenu. Selecting a backend calls
    # `require("agent_backend").set(...)` which swaps the `<leader><tab>*`
    # keymaps at runtime.
    "lua/config_dashboard.lua".text =
      #lua
      ''
        local M = {}

        local function open_submenu()
          local Menu = require("nui.menu")
          local agent_backend = require("agent_backend")
          local current = agent_backend.get()
          local lines = {
            Menu.item("sidekick" .. (current == "sidekick" and "  (active)" or ""), { name = "sidekick" }),
            Menu.item("herd" .. (current == "herd" and "  (active)" or ""), { name = "herd" }),
          }
          local menu = Menu({
            position = "50%",
            size = { width = 40 },
            border = { style = "rounded", text = { top = " agents backend " } },
          }, {
            lines = lines,
            on_submit = function(item) agent_backend.set(item.name) end,
          })
          menu:mount()
        end

        function M.open()
          local Menu = require("nui.menu")
          local menu = Menu({
            position = "50%",
            size = { width = 40 },
            border = { style = "rounded", text = { top = " config " } },
          }, {
            lines = { Menu.item("agents-backend", { name = "agents-backend" }) },
            on_submit = function(item)
              if item.name == "agents-backend" then open_submenu() end
            end,
          })
          menu:mount()
        end

        return M
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

      -- opencode.nvim: inject a snacks.terminal-backed `server.start`.
      -- The nixvim module only sets `vim.g.opencode_opts` (no setup() call),
      -- and Lua functions cannot round-trip through `vim.g` (Neovim can't
      -- store functions in `vim.g`), so we set it directly on the resolved
      -- opts table. opencode.nvim discovers running `opencode --port` servers
      -- by process; `--port` (no value) exposes the server on a random port.
      do
        local ok, cfg = pcall(require, "opencode.config")
        if ok and cfg.opts and cfg.opts.server then
          local opencode_cmd = "opencode --port"
          cfg.opts.server.start = function()
            require("snacks.terminal").open(opencode_cmd, {
              win = { position = "right", enter = false },
            })
          end
        end
      end

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
