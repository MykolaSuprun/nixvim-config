{pkgs, ...}: {
  colorschemes = {
    base16 = {
      enable = true;
      colorscheme = "catppuccin-latte";
    };
    # catppuccin = {
    #   enable = true;
    #   autoLoad = true;
    #   settings = {
    #     flavour = "latte";
    #     integrations = {
    #       cmp = true;
    #       gitsigns = true;
    #       telescope = true;
    #       headlines = true;
    #       illuminate = true;
    #       fzf = true;
    #       treesitter = true;
    #       treesitter_context = true;
    #       # harpoon = true;
    #       # nvim-cmp = true;
    #       notifier = true;
    #       noice = true;
    #       notify = true;
    #       # dap = true;
    #       # dap-ui = true;
    #       semantic_tokens = true;
    #       native_lsp = {
    #         enabled = true;
    #         underlines = {
    #           errors = ["undercurl"];
    #           hints = ["undercurl"];
    #           warnings = ["undercurl"];
    #           information = ["undercurl"];
    #         };
    #       };
    #       snacks = true;
    #       window_picker = true;
    #       # indent-blankline = {enabled = true;};
    #       mini = true;
    #       which_key = true;
    #       markdown = true;
    #     };
    #   };
    # };
  };
  plugins = {
    nui.enable = true;
    web-devicons.enable = true;

    bufferline = {
      enable = true;
      settings = {
        options = {
          # Use tabs only (not buffers)
          mode = "tabs";

          # Visual styling optimized for catppuccin-latte
          separator_style = "slant";

          # Tab behavior
          always_show_bufferline = true;
          show_buffer_close_icons = false;
          show_close_icon = true;
          show_tab_indicators = true;
          show_duplicate_prefix = false;

          # Tab sizing and naming
          tab_size = 22;
          max_name_length = 20;
          truncate_names = true;

          # Visual enhancements
          color_icons = true;

          # Custom icon handling for better theme integration
          get_element_icon = {
            __raw = ''
              function(element)
                local icon, hl = require('nvim-web-devicons').get_icon_by_filetype(element.filetype, { default = false })
                return icon, hl
              end
            '';
          };

          # File explorer offset
          offsets = [
            {
              filetype = "neo-tree";
              text = "󰉋 File Explorer";
              text_align = "center";
              separator = true;
            }
            {
              filetype = "NvimTree";
              text = "󰉋 File Explorer";
              text_align = "center";
              separator = true;
            }
          ];

          # Hover behavior
          hover = {
            enabled = true;
            delay = 200;
            reveal = ["close"];
          };

          # Sort tabs by extension for better organization
          # sort_by = "insert_at_end";

          # Create new tabs to the right of current tab
          enforce_regular_tabs = true;

          # Configure tab creation behavior
          right_mouse_command = "tabnew %f";
        };
      };
    };

    which-key = {
      enable = true;
      settings = {
        notify = true;
        preset = "helix";
        show_help = true;
        show_keys = true;
      };
    };
    lualine = {
      enable = true;
      lazyLoad = {
        settings = {
          event = ["BufEnter"];
        };
      };
      settings = {
        options = {
          theme = "auto";
          component_separators = {
            left = "";
            right = "";
          };
          section_separators = {
            left = "";
            right = "";
          };
        };
        sections = {
          lualine_a = ["mode"];
          lualine_b = ["branch" "diff" "diagnostics"];
          lualine_c = ["filename" "lsp_status"];
          lualine_x = [
            {
              __raw = ''
                function()
                  local recording_register = vim.fn.reg_recording()
                  if recording_register == "" then
                    return ""
                  else
                    return "Recording @" .. recording_register
                  end
                end
              '';
              # color = {
              #   fg = "#ff9e64";
              #   gui = "bold";
              # };
            }
            "encoding"
            "fileformat"
            "filetype"
          ];
          lualine_y = ["progress"];
          lualine_z = ["location"];
        };
      };
    };
  };

  extraConfigLuaPost = ''
    local local_colorscheme = os.getenv('STYLIX_COLORSCHEME')

    -- If the environment variable is set, construct and apply the colorscheme
    if local_colorscheme then
      local colorscheme = 'base16-' .. local_colorscheme
      pcall(vim.cmd, 'colorscheme ' .. colorscheme)
    end

    -- Macro recording indicator using autocommands
    local function notify_macro_recording()
      local recording_register = vim.fn.reg_recording()
      if recording_register ~= "" then
        if package.loaded["snacks"] then
          require("snacks").notifier.notify("Recording macro @" .. recording_register, {
            title = "Macro Recording",
            icon = "󰻂",
            timeout = false,
          })
        end
      else
        if package.loaded["snacks"] then
          require("snacks").notifier.hide()
        end
      end
    end

    -- Set up autocommands for macro recording feedback
    vim.api.nvim_create_augroup("MacroRecording", { clear = true })

    vim.api.nvim_create_autocmd("RecordingEnter", {
      group = "MacroRecording",
      callback = function()
        notify_macro_recording()
        vim.defer_fn(function()
          vim.cmd("redrawstatus")
        end, 10)
      end,
    })

    vim.api.nvim_create_autocmd("RecordingLeave", {
      group = "MacroRecording",
      callback = function()
        if package.loaded["snacks"] then
          require("snacks").notifier.notify("Macro recording stopped", {
            title = "Macro Recording",
            icon = "󰻂",
            timeout = 2000,
          })
        end
        vim.defer_fn(function()
          vim.cmd("redrawstatus")
        end, 10)
      end,
    })
  '';
}
