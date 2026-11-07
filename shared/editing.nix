# Shared editing plugins — imported by both nixvim-config and codevim-config.
# These are pure editing primitives with no UI, terminal, or LSP dependencies,
# so they work identically in both full Neovim and VSCode embedded mode.
_: {
  plugins = {
    lz-n.enable = true;

    treesitter = {
      enable = true;
      nixvimInjections = true;
      # nvim-treesitter is the `main` branch: nixvim maps highlight/indent
      # onto vim.treesitter.start()/indentexpr. There is no
      # incremental_selection module any more — Neovim 0.12's built-in
      # visual `an` / `in` (and `]n` / `[n`) replace it.
      settings = {
        indent.enable = true;
        highlight.enable = true;
      };
      lazyLoad.settings.event = ["BufEnter"];
    };

    # On the `main` branch textobjects are not configured through
    # nvim-treesitter's setup; nixvim only installs the plugin
    # (callSetup = false). setup() + keymaps live in extraConfigLua below.
    treesitter-textobjects.enable = true;

    nvim-autopairs = {
      enable = true;
      lazyLoad.settings.event = ["BufEnter"];
      settings.check_ts = true;
    };

    mini-align.enable = true;

    ts-comments.enable = true;

    flash = {
      enable = true;
      settings = {
        label.rainbow.enable = true;
        modes.char.enabled = true;
      };
    };

    nvim-surround = {
      enable = true;
      lazyLoad.settings.event = ["BufEnter"];
    };

    illuminate = {
      enable = true;
      settings = {
        delay = 200;
        min_count_to_highlight = 2;
        providers = [
          "lsp"
          "treesitter"
          "regex"
        ];
      };
    };

    todo-comments = {
      enable = true;
      lazyLoad.settings.event = ["BufEnter"];
    };
  };

  # Treesitter textobjects (main-branch API).
  #   select (x/o): af/if function, ac/ic class, aa/ia parameter
  #   move   (n/x/o): ]f/[f function start, ]k/[k class start
  # ]k/[k rather than ]c/[c: those are the built-in diff-hunk motions.
  extraConfigLua =
    #lua
    ''
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })
      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")
      for lhs, spec in pairs({
        af = { "@function.outer", "outer function" },
        ["if"] = { "@function.inner", "inner function" },
        ac = { "@class.outer", "outer class" },
        ic = { "@class.inner", "inner class" },
        aa = { "@parameter.outer", "outer parameter" },
        ia = { "@parameter.inner", "inner parameter" },
      }) do
        vim.keymap.set({ "x", "o" }, lhs, function()
          select.select_textobject(spec[1], "textobjects")
        end, { desc = "Select " .. spec[2] })
      end
      for lhs, spec in pairs({
        ["]f"] = { "goto_next_start", "@function.outer", "Next function" },
        ["[f"] = { "goto_previous_start", "@function.outer", "Prev function" },
        ["]k"] = { "goto_next_start", "@class.outer", "Next class" },
        ["[k"] = { "goto_previous_start", "@class.outer", "Prev class" },
      }) do
        vim.keymap.set({ "n", "x", "o" }, lhs, function()
          move[spec[1]](spec[2], "textobjects")
        end, { desc = spec[3] })
      end
    '';
}
