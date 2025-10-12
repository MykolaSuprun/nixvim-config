{pkgs, ...}: {
  dependencies = {
    lazygit.enable = true;
    ripgrep.enable = true;
    sed.enable = true;
    tree-sitter.enable = true;
    imagemagick.enable = true;
    ueberzug.enable = true;
    wezterm.enable = true;
    git.enable = true;
    gh.enable = true;
    direnv.enable = true;
  };
  extraPackages = with pkgs; [
    fd
  ];
  extraLuaPackages = ps: [ps.magick];
}
