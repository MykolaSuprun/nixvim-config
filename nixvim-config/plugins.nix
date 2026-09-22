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
      # Command-gated: <leader>gv runs :DiffviewOpen (keymaps.nix)
      lazyLoad.settings.cmd = [
        "DiffviewOpen"
        "DiffviewFileHistory"
      ];
    };

    lazygit = {
      enable = true;
      settings = {
        floating_window_scaling_factor = 1;
        floating_window_use_plenary = 1;
      };
      # Command-gated: <leader>gg runs :LazyGit (keymaps.nix)
      lazyLoad.settings.cmd = "LazyGit";
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

    # sidekick.nvim — AI CLI terminal (opencode / claude / codex / …).
    # NES (Next Edit Suggestions) is intentionally disabled — it requires the
    # Copilot language server, which we deliberately leave off. sidekick is used
    # purely as a managed terminal for external AI coding CLIs with shared prompt
    # context (file / selection / diagnostics). See keymaps.nix <leader><tab>.
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
        # dim/zen toggles (<leader>uD / <leader>uz in keymaps.nix)
        dim.enabled = true;
        zen.enabled = true;
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
          #   <a-o> → opencode.nvim (require("opencode.api").quick_chat)
          #   <a-a> → sidekick.nvim (require("sidekick.cli.picker.snacks").send)
          # `actions` and `win.input.keys` are deep-merged with snacks defaults,
          # so `__raw` here only adds our two actions/keys on top of the built-ins.
          actions.__raw =
            #lua
            ''
              {
                opencode_send = function(picker)
                  local items = vim.tbl_map(function(item)
                    return item.file or item.text
                  end, picker:selected({ fallback = true }))
                  require("opencode.api").quick_chat(table.concat(items, " ") .. " ")
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
    # render-markdown — markdown rendering (LazyVim's markdown-extra set).
    # Configured via the nixvim module (was a raw extraPlugins entry).
    render-markdown = {
      enable = true;
      settings = {
        code = {
          sign = false;
          width = "block";
          right_pad = 1;
        };
        heading = {
          sign = false;
          # `icons = {}` is a no-op: vim.tbl_deep_extend drops empty tables, so
          # the plugin's default heading icons survive. A one-element list with
          # an empty string is the smallest value that actually clears them.
          icons = [""];
        };
        checkbox.enabled = true;
        # LSP-backed completions for `[ ]` / `[!NOTE]` etc.
        completions.lsp.enabled = true;
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
          # clang-format binary comes from clang-tools (dependencies.nix);
          # style comes from .clang-format in the project or --fallback-style=llvm.
          c = ["clang-format"];
          cpp = ["clang-format"];
          python = ["ruff_format" "ruff_organize_imports"];
          nix = ["alejandra"];
          bash = [
            "shellcheck"
            "shellharden"
            "shfmt"
          ];
          css = ["css_beautify"];
          json = ["jq"];
          yaml = ["yamlfmt"];
          sql = ["sqruff"];
          # Fenced code blocks are formatted by their own language formatter
          # (treesitter `injected`), not by a markdown formatter — pairs with
          # otter (LSP/intellisense) without overlap. M14.
          # prettier → markdownlint-cli2 → markdown-toc → injected (M13).
          markdown = ["prettier" "markdownlint-cli2" "markdown-toc" "injected"];
          "_" = ["trim_whitespace"];
        };
        formatters = {
          injected = {options = {ignore_errors = true;};};
          # markdown-toc only runs when the buffer carries a TOC marker —
          # without one it would insert a generated TOC on every save.
          markdown-toc = {
            condition.__raw = ''
              function(self, ctx)
                return vim.fn.search("<!-- toc -->", "nw") > 0
              end
            '';
          };
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
          ];
        }
      ];
    };

    # opencode.nvim — integrates the OpenCode AI CLI (new unified `:Opencode`
    # command API). Pinned from source (see `opencodeNvim` in extra-plugins.nix)
    # — nixpkgs' vimPlugins.opencode-nvim tracks nickjvandyke's fork (legacy
    # vim.g.opencode_opts API), which we deliberately don't use.
    # Registered via plugins.lz-n.plugins (the plugin manager at this nixvim
    # rev) so lz.n packadds it and runs `require("opencode").setup(opts)` on
    # VimEnter. The plugin auto-spawns its own `opencode serve` server — no
    # snacks.terminal server.start hack needed. Editor keymaps live in
    # keymaps.nix (<leader>o group); the plugin's default_global_keymaps are
    # disabled to avoid clashing with them.
    lz-n = {
      plugins = [
        {
          __unkeyed-1 = "opencode-nvim";
          event = ["VimEnter"];
          after = ''
            function()
              -- Only non-default options are set here; everything else uses
              -- opencode.nvim's own defaults (mode "build", context
              -- file/selection/diagnostics all enabled).
              require("opencode").setup({
                -- default_global_keymaps=false: our <leader>o* binds replace them
                default_global_keymaps = false,
                preferred_picker = "snacks",
                keymap = {
                  input_window = {
                    -- `~` opens the plugin's file picker on a plain character
                    -- (e.g. typing a path) — disabled. File mentions still work
                    -- via `@` + the blink completion menu.
                    ["~"] = false,
                    -- <C-p> command palette (model/provider, session, agent,
                    -- variant, timeline). Buffer-local, so it only shadows
                    -- blink's <C-p> inside the opencode input window.
                    ["<C-p>"] = {
                      function() require("opencode_palette").open() end,
                      mode = { "n", "i" },
                      desc = "Opencode: command palette",
                    },
                  },
                },
                hooks = {
                  on_done_thinking = function()
                    vim.schedule(function()
                      vim.notify("opencode: done", vim.log.levels.INFO, { title = "opencode" })
                    end)
                  end,
                },
              })
            end
          '';
        }
        {
          __unkeyed-1 = "agentic-nvim";
          event = ["VimEnter"];
          after = ''
            function()
              require("agentic").setup({
                provider = "opencode-acp",
              })
            end
          '';
        }
      ];
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
      # Command-gated: <leader>uN runs :NoNeckPain (keymaps.nix)
      lazyLoad.settings.cmd = "NoNeckPain";
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
      # NOTE: the gtest adapter is declared as raw Lua below instead of the
      # `adapters.gtest` submodule — nixvim wraps submodule `settings` in a
      # direct call (`require("neotest-gtest")({...})`), but neotest-gtest
      # only exposes `.setup()` (not callable), which would crash neotest on
      # lazy-load. Its package is added via top-level extraPlugins because
      # nixvim cannot see the dependency inside a __raw string.
      # debug_adapter matches the codelldb adapter defined in dap.nix.
      settings = {
        adapters = [
          {
            __raw = "require('neotest-gtest').setup({ debug_adapter = 'codelldb' })";
          }
        ];
      };
      adapters.python = {
        enable = true;
        settings = {
          runner = "pytest";
        };
      };
    };

    # ── clangd extensions (AST, memory usage, symbol info) ───────────────
    # Off-spec clangd features: :ClangdAST, :ClangdMemoryUsage,
    # :ClangdSymbolInfo, :ClangdTypeHierarchy. Source/header switching is
    # bound to <leader>ch in keymaps.nix.
    clangd-extensions = {
      enable = true;
      # clangd defaults to utf-16 offset encoding while blink-cmp negotiates
      # utf-8 — without this workaround completion positions drift in C/C++.
      enableOffsetEncodingWorkaround = true;
      lazyLoad.settings.event = ["BufEnter"];
    };

    # ── CMake workflow ────────────────────────────────────────────────────
    # cmake-tools drives configure/build/run/ctest; tasks execute through
    # overseer (same pane as every other build in this config). It also sets
    # compile_commands.json location for clangd automatically.
    cmake-tools = {
      enable = true;
      lazyLoad.settings.cmd = [
        "CMakeBuild"
        "CMakeRun"
        "CMakeSelectBuildDir"
        "CMakeSelectBuildPreset"
      ];
      settings = {
        cmake_executor = {
          name = "overseer";
          # No strategy override: overseer v2 removed the toggleterm strategy
          # (CHANGELOG: "remove toggleterm and terminal strategies"); the
          # default jobstart strategy runs the task in a terminal buffer.
        };
        cmake_notifications.enabled = false;
        cmake_dap_configuration = {
          name = "cpp";
          type = "codelldb";
          request = "launch";
          stopOnEntry = false;
          runInTerminal = true;
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
    # the `<leader>C` dashboard (lua/config_dashboard.lua). This module
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

    # ── OrbStack host-tool resolution ────────────────────────────────────
    # When Neovim runs inside an OrbStack Linux machine, `snow` / `sqlit`
    # (and anything else needing a real browser or OS keyring) are better
    # executed on the macOS HOST via OrbStack's `mac` command shim:
    #   * externalbrowser OAuth opens the Mac browser (SSO session lives
    #     there) and caches the token in the macOS Keychain;
    #   * stdio is proxied, so output/exit codes behave like a local process.
    # Resolution per tool: host binary (OrbStack + host has it) → nix-packaged
    # binary on PATH. Host probing is lazy and cached. Escape hatch:
    # `let g:host_tools_prefer_local = 1` forces the local binaries.
    "lua/host_tool.lua".text =
      #lua
      ''
        local M = {}

        local orbstack = nil

        -- OrbStack machines always ship the `mac` guest shim on PATH; the
        -- kernel release string ("-orbstack-") is the fallback signal.
        function M.is_orbstack()
          if orbstack == nil then
            local release = (vim.uv or vim.loop).os_uname().release or ""
            orbstack = vim.fn.executable("mac") == 1 or release:find("orbstack") ~= nil
          end
          return orbstack
        end

        local host_probe = {}

        -- Probed via a login shell so Homebrew (/opt/homebrew/bin) and pipx
        -- (~/.local/bin) installs are visible.
        function M.host_executable(name)
          if vim.g.host_tools_prefer_local or not M.is_orbstack() then
            return false
          end
          if host_probe[name] == nil then
            vim.fn.system({ "mac", "sh", "-lc", "command -v " .. name .. " >/dev/null 2>&1" })
            host_probe[name] = vim.v.shell_error == 0
          end
          return host_probe[name]
        end

        --- { prefix = argv head, host = bool } for running `name`.
        function M.runner(name)
          if M.host_executable(name) then
            return { prefix = { "mac", name }, host = true }
          end
          return { prefix = { name }, host = false }
        end

        --- Full argv for running `name` with `args`, host-preferred.
        function M.cmd(name, args)
          local argv = vim.deepcopy(M.runner(name).prefix)
          return vim.list_extend(argv, args or {})
        end

        --- Write SQL text to a temp file, returning the path to pass to the
        --- tool. Host-run tools can't see the VM filesystem, so the file goes
        --- through the OrbStack mount (/mnt/mac) and the returned path is the
        --- host-visible equivalent. Files land in tmp on both sides and are
        --- left for the OS to clean (boot-time cleanup on macOS and NixOS).
        function M.write_query_tmp(for_host, content)
          local name = ("nvim-query-%d-%d.sql"):format(
            vim.fn.getpid(),
            (vim.uv or vim.loop).hrtime() % 1000000000
          )
          if for_host then
            local vm_path = "/mnt/mac/tmp/" .. name
            vim.fn.writefile(vim.split(content, "\n", { plain = true }), vm_path)
            return "/tmp/" .. name
          end
          local path = vim.fn.tempname() .. ".sql"
          vim.fn.writefile(vim.split(content, "\n", { plain = true }), path)
          return path
        end

        --- One-time startup setup (cheap: fs/executable checks only, no host
        --- probing). Shares config dirs with the host so host-run and VM-run
        --- tools see one set of connections, and gives in-VM externalbrowser
        --- OAuth a way to open the Mac browser as a fallback: OrbStack links
        --- `open` into machines by default, and machine-bound ports are
        --- reachable from the Mac at localhost:<port> (docs.orbstack.dev/
        --- machines/network), so the OAuth loopback redirect can complete.
        function M.setup()
          if not M.is_orbstack() then
            return
          end
          local mac_home = "/Users/" .. (vim.env.USER or "")
          -- snow CLI + snowflake-connector-python both honour SNOWFLAKE_HOME;
          -- the Mac fs is mounted at the same /Users/... path inside the VM.
          if not vim.env.SNOWFLAKE_HOME and vim.fn.isdirectory(mac_home .. "/.snowflake") == 1 then
            vim.env.SNOWFLAKE_HOME = mac_home .. "/.snowflake"
          end
          -- Same for sqlit ($XDG_CONFIG_HOME/sqlit, overridable). Password
          -- auth entries won't unlock (OS keyrings differ), but
          -- externalbrowser connections store no password and share cleanly.
          if not vim.env.SQLIT_CONFIG_DIR and vim.fn.isdirectory(mac_home .. "/.config/sqlit") == 1 then
            vim.env.SQLIT_CONFIG_DIR = mac_home .. "/.config/sqlit"
          end
          if not vim.env.BROWSER and vim.fn.executable("open") == 1 then
            vim.env.BROWSER = "open"
          end
        end

        return M
      '';

    # ── Resize-safe query result viewer ──────────────────────────────────
    # `snow sql` / `sqlit query` print static ASCII tables sized to the
    # terminal at render time — unreadable in resizable windows. Both tools
    # emit CSV instead; output is parsed once and re-rendered to fit the
    # current window width on every VimResized/WinResized. JSON would lose
    # column order (vim.json.decode → Lua hash tables), hence CSV.
    "lua/query_result.lua".text =
      #lua
      ''
        local M = {}

        local MAX_SCAN_ROWS = 200 -- rows sampled for width estimation
        local MAX_SHOW_ROWS = 2000 -- rows rendered at most
        local MAX_COL_W = 40
        local MIN_COL_W = 4

        -- RFC-4180-ish CSV: quoted fields, "" escapes, embedded newlines.
        function M.parse_csv(text)
          local rows, row, field = {}, {}, {}
          local i, n = 1, #text
          local in_quotes = false
          local field_started = false

          local function end_field()
            row[#row + 1] = table.concat(field)
            field = {}
            field_started = false
          end
          local function end_row()
            end_field()
            rows[#rows + 1] = row
            row = {}
          end

          while i <= n do
            local c = text:sub(i, i)
            if in_quotes then
              if c == '"' then
                if text:sub(i + 1, i + 1) == '"' then
                  field[#field + 1] = '"'
                  i = i + 2
                else
                  in_quotes = false
                  i = i + 1
                end
              else
                field[#field + 1] = c
                i = i + 1
              end
            elseif c == '"' and not field_started then
              in_quotes = true
              field_started = true
              i = i + 1
            elseif c == "," then
              end_field()
              i = i + 1
            elseif c == "\n" then
              end_row()
              i = i + 1
            elseif c == "\r" then
              i = i + 1 -- tolerate CRLF
            else
              field[#field + 1] = c
              field_started = true
              i = i + 1
            end
          end

          if in_quotes then
            error("malformed CSV: unterminated quoted field")
          end
          if field_started or #row > 0 then
            end_row()
          end
          -- drop trailing blank lines at EOF
          while #rows > 0 and #rows[#rows] == 1 and rows[#rows][1] == "" do
            rows[#rows] = nil
          end
          if #rows == 0 then
            return { columns = {}, rows = {} }
          end
          return { columns = table.remove(rows, 1), rows = rows }
        end

        local function cell_text(v)
          if v == nil then
            return ""
          end
          return (tostring(v):gsub("[%c]", " ")) -- control chars (incl. \n) → space
        end

        -- Column widths from content (capped), then shrink the widest columns
        -- until everything fits the window width.
        local function fit_widths(columns, rows, avail)
          local widths = {}
          for i, c in ipairs(columns) do
            widths[i] = math.min(MAX_COL_W, math.max(MIN_COL_W, #cell_text(c)))
          end
          for r = 1, math.min(#rows, MAX_SCAN_ROWS) do
            for i = 1, #columns do
              local w = #cell_text(rows[r][i])
              if w > widths[i] then
                widths[i] = math.min(MAX_COL_W, w)
              end
            end
          end
          local sep_w = 3 * (#columns - 1)
          local function total()
            local t = 0
            for _, w in ipairs(widths) do
              t = t + w
            end
            return t
          end
          while #columns > 0 and total() + sep_w > avail do
            local widest, wmax = 1, 0
            for i, w in ipairs(widths) do
              if w > wmax then
                wmax, widest = w, i
              end
            end
            if wmax <= MIN_COL_W then
              break
            end
            widths[widest] = wmax - 1
          end
          return widths
        end

        -- Display-width aware pad/truncate (… is multibyte — # lies).
        local function fit_cell(v, width)
          local cell = cell_text(v)
          local dw = vim.fn.strdisplaywidth(cell)
          if dw <= width then
            return cell .. string.rep(" ", width - dw)
          end
          return vim.fn.strcharpart(cell, 0, width - 1) .. "…"
        end

        local function format_row(values, widths)
          local parts = {}
          for i = 1, #widths do
            parts[i] = fit_cell(values[i], widths[i])
          end
          return table.concat(parts, " | ")
        end

        local view = { win = nil, buf = nil, data = nil, note = nil }

        local function render()
          if not (view.win and vim.api.nvim_win_is_valid(view.win)) then
            return
          end
          local widths = fit_widths(view.data.columns, view.data.rows, vim.api.nvim_win_get_width(view.win))
          local lines = { format_row(view.data.columns, widths) }
          local sep = {}
          for i, w in ipairs(widths) do
            sep[i] = string.rep("─", w)
          end
          lines[2] = table.concat(sep, "─┼─")
          local shown = math.min(#view.data.rows, MAX_SHOW_ROWS)
          for r = 1, shown do
            lines[#lines + 1] = format_row(view.data.rows[r], widths)
          end
          if #view.data.rows > shown then
            lines[#lines + 1] = ("… showing %d of %d rows"):format(shown, #view.data.rows)
          end
          if view.note and view.note ~= "" then
            for _, l in ipairs(vim.split(view.note, "\n", { plain = true, trimempty = true })) do
              lines[#lines + 1] = l
            end
          end
          local buf = view.buf
          vim.bo[buf].modifiable = true
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
          vim.bo[buf].modifiable = false
        end

        function M.close()
          if view.win and vim.api.nvim_win_is_valid(view.win) then
            vim.api.nvim_win_close(view.win, true)
          end
        end

        --- data: { columns = {...}, rows = {...} }; opts: { title, note }
        function M.show(data, opts)
          opts = opts or {}
          M.close()
          local buf = vim.api.nvim_create_buf(false, true)
          vim.bo[buf].bufhidden = "wipe"
          local width = math.floor(vim.o.columns * 0.85)
          local height = math.floor(vim.o.lines * 0.8)
          local win = vim.api.nvim_open_win(buf, true, {
            relative = "editor",
            width = width,
            height = height,
            col = math.floor((vim.o.columns - width) / 2),
            row = math.floor((vim.o.lines - height) / 2),
            style = "minimal",
            border = "rounded",
            title = opts.title or " query result ",
            title_pos = "center",
            footer = " q close · y yank row · re-renders on resize ",
            footer_pos = "center",
          })
          vim.wo[win].wrap = false
          vim.wo[win].cursorline = true
          view = { win = win, buf = buf, data = data, note = opts.note }
          render()
          pcall(vim.api.nvim_buf_add_highlight, buf, -1, "Title", 0, 0, -1)

          local group = vim.api.nvim_create_augroup("query_result_view", { clear = true })
          vim.api.nvim_create_autocmd({ "VimResized", "WinResized" }, {
            group = group,
            callback = function()
              if not (view.win and vim.api.nvim_win_is_valid(view.win)) then
                return true
              end
              local w = math.floor(vim.o.columns * 0.85)
              local h = math.floor(vim.o.lines * 0.8)
              vim.api.nvim_win_set_config(view.win, {
                relative = "editor",
                width = w,
                height = h,
                col = math.floor((vim.o.columns - w) / 2),
                row = math.floor((vim.o.lines - h) / 2),
              })
              render()
            end,
          })
          vim.api.nvim_create_autocmd("WinClosed", {
            group = group,
            pattern = tostring(win),
            once = true,
            callback = function()
              view = { win = nil, buf = nil, data = nil, note = nil }
            end,
          })

          vim.keymap.set("n", "q", M.close, { buffer = buf, nowait = true, desc = "close results" })
          vim.keymap.set("n", "<Esc>", M.close, { buffer = buf, nowait = true, desc = "close results" })
          vim.keymap.set("n", "y", function()
            local row_idx = vim.api.nvim_win_get_cursor(0)[1] - 2 -- header + separator
            local row = view.data and view.data.rows[row_idx]
            if not row then
              return
            end
            vim.fn.setreg('"', table.concat(vim.tbl_map(cell_text, row), "\t"))
            vim.notify("row yanked", vim.log.levels.INFO, { title = "query result" })
          end, { buffer = buf, desc = "yank row (TSV)" })
        end

        --- Fallback for non-tabular output (DDL/DML status, error text).
        function M.show_raw(text, title)
          local rows = {}
          for _, l in ipairs(vim.split(text or "", "\n", { plain = true })) do
            rows[#rows + 1] = { l }
          end
          M.show({ columns = { "output" }, rows = rows }, { title = title })
        end

        return M
      '';

    # ── SQL runner (snow CLI + sqlit) ────────────────────────────────────
    # Runs the current line / visual selection / whole buffer and shows
    # results in query_result's float. Tools resolve through host_tool
    # (host-first on OrbStack); every run is confirm-gated like the overseer
    # snowflake templates — editor text can contain DROP/DELETE/TRUNCATE.
    "lua/sql_runner.lua".text =
      #lua
      ''
        local host_tool = require("host_tool")
        local viewer = require("query_result")

        local M = {}

        local SQLIT_ROW_LIMIT = "5000"
        local TUI_PICKER = "(connection picker)"

        local function notify(msg, level)
          vim.notify(msg, level or vim.log.levels.INFO, { title = "sql runner" })
        end

        local function confirm_run(sql)
          local snippet = sql:gsub("%s+", " "):sub(1, 200)
          local choice = vim.fn.confirm(
            "Run this against the database?\n\n" .. snippet .. (#sql > 200 and " …" or ""),
            "&Run\n&Cancel",
            2
          )
          return choice == 1
        end

        local function current_line()
          return vim.api.nvim_get_current_line()
        end

        local function visual_selection()
          local sr, sc = unpack(vim.api.nvim_buf_get_mark(0, "<"))
          local er, ec = unpack(vim.api.nvim_buf_get_mark(0, ">"))
          local lines = vim.api.nvim_buf_get_lines(0, sr - 1, er, false)
          if #lines == 0 then
            return ""
          end
          lines[#lines] = string.sub(lines[#lines], 1, ec + 1)
          lines[1] = string.sub(lines[1], sc + 1)
          return table.concat(lines, "\n")
        end

        local function whole_buffer()
          return table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
        end

        local function run(argv, title)
          notify("running query…")
          vim.system(argv, { text = true }, function(res)
            vim.schedule(function()
              if res.code ~= 0 then
                notify(
                  ("query failed (exit %d)\n%s\n%s"):format(
                    res.code,
                    res.stderr or "",
                    (res.stdout or ""):sub(1, 400)
                  ),
                  vim.log.levels.ERROR
                )
                return
              end
              local out = res.stdout or ""
              local ok, parsed = pcall(viewer.parse_csv, out)
              if not ok or #parsed.columns == 0 then
                viewer.show_raw(out ~= "" and out or (res.stderr or ""), title)
                return
              end
              viewer.show(parsed, { title = title, note = res.stderr })
            end)
          end)
        end

        -- The query always travels as a temp file passed with -f: identical
        -- for local and host-run tools (no stdin assumptions about the `mac`
        -- shim) and immune to shell-quoting issues (exec argv, no shell).
        local function run_with_file(tool, sql, args, title)
          local runner = host_tool.runner(tool)
          local path = host_tool.write_query_tmp(runner.host, sql)
          local argv = vim.deepcopy(runner.prefix)
          for _, a in ipairs(args(path)) do
            argv[#argv + 1] = a
          end
          run(argv, title)
        end

        -- --enable-templating NONE: editor text (esp. dbt Jinja) must reach
        -- the server verbatim — no client-side &/<% variable substitution.
        function M.snow_run(sql)
          if not sql or sql:match("^%s*$") then
            return
          end
          if not confirm_run(sql) then
            return
          end
          run_with_file("snow", sql, function(path)
            return { "sql", "-f", path, "--format", "CSV", "--enable-templating", "NONE" }
          end, "snowflake")
        end

        local function sqlit_config_dir()
          return vim.env.SQLIT_CONFIG_DIR or (vim.fn.expand("~") .. "/.config/sqlit")
        end

        -- Connection names from connections.json; shape parsed defensively
        -- (list of {name=...} or a name→config map, optionally wrapped).
        local function sqlit_connections()
          local path = sqlit_config_dir() .. "/connections.json"
          if vim.fn.filereadable(path) == 0 then
            return {}
          end
          local ok, data = pcall(vim.json.decode, table.concat(vim.fn.readfile(path), "\n"))
          if not ok or type(data) ~= "table" then
            return {}
          end
          local list = data.connections or data
          local names = {}
          if vim.islist(list) then
            for _, c in ipairs(list) do
              if type(c) == "table" and type(c.name) == "string" then
                names[#names + 1] = c.name
              end
            end
          else
            for name in pairs(list) do
              names[#names + 1] = name
            end
          end
          table.sort(names)
          return names
        end

        function M.sqlit_run(sql)
          if not sql or sql:match("^%s*$") then
            return
          end
          local names = sqlit_connections()
          if #names == 0 then
            notify(
              "no sqlit connections in "
                .. sqlit_config_dir()
                .. "/connections.json — add one via the sqlit TUI or `sqlit connections add`",
              vim.log.levels.WARN
            )
            return
          end
          vim.ui.select(names, { prompt = "sqlit connection" }, function(name)
            if not name or not confirm_run(sql) then
              return
            end
            run_with_file("sqlit", sql, function(path)
              return { "query", "-c", name, "-f", path, "--format", "csv", "--limit", SQLIT_ROW_LIMIT }
            end, "sqlit: " .. name)
          end)
        end

        -- The sqlit TUI is a proper Textual app (resize-safe), opened in a
        -- snacks.terminal float. On OrbStack it resolves to the host sqlit
        -- via `mac`; if TUI-through-`mac` ever misbehaves, set
        -- g:host_tools_prefer_local to force the nix-packaged binary.
        function M.sqlit_tui()
          local items = sqlit_connections()
          table.insert(items, 1, TUI_PICKER)
          vim.ui.select(items, { prompt = "sqlit" }, function(choice)
            if not choice then
              return
            end
            local args = {}
            if choice ~= TUI_PICKER then
              args = { "-c", choice }
            end
            Snacks.terminal.open(host_tool.cmd("sqlit", args), {
              win = {
                position = "float",
                width = 0.92,
                height = 0.88,
                border = "rounded",
                title = " sqlit ",
                title_pos = "center",
              },
              interactive = true,
              start_insert = true,
            })
          end)
        end

        function M.snow_line()
          M.snow_run(current_line())
        end
        function M.snow_selection()
          M.snow_run(visual_selection())
        end
        function M.snow_buffer()
          M.snow_run(whole_buffer())
        end
        function M.sqlit_line()
          M.sqlit_run(current_line())
        end
        function M.sqlit_selection()
          M.sqlit_run(visual_selection())
        end
        function M.sqlit_buffer()
          M.sqlit_run(whole_buffer())
        end

        return M
      '';

    # ── opencode command palette (<C-p>) ─────────────────────────────────
    # Buffer-local <C-p> in the opencode input window (wired in the lz-n
    # opencode setup above) opens this menu — the nixvim equivalent of the
    # opencode TUI's <C-p> command palette for the actions that matter here.
    "lua/opencode_palette.lua".text =
      #lua
      ''
        local M = {}

        local function menu()
          local api = require("opencode.api")
          return {
            { label = "Model / provider", run = api.configure_provider },
            { label = "Session", run = api.select_session },
            { label = "Agent / mode", run = api.select_agent },
            { label = "Model variant", run = api.configure_variant },
            { label = "Timeline", run = api.timeline },
          }
        end

        function M.open()
          local items = menu()
          local labels = vim.tbl_map(function(item) return item.label end, items)
          vim.ui.select(labels, { prompt = "Opencode" }, function(choice)
            if not choice then return end
            for _, item in ipairs(items) do
              if item.label == choice then
                item.run()
                return
              end
            end
          end)
        end

        return M
      '';

    # ── overseer shared helpers ──────────────────────────────────────────
    # Single definition of the bottom-split component bundle and the
    # visual-selection slicing, used by overseer/*.lua templates and the
    # betterTerm send keymaps (keymaps.nix). Previously duplicated in
    # dbt/snowflake/airflow_tasks.lua and keymaps.nix (Stage 01 W8/W10).
    "lua/overseer_helpers.lua".text =
      #lua
      ''
        local M = {}

        -- Standard "show output in a bottom split, then dispose" bundle.
        -- dispose_timeout is per-domain (60s for quick reads, up to 1800s for
        -- long builds); 600s matches the dbt default.
        function M.bottom_output(dispose_timeout)
          return {
            { "open_output", direction = "bottom", on_start = "always" },
            { "on_complete_notify", statuses = { "SUCCESS", "FAILURE" } },
            { "unique", replace = true },
            "on_exit_set_status",
            { "on_complete_dispose", timeout = dispose_timeout or 600 },
          }
        end

        -- Text of the last visual selection (end column inclusive), or nil when
        -- there is no selection. Marks are 0-indexed byte offsets; the end
        -- column is inclusive, hence the +1.
        function M.visual_selection()
          local sr, sc = unpack(vim.api.nvim_buf_get_mark(0, "<"))
          local er, ec = unpack(vim.api.nvim_buf_get_mark(0, ">"))
          if sr == 0 or er == 0 then
            return nil
          end
          local lines = vim.api.nvim_buf_get_lines(0, sr - 1, er, false)
          if #lines == 0 then
            return nil
          end
          lines[#lines] = string.sub(lines[#lines], 1, ec + 1)
          lines[1] = string.sub(lines[1], sc + 1)
          return table.concat(lines, "\n")
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
    # neotest-gtest: not a nixvim adapter submodule (see the neotest block)
    # — packaged explicitly so the raw-Lua adapter can require it.
    neotest-gtest
  ];

  extraConfigLua =
    #lua
    ''
      -- require("fyler").setup()

      -- OrbStack host-tool setup (lua/host_tool.lua): share Snowflake/sqlit
      -- config dirs with the macOS host and set BROWSER=open so in-VM
      -- externalbrowser OAuth can open the Mac browser. Cheap no-op elsewhere.
      require("host_tool").setup()

      -- otter: activate embedded-language LSP only for buffers that (a) have an
      -- embedded language we care about, and (b) actually loaded the otter plugin
      -- via our BufReadPost lazy-load. Protected by pcall so a missing module on
      -- a non-matching buffer (e.g. a .py file) never throws on LspAttach.
      -- This replaces nixvim's `autoActivate = true` global hook, which is
      -- incompatible with lazy-loading (it require()'s otter unconditionally).
      local otter_filetypes = {
        ["markdown"] = true,
        ["quarto"] = true,
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
