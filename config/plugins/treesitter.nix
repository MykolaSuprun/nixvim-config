{ pkgs, ... }: {
  plugins = {
    treesitter = {
      enable = true;
      # folding = true;
      nixvimInjections = true;
      grammarPackages = pkgs.vimPlugins.nvim-treesitter.passthru.allGrammars
        ++ [ pkgs.treesitter-nu-grammar ];
      settings = {
        indent.enable = true;
        highlight.enable = true;
        # auto_install = true;
        incrementalSelection = {
          enable = true;
          keymaps = {
            init_selection = "<leader>ss";
            node_incremental = "<leader>si";
            node_decremental = "<leader>sd";
            scope_incremental = "<leader>sc";
          };
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

  extraConfigLua = ''
    do
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      -- change the following as needed
      parser_config.nu = {
        install_info = {
          url = "${pkgs.treesitter-nu-grammar-src}", -- local path or git repo
          files = {"src/parser.c"}, -- note that some parsers also require src/scanner.c or src/scanner.cc
          -- optional entries:
          branch = "main", -- default branch in case of git repo if different from master
          -- generate_requires_npm = false, -- if stand-alone parser without npm dependencies
          -- requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
        },
        filetype = "nu", -- if filetype does not match the parser name
      }
    end
  '';
  extraPlugins = [ pkgs.treesitter-nu-grammar ];

}
