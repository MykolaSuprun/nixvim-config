{ pkgs, ... }: {
  # keymaps for this plugin are difined in config/keymaps/window-movements module
  extraPlugins = with pkgs.vimPlugins; [{
    plugin = pkgs.vimPlugins.nvim-surround;
  }];
  extraConfigLua = ''
    require("nvim-surround").setup({})
  '';
}
