# Shared plugins — imported by both nixvim-config and codevim-config.
# These plugins have identical configuration in both setups.
{...}: {
  plugins = {
    # Git change indicators — works natively in both full Neovim and VSCode embedded mode.
    gitsigns = {
      enable = true;
      lazyLoad.settings.event = ["BufEnter"];
      settings = {
        current_line_blame = false;
        current_line_blame_opts = {
          delay = 100;
          virt_text = true;
          virt_text_pos = "eol";
        };
      };
    };

    # Shows current scope context header above the buffer.
    treesitter-context = {
      enable = true;
      settings = {
        enable = true;
        line_numbers = true;
        max_lines = 3;
        mode = "cursor";
      };
      lazyLoad.settings.event = ["BufEnter"];
    };

    # Structural find & replace — ast-grep and ripgrep backends.
    grug-far = {
      enable = true;
      lazyLoad.settings.event = ["VimEnter"];
    };

    # Per-directory session save/restore.
    persistence.enable = true;

    # Required by several plugins; declared here to avoid duplication.
    web-devicons.enable = true;
  };
}
