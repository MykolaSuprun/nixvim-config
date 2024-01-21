{

  globals = {
    # set up leader key
    mapleader = " ";
  };

  keymaps = [
    # nvim-tree
    {
      mode = "n";
      key = "<leader>e";
      options = {
        silent = true;
        unique = true;
      };
      action = "<cmd>NvimTreeToggle<cr>";
    }
    # Bufferline
    {
      mode = "n";
      key = "<S-h>";
      options = {
        silent = true;
        unique = true;
      };
      action = "<cmd>BufferLineCyclePrev<cr>";
    }
    {
      mode = "n";
      key = "<S-l>";
      options = {
        silent = true;
        unique = true;
      };
      action = "<cmd>BufferLineCycleNext<cr>";
    }
    {
      mode = "n";
      key = "<C-h>";
      options = {
        silent = true;
        remap = true;
      };
      action = "<cmd>BufferLineMovePrev<cr>";
    }
    {
      mode = "n";
      key = "<C-l>";
      options = {
        silent = true;
        remap = true;
      };
      action = "<cmd>BufferLineMoveNext<cr>";
    }
  ];
}
