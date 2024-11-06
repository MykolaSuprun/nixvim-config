{
  extraConfigLuaPre = ''
    local getLayoutStrategy = function()
      if vim.api.nvim_win_get_width(0) > vim.api.nvim_win_get_height(0) * 3 then
        return "horizontal"
      else
        return "vertical"
      end
    end
  '';
  plugins.telescope = { enable = true; };
}
