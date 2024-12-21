{
  plugins.none-ls = {
    enable = true;
    enableLspFormat = true;

    sources = {
      diagnostics = {
        semgrep.enable = true;
        deadnix.enable = true;
        statix.enable = true;
        fish.enable = true;
        zsh.enable = true;
        hadolint.enable = true;
        yamllint.enable = true;
        sqlfluff.enable = true;
      };
      formatting = {
        # nix
        alejandra.enable = true;
        # python
        isort.enable = true;
        black.enable = true;
        # yaml, json, etc...
        prettier.enable = true;
        # # lua
        stylua.enable = true;
        # # scala
        scalafmt.enable = true;
        # # sql
        sqlfluff.enable = true;
      };
      hover = {
        # dictionary.enable = true;
        # printenv.enable = true;
      };
    };
  };
}
