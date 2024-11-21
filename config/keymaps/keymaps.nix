{
  globals = {
    # set up leader key
    mapleader = " ";
    maplocalleader = "\\";
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
    # Toggle Oil file manager
    {
      mode = "n";
      key = "<leader>e";
      options = {
        silent = true;
        unique = true;
      };
      action.__raw = ''
        function()
          require("oil").toggle_float(require("oil").get_current_dir())
        end
      '';
    }
    # flash jump
    {
      mode = [ "n" "x" "o" ];
      key = "s";
      options = {
        silent = true;
        # unique = true;
        desc = "Flash jump";
      };
      action.__raw = ''function() require("flash").jump() end'';
    }
    {
      mode = [ "n" "x" "o" ];
      key = "S";
      options = {
        silent = true;
        # unique = true;
        desc = "Flash treesitter";
      };
      action.__raw = ''function() require("flash").treesitter() end'';
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
      options = { silent = true; };
      action = "<gv";
    }
    {
      mode = "v";
      key = ">";
      options = { silent = true; };
      action = ">gv";
    }
    {
      mode = "n";
      key = "gl";
      options = {
        silent = true;
        unique = true;
      };
      action.__raw = ''
        function()
          vim.diagnostic.open_float(0, {scope="line"})
        end
      '';
    }
    # grug-far
    {
      mode = [ "n" "v" ];
      key = "<leader>sr";
      options = {
        silent = true;
        unique = true;
        desc = "search/replace";
      };
      action.__raw = ''
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end
      '';

    }
    # zen-mode 
    {
      mode = "n";
      key = "<leader>m";
      options = {
        silent = true;
        unique = true;
        desc = "Toggle Zen mode";
      };
      action = "<cmd>ZenMode<cr>";
    }
  ];
}
