{pkgs, ...}: {
  plugins = {
    treesitter = {
      enable = true;
      # folding = true;
      indent = true;
      nixvimInjections = true;
      incrementalSelection = {
        enable = true;
        keymaps = {
          initSelection = "<leader>ss";
          nodeIncremental = "<leader>si";
          nodeDecremental = "<leader>sd";
          scopeIncremental = "<leader>sc";
        };
      };
    };
    treesitter-context.enable = true;
    treesitter-refactor = {
      enable = true;
      highlightCurrentScope.enable = true;
      highlightDefinitions.enable = true;
      navigation.enable = true;
      smartRename.enable = true;
    };
  };
}
