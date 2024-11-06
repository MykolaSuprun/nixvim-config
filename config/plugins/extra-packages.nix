{ pkgs, ... }: {
  extraPackages = with pkgs; [
    #file manager
    lf
    # core tools
    ripgrep
    ast-grep
    fd
    lazygit
    tree-sitter
    fzf
    git
    python312Packages.pynvim
    ueberzugpp
    treesitter-nu-grammar-src

    #formatters
    isort
    autoflake
    black
    alejandra
    stylua
    yamlfix
    jq
    scalafmt
    nufmt
  ];
}
