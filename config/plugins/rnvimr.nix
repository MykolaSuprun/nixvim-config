{pkgs, ...}: {
  # keymaps for this plugin are difined in config/keymaps/window-movements module
  extraPlugins = with pkgs.vimPlugins; [
    rnvimr
  ];
  extraConfigLua = ''
    -- Make Ranger replace Netrw and be the file explorer
    vim.g.rnvimr_enable_ex = 1
    -- Make Ranger to be hidden after picking a file
    vim.g.rnvimr_enable_picker = 1
    -- Replace `$EDITOR` candidate with this command to open the selected file
    vim.g.rnvimr_edit_cmd = 'drop'
    -- Disable a border for floating window
    -- vim.g.rnvimr_draw_border = 0
    -- Make Neovim wipe the buffers corresponding to the files deleted by Ranger
    vim.g.rnvimr_enable_bw = 1

  '';
}
