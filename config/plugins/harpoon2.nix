{pkgs, ...}: {
  # keymaps for this plugin are difined in config/keymaps/window-movements module
  extraPlugins = with pkgs.vimPlugins; [
    harpoon2
  ];
  extraConfigLua = ''
    local harpoon = require("harpoon")
    harpoon:setup()


    vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
    vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

    vim.keymap.set("n", "<C-s>", function() harpoon:list():select(1) end)
    vim.keymap.set("n", "<C-d>", function() harpoon:list():select(2) end)
    vim.keymap.set("n", "<C-f>", function() harpoon:list():select(3) end)
    vim.keymap.set("n", "<C-g>", function() harpoon:list():select(4) end)


  '';
}
