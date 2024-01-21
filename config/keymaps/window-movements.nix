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
  ];
}
