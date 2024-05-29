{
  keymaps = [
    # window movements
    # window movements are defined with vim-tmux-navigator plugin
    # to work both inside and outside of tmux session
    {
      mode = "n";
      key = "<A-h>";
      options = {
        silent = true;
        remap = true;
      };
      action = "<cmd>TmuxNavigateLeft<cr>";
    }
    {
      mode = "n";
      key = "<A-l>";
      options = {
        silent = true;
        remap = true;
      };
      action = "<cmd>TmuxNavigateRight<cr>";
    }
    {
      mode = "n";
      key = "<A-j>";
      options = {
        silent = true;
        remap = true;
      };
      action = "<cmd>TmuxNavigateDown<cr>";
    }
    {
      mode = "n";
      key = "<A-k>";
      options = {
        silent = true;
        remap = true;
      };
      action = "<cmd>TmuxNavigateUp<cr>";
    }
    {
      mode = "n";
      key = "<leader>wv";
      options = {
        silent = true;
        remap = true;
        desc = "Vertical right split";
      };
      action = "<C-W>v";
    }
    {
      mode = "n";
      key = "<leader>ws";
      options = {
        silent = true;
        remap = true;
        desc = "Horizontal bottom split";
      };
      action = "<C-W>s";
    }
    {
      mode = "n";
      key = "<leader>wc";
      options = {
        silent = true;
        remap = true;
        desc = "Close window";
      };
      action = "<C-W>c";
    }
    {
      mode = "n";
      key = "<leader>wC";
      options = {
        silent = true;
        remap = true;
        desc = "Close other windows";
      };
      action = "<C-W>o";
    }
  ];
}
