{ pkgs, ... }: {
  # keymaps for this plugin are difined in config/keymaps/window-movements module
  extraPlugins = with pkgs.vimPlugins; [ grug-far-nvim ];
  extraConfigLua = ''
    require('grug-far').setup({
          -- options, see Configuration section below
          -- there are no required options atm
          -- engine = 'ripgrep' is default, but 'astgrep' can be specified
          headerMaxWidth = 80
        });
  '';
}
