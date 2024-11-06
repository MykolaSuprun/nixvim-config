{ pkgs, ... }: {
  #Plugin documentation: https://github.com/jamestthompson3/nvim-remote-containers
  extraPlugins = with pkgs.vimPlugins; [ nvim-remote-containers ];
}
