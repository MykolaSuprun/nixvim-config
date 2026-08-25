# Plugins that are NOT available as nixvim by-name modules at the pinned rev
# (see flake.lock -> nodes.nixvim.locked.rev). Built from source via buildVimPlugin,
# or pulled from nixpkgs vimPlugins when present.
{
  pkgs,
  lib,
  ...
}: {
  extraPlugins = [
    # betterTerm.nvim — tabbed persistent terminals with send-to-terminal API.
    # Repo:  CRAG666/betterTerm.nvim
    # Rev:   8111818c82a5ed01a24317f32892ad67765375b2 (2026-05-31)
    # API:   require("betterTerm").open/send/select/rename/cycle/toggle_termwindow
    # Used for: interactive dbt / `snow sql` / airflow shells (send current line,
    #          selection or file to a persistent, numbered terminal).
    (pkgs.vimUtils.buildVimPlugin {
      pname = "betterTerm";
      version = "unstable-2026-05-31";
      src = pkgs.fetchFromGitHub {
        owner = "CRAG666";
        repo = "betterTerm.nvim";
        rev = "8111818c82a5ed01a24317f32892ad67765375b2";
        hash = "sha256-N9HxE0S8a952p+H9qm2crwxrPPC79BOYHZpaiGJfucU=";
      };
      meta.homepage = "https://github.com/CRAG666/betterTerm.nvim";
      meta.license = lib.licenses.mit;
    })

    # herd.nvim — drives herdr coding agents from Neovim (nvim is the host,
    # herdr is the backend daemon). Built from source (not in nixpkgs).
    # Repo:  MomePP/herd.nvim
    # Rev:   aabb981b6198bafa4603d2db3e26b206352f6379 (2026-08-17, post-herdr-
    #        0.7.5-migration). Requires herdr ≥ 0.7.5 on PATH — main
    #        nixpkgs-unstable ships 0.8.2 (see dependencies.nix).
    # API:   require("herd").{toggle,select,send,dashboard,diagnostics,jump,spawn}
    # Used for: the "herd" agent backend under <leader><tab> (toggled via the
    #          <leader>ca dashboard — see lua/agent_backend.lua). Default keys
    #          are disabled here so they don't shadow <leader>s (search group);
    #          the agent_backend module rebinds them under <leader><tab>* at
    #          runtime.
    (pkgs.vimUtils.buildVimPlugin {
      pname = "herd";
      version = "unstable-2026-08-17";
      src = pkgs.fetchFromGitHub {
        owner = "MomePP";
        repo = "herd.nvim";
        rev = "aabb981b6198bafa4603d2db3e26b206352f6379";
        hash = "sha256-mDr2HvjMWaRj52oh1L+xmV+O3YOk9+gU0ZMV55sTxbc=";
      };
      meta.homepage = "https://github.com/MomePP/herd.nvim";
      meta.license = lib.licenses.mit;
    })

    # opencode.nvim — integrates the OpenCode AI CLI. Pinned from source: the
    # nixpkgs vimPlugins snapshot tracks nickjvandyke/opencode.nvim (the fork
    # that keeps the legacy vim.g.opencode_opts /
    # require("opencode").{ask,select,operator,statusline} API) — that API was
    # NOT removed upstream. We deliberately pin sudo-tee's main instead for the
    # unified `:Opencode` command API (require("opencode.api").<action>) and its
    # richer features (quick chat, diff view, snapshots, MCP picker, skills).
    # Repo: sudo-tee/opencode.nvim, rev cdf00c5f4ac8 (2026-07-27).
    # Bump deliberately: the <leader>o keymaps in keymaps.nix call
    # require("opencode.api").<action>. Loaded via plugins.lz-n.plugins
    # (plugins.nix) on VimEnter; the plugin auto-spawns `opencode serve`.
    (pkgs.vimUtils.buildVimPlugin {
      pname = "opencode-nvim";
      version = "unstable-2026-07-27";
      src = pkgs.fetchFromGitHub {
        owner = "sudo-tee";
        repo = "opencode.nvim";
        rev = "cdf00c5f4ac8161d3ec66bfcb8af140b30b42c6a";
        hash = "sha256-2RWyh9ep+VGqjIAax+TvnF57JhzDqHgzNRBXLxkoi6M=";
      };
      meta.homepage = "https://github.com/sudo-tee/opencode.nvim";
      meta.license = lib.licenses.mit;
    })

    # agentic.nvim — ACP (Agent Client Protocol) chat interface. Works with any
    # ACP provider; we use the built-in `opencode-acp` provider, which spawns
    # `opencode acp` — the opencode CLI (already in extraPackages) speaks ACP
    # natively, so no extra npm/pnpm packages are needed. Sessions are
    # interchangeable between Neovim and the terminal.
    # Repo:  carlos-algms/agentic.nvim
    # Rev:   9945381350664ab3057d480e5cee02a328ef21d5 (2026-08-09)
    # API:   require("agentic").{setup,toggle,new_session,restore_session,
    #         add_selection_or_file_to_context,add_current_line_diagnostics,
    #         add_buffer_diagnostics,switch_provider,switch_model,...}
    # Loaded via plugins.lz-n.plugins (plugins.nix) on VimEnter; keymaps live in
    # keymaps.nix under the <leader>a group.
    (pkgs.vimUtils.buildVimPlugin {
      pname = "agentic-nvim";
      version = "unstable-2026-08-09";
      src = pkgs.fetchFromGitHub {
        owner = "carlos-algms";
        repo = "agentic.nvim";
        rev = "9945381350664ab3057d480e5cee02a328ef21d5";
        hash = "sha256-Sjon3QVcasCW4kYHGgwFeRN1eFhKBBURMm/hNqculuI=";
      };
      meta.homepage = "https://github.com/carlos-algms/agentic.nvim";
      meta.license = lib.licenses.mit;
    })

    # vim-windowswap — effortless window swapping. Disable its default
    # <C-w><C-w> trigger prefix and bind <leader>W instead (keymaps.nix).
    pkgs.vimPlugins.vim-windowswap

    # nvim-window-picker — pick a window by letter hint. Configured with
    # statusline/winbar hints; bound to <leader>Wp (keymaps.nix).
    pkgs.vimPlugins.nvim-window-picker
  ];

  extraConfigLua =
    #lua
    ''
      require("betterTerm").setup({
        prefix = "Term",
        position = "bot",
        size = math.floor(vim.o.lines / 3),
        startInserted = true,
        show_tabs = true,
        index_base = 1,
      })

      -- vim-windowswap: disable the default <leader>ww / <leader>yw / <leader>pw
      -- mappings so they don't clash with our <leader>w (harpoon) group.
      -- <leader>W (keymaps.nix) calls WindowSwap#EasyWindowSwap() directly.
      vim.g.windowswap_map_keys = 0

      -- nvim-window-picker: big floating-letter hints so each window gets a
      -- large, easy-to-read code. `floating-big-letter` renders centered
      -- letters over windows instead of statusline/winbar hints.
      require("window-picker").setup({
        hint = "floating-big-letter",
        show_prompt = false,
        filter_rules = {
          autoselect_one = true,
          include_current_win = false,
          bo = {
            filetype = { "NvimTree", "neo-tree", "notify", "snacks_notif" },
            -- Explicitly clear buftype filter (default includes "terminal").
            -- Without this, the default's buftype filter persists through
            -- tbl_deep_extend since it's not in our override.
            buftype = {},
          },
        },
      })

      -- herd.nvim: spawnable agents + disable ALL default keys (they conflict
      -- with <leader>s). The opencode tool uses `--port` so
      -- opencode.nvim can auto-discover the server, and `--continue` to resume
      -- the last session. OPENCODE_EXPERIMENTAL_LSP_TOOL enables the in-process
      -- LSP used by opencode.nvim's ask completions.
      require("herd").setup({
        tools = {
          opencode = {
            cmd = { "opencode", "--port", "--continue" },
            env = { OPENCODE_EXPERIMENTAL_LSP_TOOL = "true" },
          },
        },
        keys = {
          toggle = false,
          send = false,
          hide = false,
          select = false,
          dashboard = false,
          newline = false,
        },
      })

      -- Agent backend: install the default backend's <leader><tab>* keymaps
      -- after sidekick/herd have had a chance to lazy-load on VimEnter.
      vim.api.nvim_create_autocmd("VimEnter", {
        once = true,
        callback = function() require("agent_backend").setup() end,
      })
    '';
}
