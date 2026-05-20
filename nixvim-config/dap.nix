# DAP (Debug Adapter Protocol) configuration for nixvim.
# Provides: nvim-dap, nvim-dap-ui, nvim-dap-virtual-text
# Adapters:  Python (debugpy), Go (delve via nvim-dap-go), Lua/Neovim (osv)
{pkgs, ...}: {
  plugins = {
    dap = {
      enable = true;
      signs = {
        dapBreakpoint = {
          text = "●";
          texthl = "DapBreakpoint";
        };
        dapBreakpointCondition = {
          text = "◐";
          texthl = "DapBreakpointCondition";
        };
        dapLogPoint = {
          text = "◆";
          texthl = "DapLogPoint";
        };
        dapStopped = {
          text = "▶";
          texthl = "DapStopped";
          linehl = "DapStoppedLine";
          numhl = "DapStoppedLine";
        };
        dapBreakpointRejected = {
          text = "✗";
          texthl = "DapBreakpointRejected";
        };
      };
    };

    dap-ui = {
      enable = true;
      settings = {
        icons = {
          expanded = "▾";
          collapsed = "▸";
          current_frame = "▸";
        };
        mappings = {
          expand = ["<CR>" "<2-LeftMouse>"];
          open = "o";
          remove = "d";
          edit = "e";
          repl = "r";
          toggle = "t";
        };
        layouts = [
          {
            elements = [
              {
                id = "scopes";
                size = 0.33;
              }
              {
                id = "breakpoints";
                size = 0.17;
              }
              {
                id = "stacks";
                size = 0.25;
              }
              {
                id = "watches";
                size = 0.25;
              }
            ];
            size = 40;
            position = "left";
          }
          {
            elements = [
              {
                id = "repl";
                size = 0.5;
              }
              {
                id = "console";
                size = 0.5;
              }
            ];
            size = 10;
            position = "bottom";
          }
        ];
        floating = {
          max_height = null;
          max_width = null;
          border = "rounded";
        };
      };
    };

    # Python adapter wrapping debugpy (debugpy must be in extraPackages)
    dap-python = {
      enable = true;
      adapterPythonPath = "python";
    };

    # Go adapter using delve (delve must be in extraPackages)
    dap-go.enable = true;
  };

  # nvim-dap-virtual-text + one-small-step-for-vimkind (OSV, Lua/Neovim DAP)
  extraPlugins = with pkgs.vimPlugins; [
    nvim-dap-virtual-text
    one-small-step-for-vimkind
  ];

  extraConfigLua =
    #lua
    ''
      -- nvim-dap-virtual-text: show variable values inline while debugging
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        virt_text_pos = "eol",
      })

      -- OSV: Lua/Neovim debug adapter
      -- Usage: in the target nvim instance run
      --   :lua require("osv").launch({port=8086})
      -- then attach from another nvim instance with <leader>dL
      local dap = require("dap")
      dap.adapters.nlua = function(callback, config)
        callback({
          type = "server",
          host = config.host or "127.0.0.1",
          port = config.port or 8086,
        })
      end
      dap.configurations.lua = {
        {
          type = "nlua",
          request = "attach",
          name = "Attach to running Neovim instance (OSV)",
          host = "127.0.0.1",
          port = 8086,
        },
      }

      -- Open/close dap-ui automatically when a debug session starts/ends
      local dapui = require("dapui")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    '';
}
