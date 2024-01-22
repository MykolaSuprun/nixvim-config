{
  keymaps = [
    # find file
    {
      key = "<leader>f";
      options = {
        unique = true;
        remap = true;
      };
      action = ''
        function()
          require("telescope.builtin").find_files({ layout_strategy = getLayoutStrategy() })
        end
      '';
      lua = true;
    }
    # live grep
    {
      key = "<leader>F";
      options = {
        unique = true;
        remap = true;
      };
      action = ''
        function()
          require("telescope.builtin").live_grep({ layout_strategy = getLayoutStrategy() })
        end
      '';
      lua = true;
    }
    # find help
    {
      key = "<leader>th";
      options = {
        unique = true;
        remap = true;
      };
      action = ''
        function()
          require("telescope.builtin").help_tags({ layout_strategy = getLayoutStrategy() })
        end
      '';
      lua = true;
    }
    # find in current buffer
    {
      key = "<leader>/";
      options = {
        unique = true;
        remap = true;
      };
      action = ''
        function()
            require("telescope.builtin").current_buffer_fuzzy_find({ layout_strategy = getLayoutStrategy() })
        end
      '';
      lua = true;
    }
    # Telescope buffer diagnostics
    {
      key = "<leader>td";
      options = {
        unique = true;
        remap = true;
      };
      action = "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>";
    }
    # Telescope project diagnostics
    {
      key = "<leader>tD";
      options = {
        unique = true;
        remap = true;
      };
      action = ''
        function()
            require("telescope.builtin").diagnostics(require("telescope.themes").get_ivy({}))
        end
      '';
      lua = true;
    }
    # Yanky history
    {
      key = "<leader>y";
      options = {
        unique = true;
      };
      action = "<cmd>Telescope yank_history<cr>";
    }
    # LSP info
    {
      key = "<leader>lI";
      options = {
        unique = true;
      };
      action = "<cmd>LspInfo<cr>";
    }
  ];
}
