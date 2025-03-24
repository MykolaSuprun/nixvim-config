{
  plugins.lsp = {
    enable = true;

    servers = {
      nixd.enable = true;
      lua_ls.enable = true;
      pyright.enable = true;
      dockerls.enable = true;
      jsonls.enable = true;
      metals.enable = true;
      nushell.enable = true;
      yamlls.enable = true;
      sqls.enable = true;
    };
  };
}
