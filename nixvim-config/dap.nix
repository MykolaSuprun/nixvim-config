# DAP (Debug Adapter Protocol) configuration for nixvim.
# Provides: nvim-dap, nvim-dap-ui, nvim-dap-virtual-text
# Adapters:  Python (debugpy), Go (delve via nvim-dap-go), Lua/Neovim (osv),
#            C/C++/Rust (codelldb — adapter binary from vscode-lldb)
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

    # Python adapter wrapping debugpy. The adapter python must be able to
    # `import debugpy` — the wrapper's bare `python` (3.14) cannot, so point at
    # a python that bundles it. The debuggee's interpreter stays configurable
    # per launch config (dap-python `pythonPath`).
    dap-python = {
      enable = true;
      adapterPythonPath = "${pkgs.python313.withPackages (ps: [ps.debugpy])}/bin/python";
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

      -- CodeLLDB: C/C++/Rust debug adapter. The binary ships inside the
      -- vscode-lldb extension package; since 1.11 it speaks DAP over stdio,
      -- so a plain executable adapter works (no port juggling).
      dap.adapters.codelldb = {
        type = "executable",
        command = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb",
      }

      local codelldb_program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end
      local codelldb_configs = {
        {
          name = "Launch executable (codelldb)",
          type = "codelldb",
          request = "launch",
          program = codelldb_program,
          cwd = "$${workspaceFolder}",
          stopOnEntry = false,
          args = {},
        },
        {
          name = "Attach to process (codelldb)",
          type = "codelldb",
          request = "attach",
          program = codelldb_program,
          pid = require("dap.utils").pick_process,
          cwd = "$${workspaceFolder}",
        },
      }
      dap.configurations.c = codelldb_configs
      dap.configurations.cpp = codelldb_configs
      dap.configurations.rust = codelldb_configs

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
