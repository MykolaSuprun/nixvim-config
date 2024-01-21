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
  ];
}
