# Shared editing plugins — imported by both nixvim-config and codevim-config.
# These are pure editing primitives with no UI, terminal, or LSP dependencies,
# so they work identically in both full Neovim and VSCode embedded mode.
{...}: {
  plugins = {
    lz-n.enable = true;

    treesitter = {
      enable = true;
      nixvimInjections = true;
      settings = {
        indent.enable = true;
        highlight.enable = true;
        incremental_selection = {
          enable = true;
        };
      };
      lazyLoad.settings.event = ["BufEnter"];
    };

    treesitter-textobjects.enable = true;

    nvim-autopairs = {
      enable = true;
      lazyLoad.settings.event = ["BufEnter"];
      settings.check_ts = true;
    };

    mini-align.enable = true;

    ts-comments.enable = true;

    flash = {
      enable = true;
      settings = {
        label.rainbow.enable = true;
        modes.char.enabled = true;
      };
    };

    nvim-surround = {
      enable = true;
      lazyLoad.settings.event = ["BufEnter"];
    };

    illuminate = {
      enable = true;
      settings = {
        delay = 200;
        min_count_to_highlight = 2;
        providers = [
          "lsp"
          "treesitter"
          "regex"
        ];
      };
    };

    todo-comments = {
      enable = true;
      lazyLoad.settings.event = ["BufEnter"];
    };
  };
}
