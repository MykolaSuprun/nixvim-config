{
  plugins.conform-nvim = {
    enable = true;
    settings = {
      formattersByFt = {
        lua = [ "stylua" ];
        nix = [ "alejandra" ];
        # python = ["autoflake" "isort" "ssort" "black"];
        nu = [ "nufmt" ];
        python = [ "isort" "black" ];
        yaml = [ "yamlfix" ];
        docker = [ "dockerls" ];
        json = [ "jq" ];
        scala = [ "scalafmt" ];
        "_" = [ "squeeze_blanks" "trim_whitespace" "trim_newlines" ];
      };

      format_on_save = # Lua
        ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end

            if slow_format_filetypes[vim.bo[bufnr].filetype] then
              return
            end

            local function on_format(err)
              if err and err:match("timeout$") then
                slow_format_filetypes[vim.bo[bufnr].filetype] = true
              end
            end

            return { timeout_ms = 200, lsp_fallback = true }, on_format
          end
        '';
      format_after_save = # Lua
        ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end

            if not slow_format_filetypes[vim.bo[bufnr].filetype] then
              return
            end

            return { lsp_fallback = true }
          end
        '';
      default_format_opts.lsp_format = "fallback";
      log_level = "warn";
      notify_on_error = false;
      notify_no_formatters = false;
    };
    luaConfig.pre = ''
      local slow_format_filetypes = {}
    '';
  };

  # extraConfigLuaPre = ''
  #   vim.api.nvim_create_autocmd("BufWritePre", {
  #     pattern = "*",
  #     callback = function(args)
  #       require("conform").format({ bufnr = args.buf })
  #     end,
  #   })
  #
  #
  #   local slow_format_filetypes = {}
  #   require("conform").setup({
  #     format_on_save = function(bufnr)
  #       if slow_format_filetypes[vim.bo[bufnr].filetype] then
  #         return
  #       end
  #       local function on_format(err)
  #         if err and err:match("timeout$") then
  #           slow_format_filetypes[vim.bo[bufnr].filetype] = true
  #         end
  #       end
  #
  #       return { timeout_ms = 200, lsp_fallback = true }, on_format
  #     end,
  #
  #     format_after_save = function(bufnr)
  #       if not slow_format_filetypes[vim.bo[bufnr].filetype] then
  #         return
  #       end
  #       return { lsp_fallback = true }
  #     end,
  #   })
  # '';
}
