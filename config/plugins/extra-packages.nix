{pkgs, ...}: {
  extraPackages = with pkgs; [
    #file manager
    ranger
    # core tools
    ripgrep
    fd
    lazygit
    tree-sitter
    fzf
    git
    python312Packages.pynvim
    ueberzugpp

    #formatters
    isort
    autoflake
    black
    alejandra
    stylua
    yamlfix
    jq
    scalafmt
  ];
}
