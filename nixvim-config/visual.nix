{pkgs, ...}: let
  # Hoisted to avoid Nix treesitter parser confusion when __raw sits inside
  # a heterogeneous list alongside bare strings (breaks editor highlighting).
  macroRecordingComponent = {
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
  };

  # sidekick.nvim CLI status — shows the active CLI tool name(s).
  # Uses sidekick.status.cli() (the copilot LSP status requires copilot,
  # which is intentionally disabled). Guarded by pcall.
  sidekickStatusComponent = {
    __raw = ''
      function()
        local ok, status = pcall(require, "sidekick.status")
        if not ok then return "" end
        local ok2, sessions = pcall(status.cli)
        if not ok2 or not sessions or #sessions == 0 then return "" end
        local tools = {}
        for _, s in ipairs(sessions) do
          tools[#tools + 1] = s.tool
        end
        return "󰚩 " .. table.concat(tools, ", ")
      end
    '';
  };
in {
  colorschemes = {
    # base16 disabled: catppuccin owns theming (autoload below) and
    # $STYLIX_COLORSCHEME in extraConfigLuaPost is the override path.
    base16 = {
      enable = false;
    };
    catppuccin = {
      enable = true;
      autoLoad = true;
      settings = {
        flavour = "latte";
        integrations = {
          cmp = true;
          blink = true;
          gitsigns = true;
          bufferline = true;
          # telescope/headlines integrations removed: neither plugin is shipped
          # (telescope refused per AGENTS.md; render-markdown replaced headlines).
          illuminate = true;
          fzf = true;
          flash = true;
          treesitter = true;
          treesitter_context = true;
          harpoon = true;
          notifier = true;
          noice = true;
          notify = true;
          snacks = {
            enabled = true;
            indent_scope_color = "lavender";
          };
          dap = true;
          dap_ui = true;
          semantic_tokens = true;
          native_lsp = {
            enabled = true;
            underlines = {
              errors = ["undercurl"];
              hints = ["undercurl"];
              warnings = ["undercurl"];
              information = ["undercurl"];
            };
          };
          window_picker = true;
          mini = true;
          which_key = true;
          markdown = true;
          overseer = true;
        };
      };
    };
  };
  plugins = {
    nui.enable = true;
    # web-devicons is declared in ../shared/plugins.nix

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
            macroRecordingComponent
            sidekickStatusComponent
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

  # Truecolor: Neovim (0.10+) detects terminal truecolor support itself; the
  # former $COLORTERM gate fell back to habamax over ssh/tmux/docker, where
  # COLORTERM is usually not forwarded even though truecolor works.
  # Macro recording state is shown by the lualine component above and by
  # noice's mode message — no extra notification (the old one never closed).
  extraConfigLuaPost = ''
    -- Stylix override: $STYLIX_COLORSCHEME names a colorscheme to use instead
    -- of catppuccin.
    local local_colorscheme = vim.env.STYLIX_COLORSCHEME
    if local_colorscheme and local_colorscheme ~= "" then
      pcall(vim.cmd.colorscheme, local_colorscheme)
    end

    -- Refresh lualine's recording component immediately on start/stop.
    vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
      group = vim.api.nvim_create_augroup("MacroRecording", { clear = true }),
      callback = function()
        vim.schedule(function()
          vim.cmd("redrawstatus")
        end)
      end,
    })
  '';
}
