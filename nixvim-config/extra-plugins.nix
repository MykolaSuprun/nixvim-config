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

    # herdr-nvim — Neovim bridge for herdr (the agent multiplexer). The upstream
    # repo holds TWO halves: a Rust herdr plugin (installed imperatively with
    # `herdr plugin install ChmaraX/herdr-nvim`, which provides the sidebar
    # daemon) and this Lua half. buildVimPlugin's installPhase only copies
    # lua/ + plugin/ + doc/, so the Rust half is ignored automatically — the
    # sidebar comes from the herdr-side install, not from here.
    # Repo:  ChmaraX/herdr-nvim
    # Rev:   d2dd1899dd7b4ee36719e315e97f326b8aada171 (v1.2.1, 2026-10-16)
    # Requires: nvim >= 0.10 (have 0.12.5); herdr >= 0.7.5 on PATH (nixpkgs
    #           ships 0.9.5); annotations need nvim running INSIDE a herdr
    #           session (HERDR_WORKSPACE_ID / HERDR_TAB_ID — provided by
    #           herdr, not by the plugin).
    # API:   require("herdr-nvim").{comment,list,send,submit,ref,statusline}
    # Keymaps: <leader>h* in keymaps.nix.
    (pkgs.vimUtils.buildVimPlugin {
      pname = "herdr-nvim";
      version = "1.2.1";
      src = pkgs.fetchFromGitHub {
        owner = "ChmaraX";
        repo = "herdr-nvim";
        rev = "d2dd1899dd7b4ee36719e315e97f326b8aada171";
        hash = "sha256-EghtchK820sWZmq67qdHhKSWkLnG2CqLza/dmUqNNi0=";
      };
      meta.homepage = "https://github.com/ChmaraX/herdr-nvim";
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

      -- herdr-nvim: the bridge between Neovim and herdr (agent multiplexer).
      -- The plugin's own default keymaps live under `prefix = "<leader>a"`
      -- with `keymaps = true` — that namespace now belongs to codecompanion,
      -- so they are disabled here and the five actions are bound explicitly
      -- in keymaps.nix (<leader>h*) via the plugin's :Herdr user command
      -- (range-aware, so visual selections carry through).
      -- Needs nvim running inside a herdr session (herdr exports
      -- HERDR_WORKSPACE_ID / HERDR_TAB_ID) and the `herdr` binary on PATH.
      require("herdr-nvim").setup({
        prefix = "<leader>h",
        keymaps = false,
      })
    '';
}
