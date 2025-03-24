{
  plugins.cmp = {
    enable = true;
    settings = {
      completion = {
        completeopt = "menu,menuone,noselect,noinsert";
      };

      sources = [
        {
          name = "nvim_lsp";
          groupIndex = 1;
        }
        {
          name = "fuzzy_path";
          groupIndex = 1;
        }
        {
          name = "rg";
          groupIndex = 2;
        }
        {
          name = "git";
          groupIndex = 2;
        }
        {
          name = "buffer";
          groupIndex = 3;
        }
      ];
      mapping = {
        "<C-j>" = "cmp.mapping(cmp.mapping.select_next_item())";
        "<C-k>" = "cmp.mapping(cmp.mapping.select_prev_item())";
        "<C-h>" = "cmp.mapping.abort()";
        "<C-l>" = "cmp.mapping.confirm()";
        "<C-f>" = "cmp.mapping.scroll_docs(4)";
        "<CR>" = "cmp.mapping.confirm({ select = false })";
      };
      preselect = "cmp.PreselectMode.None";
    };
  };

  plugins.cmp-nvim-lsp.enable = true;
  plugins.cmp-git.enable = true;
  plugins.cmp-rg.enable = true;
  plugins.cmp-fuzzy-path.enable = true;
  plugins.cmp-cmdline.enable = true;
}
