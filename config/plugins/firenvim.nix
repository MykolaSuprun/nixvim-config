{pkgs, ...}: {
  extraPlugins = with pkgs.vimPlugins; [
    firenvim
  ];
  extraConfigLua = ''
    vim.api.nvim_create_autocmd({'UIEnter'}, {
        callback = function(event)
            local client = vim.api.nvim_get_chan_info(vim.v.event.chan).client
            if client ~= nil and client.name == "Firenvim" then
                -- code to execute on browser connect
                vim.o.laststatus = 0
            end
        end
    })
  '';
}
