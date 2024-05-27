{
  globals = {
    # set up leader key
    mapleader = " ";
  };

  keymaps = [
    # Toggle NvimTree
    {
      mode = "n";
      key = "<leader>e";
      options = {
        silent = true;
        unique = true;
      };
      action = "<cmd>NvimTreeToggle<cr>";
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
    {
      mode = "n";
      key = "gl";
      options = {
        silent = true;
        unique = true;
      };
      action = ''
        function()
          vim.diagnostic.open_float(0, {scope="line"})
        end
      '';
      lua = true;
    }
  ];
}
