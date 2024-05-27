{
  plugins.nvim-tree = {
    enable = true;
    # openOnSetup = true;
    autoClose = true;
    preferStartupRoot = true;
    # disableNetrw = true;
    # hijackNetrw = true;
    # hijackUnnamedBufferWhenOpening = true;
    view.number = true;
    view.relativenumber = true;
  };
  extraConfigLua = ''
    require('nvim-tree').setup({
      actions = {
        open_file = {
          quit_on_open = true,
        },
      },
    })
  '';
}
