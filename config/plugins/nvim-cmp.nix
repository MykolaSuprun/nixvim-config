{
  plugins.nvim-cmp = {
    enable = true;
    sources = [
      {name = "nvim_lsp";}
    ];
    completion = {
      completeopt = "menu,menuone,preview,noinsert,noselect";
    };
  };
  plugins.cmp-nvim-lsp.enable = true;
}
