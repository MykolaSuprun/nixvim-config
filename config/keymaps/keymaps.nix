{
  globals = {
    # set up leader key
    mapleader = " ";
  };

  keymaps = [
    # Rnvimr file manager
    {
      mode = "n";
      key = "<leader>e";
      options = {
        silent = true;
        unique = true;
      };
      action = "<cmd>RnvimrToggle<cr>";
    }
    {
      mode = "i";
      key = "#";
      options = {
        silent = true;
        unique = true;
      };
      action = "X<BS>#";
    }
    # better indenting
    {
      mode = "v";
      key = "<";
      options = {
        silent = true;
      };
      action = "<gv";
    }
    {
      mode = "v";
      key = ">";
      options = {
        silent = true;
      };
      action = ">gv";
    }
  ];
}
