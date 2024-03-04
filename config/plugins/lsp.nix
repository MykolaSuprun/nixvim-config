{
  plugins.lsp = {
    enable = true;

    servers = {
      nixd.enable = true;
      lua-ls.enable = true;
      pyright.enable = true;
      ruff-lsp.enable = true;
      dockerls.enable = true;
    };
  };
}
