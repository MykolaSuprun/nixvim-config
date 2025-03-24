{
  plugins.which-key = {
    enable = true;
    # registrations = {
    #   "<C-e>" = "Harpoon list pinned";
    #   "C-u" = "Harpoon select 1";
    #   "C-i" = "Harpoon select 2";
    #   "C-o" = "Harpoon select 3";
    #   "C-p" = "Harpoon select 4";
    #   "C-S-j" = "Harpoon next";
    #   "C-S-k" = "Harpoon prev";
    # };
    settings = {
      spec = [
        {
          __unkeyed-1 = "<leader>t";
          desc = "Telescope...";
        }
        {
          __unkeyed-1 = "<leader>th";
          desc = "Telescope help";
        }
        {
          __unkeyed-1 = "<leader>td";
          desc = "LSP buffer's diagnostics";
        }
        {
          __unkeyed-1 = "<leader>tD";
          desc = "LSP project's diagnostics";
        }
        {
          __unkeyed-1 = "<leader>l";
          desc = "LSP...";
        }
        {
          __unkeyed-1 = "<leader>lI";
          desc = "LSP info";
        }
        {
          __unkeyed-1 = "<leader>s";
          desc = "Select/search...";
        }
        {
          __unkeyed-1 = "<leader>ss";
          desc = "Treesitter init";
        }
        {
          __unkeyed-1 = "<leader>si";
          desc = "Treesitter icremental";
        }
        {
          __unkeyed-1 = "<leader>sd";
          desc = "Treesitter decremental";
        }
        {
          __unkeyed-1 = "<leader>sc";
          desc = "Treesitter scope incremental";
        }
        {
          __unkeyed-1 = "<leader>a";
          desc = "Harpoon add";
        }
        {
          __unkeyed-1 = "<leader>f";
          desc = "Find file";
        }
        {
          __unkeyed-1 = "<leader><space>";
          desc = "Opened buffers";
        }
        {
          __unkeyed-1 = "<leader>F";
          desc = "Grep (Root Dir)";
        }
        {
          __unkeyed-1 = "<leader>E";
          desc = "Toggle NvimTree";
        }
        {
          __unkeyed-1 = "<leader>e";
          desc = "Toggle Oil";
        }
        {
          __unkeyed-1 = "<leader>/";
          desc = "Grep buffer";
        }
        {
          __unkeyed-1 = "gl";
          desc = "Go to lint";
        }
      ];
    };
  };
}
