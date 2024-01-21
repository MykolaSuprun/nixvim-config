{
  pkgs,
  ultimate-autopair-src,
  ...
}: let
  ultimate-autopair = pkgs.vimUtils.buildVimPlugin {
    name = "ultimate-autopair";
    src = ultimate-autopair-src;
  };
in {
  extraPlugins = with pkgs.vimPlugins; [
  ];
}
