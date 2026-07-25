# Plugins that are NOT available as nixvim by-name modules at the pinned rev
# (see flake.lock -> nodes.nixvim.locked.rev). Built from source via buildVimPlugin.
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
    # Used for: interactive dbt / Snowflake / airflow shells (send current line,
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
    '';
}