{
  pkgs,
  snowflakeCli,
  ...
}: {
  dependencies = {
    lazygit.enable = true;
    ripgrep.enable = true;
    sed.enable = true;
    tree-sitter.enable = true;
    imagemagick.enable = true;
    ueberzug.enable = pkgs.stdenv.isLinux;
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
    ast-grep
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
    python313Packages.debugpy
    go
    delve
    golangci-lint
    zsh
    # dbt / Snowflake workflow — `snow` CLI, driven via overseer templates
    # (overseer/dbt_tasks.lua) and betterTerm. See snowflakeCli comment in
    # flake.nix: pinned to nixos-25.05 because current nixpkgs fails to build
    # snowflake-connector-python's test suite on aarch64-linux.
    snowflakeCli
    tmux # sidekick.cli.mux backend (enabled=false by default, available if wanted)
  ];
  extraLuaPackages = ps: [ps.magick];
}
