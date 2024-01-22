{pkgs, ...}: {
  # keymaps for this plugin are difined in config/keymaps/window-movements module
  extraPlugins = with pkgs.vimPlugins; [
    nvim-cmp
    {
      plugin = nvim-cmp;
      config = ''

      '';
    }
  ];
}
