{
  globals = {
    # set up leader key
    mapleader = " ";
  };

  keymaps = [
    # Toggle NvimTree
    {
      mode = "n";
      key = "<leader>E";
      options = {
        silent = true;
        unique = true;
      };
      action = "<cmd>NvimTreeToggle<cr>";
    }
    {
      mode = "n";
      key = "<leader>e";
      options = {
        silent = true;
        unique = true;
      };
      action = ''
        function()
          require("oil").toggle_float(require("oil").get_current_dir())
        end
      '';
      lua = true;
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
