{pkgs, ...}: {
  extraPlugins = with pkgs.vimPlugins; [
    firenvim
  ];
  extraConfigLuaPost = ''
    if vim.g.started_by_firenvim == true then
      vim.o.laststatus = 0
    else
      vim.o.laststatus = 2
    end
  '';
}
