{
  plugins.which-key = {
    enable = true;
    registrations = {
      "<leader>f" = "Find file";
      "<leader>F" = "Live grep";
      "<leader>E" = "Toggle NvimTree";
      "<leader>e" = "Toggle Oil";
      "<leader>/" = "Fuzzy find in the buffer";
      "<leader>t" = "Telescope...";
      "<leader>th" = "Toggle Telescope help";
      "<leader>td" = "LSP diagnostics for the buffer";
      "<leader>tD" = "LSP diagnostics for the project";
      "<leader>l" = "LSP...";
      "<leader>lI" = "LSP informartion";
      "<leader>s" = "Treesitter select...";
      "<leader>ss" = "initSelection";
      "<leader>si" = "nodeIncremental";
      "<leader>sd" = "nodeDecremental";
      "<leader>sc" = "scopeIncremental";
      # "<leader>bp" = "Toggle buffer pin";
      # "<leader>bob" = "Order by buffer number";
      # "<leader>bod" = "Order buffers by directory";
      # "<leader>bow" = "Order by window number";
      # "<leader>bol" = "Order by language";
      "<leader>a" = "Harpoon add buffer";
      "<C-e>" = "Harpoon list pinned";
      "C-u" = "Harpoon select 1";
      "C-i" = "Harpoon select 2";
      "C-o" = "Harpoon select 3";
      "C-p" = "Harpoon select 4";
      "C-S-j" = "Harpoon next";
      "C-S-k" = "Harpoon prev";
      "gl" = "Go to lint";
    };
  };
}
