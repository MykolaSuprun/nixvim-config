{pkgs, ...}: {
  extraPackages = with pkgs; [
    # core tools
    ripgrep
    fd
    lazygit
    tree-sitter
    fzf
    git

    #formatters
    isort
    autoflake
    black
    alejandra
    stylua
    yamlfmt
  ];
}
