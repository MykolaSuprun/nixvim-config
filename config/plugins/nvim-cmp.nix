{
  plugins.nvim-cmp = {
    enable = true;
    sources  = [
      { name = "nvim_lsp"; }
      { name = "luasnip"; } #For luasnip users.
      { name = "path"; }
      { name = "buffer"; }
    ];
  };
}
