{pkgs, ...}: {
  # keymaps for this plugin are difined in config/keymaps/window-movements module
  extraPlugins = with pkgs.vimPlugins; [
    FTerm-nvim
  ];
  extraConfigLua = ''
    require'FTerm'.setup({
        border = 'single',
        dimensions  = {
            height = 1,
            width = 1,
        },
        autoclose = true,
        clear_env = false,
    })
  '';
}
