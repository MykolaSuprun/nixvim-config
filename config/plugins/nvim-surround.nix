{pkgs, ...}: {
  # keymaps for this plugin are difined in config/keymaps/window-movements module
  extraPlugins = with pkgs.vimPlugins; [
    vim-tmux-navigator
    {
      plugin = pkgs.vimPlugins.nvim-surround;
    }
  ];
  extraConfigLua = ''
    require("nvim-surround").setup({})
  '';
}
