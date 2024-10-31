{
  plugins.conform-nvim = {
    enable = true;
    settings = {
      formattersByFt = {
        lua = ["stylua"];
        nix = ["alejandra"];
        # python = ["autoflake" "isort" "ssort" "black"];
        nushell =["nufmt"];
        python = ["isort" "black"];
        yaml = ["yamlfix"];
        docker = ["dockerls"];
        json = ["jq"];
        scala = ["scalafmt"];
      };
    };
  };
  extraConfigLuaPre = ''
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*",
      callback = function(args)
        require("conform").format({ bufnr = args.buf })
      end,
    })


    local slow_format_filetypes = {}
    require("conform").setup({
      format_on_save = function(bufnr)
        if slow_format_filetypes[vim.bo[bufnr].filetype] then
          return
        end
        local function on_format(err)
          if err and err:match("timeout$") then
            slow_format_filetypes[vim.bo[bufnr].filetype] = true
          end
        end

        return { timeout_ms = 200, lsp_fallback = true }, on_format
      end,

      format_after_save = function(bufnr)
        if not slow_format_filetypes[vim.bo[bufnr].filetype] then
          return
        end
        return { lsp_fallback = true }
      end,
    })
  '';
}
