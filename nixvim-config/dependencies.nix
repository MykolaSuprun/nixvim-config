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
    curl.enable = true;
  };
  extraPackages = with pkgs; [
    fd
    ripgrep
    jq
    black
    isort
    stylua
    selene
    deadnix
    statix
    # dockle
    rustfmt
    codespell
    alejandra
    shellcheck
    shellharden
    markdownlint-cli2
    shfmt
    sqruff
    yamllint
    yamlfmt
    ruff
    bandit
    python313Packages.cssbeautifier
    python313Packages.flake8
    go
    zsh
  ];
  extraLuaPackages = ps: [ps.magick];
}
