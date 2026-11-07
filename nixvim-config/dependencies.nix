{
  pkgs,
  snowflakeCli,
  sqlitPkg,
  ...
}: {
  dependencies = {
    lazygit.enable = true;
    ripgrep.enable = true;
    sed.enable = true;
    tree-sitter.enable = true;
    imagemagick.enable = true;
    ueberzug.enable = pkgs.stdenv.hostPlatform.isLinux;
    git.enable = true;
    gh.enable = true;
    direnv.enable = true;
    curl.enable = true;
  };
  # Only tools something in this config actually invokes (conform formatters,
  # nvim-lint linters, overseer templates, DAP adapters). ripgrep comes from
  # `dependencies.ripgrep` above; python formatting/linting is ruff (LSP +
  # conform), and dap.nix bundles its own debugpy python.
  extraPackages = with pkgs; [
    fd
    jq
    ast-grep
    stylua
    selene
    deadnix
    statix
    codespell
    alejandra
    shellcheck
    markdownlint-cli2
    # prettierd: prettier as a daemon — no node startup per save.
    prettierd
    markdown-toc
    shfmt
    sqruff
    yamllint
    yamlfmt
    ruff
    bandit
    # conform's css_beautify formatter shells out to the node `css-beautify`
    # binary (js-beautify), NOT the python cssbeautifier.
    js-beautify
    hadolint # dockerfile linter (lsp.nix lintersByFt)
    go
    delve
    golangci-lint
    gotools # goimports (conform)
    gofumpt # stricter gofmt (conform)
    zsh
    # C/C++ (clang ecosystem) — clangd LSP + clang-format + clang-tidy,
    # static analysis, compile_commands.json generation, CMake.
    # Wired in lsp.nix (clangd), plugins.nix (conform/clangd-extensions/
    # cmake-tools/neotest-gtest), dap.nix (codelldb adapter), and
    # overseer/cc_tasks.lua.
    clang-tools # clangd, clang-tidy, clang-format, run-clang-tidy
    cppcheck
    include-what-you-use
    bear # records compile_commands.json from any build command
    cmake
    # dbt / Snowflake workflow — `snow` CLI, driven via overseer templates
    # (overseer/dbt_tasks.lua) and betterTerm. See snowflakeCli comment in
    # flake.nix: pinned to nixos-25.05 because current nixpkgs fails to build
    # snowflake-connector-python's test suite on aarch64-linux.
    # Its HTTP-server test fixtures need localhost resolution and loopback
    # sockets on Darwin; keep the sandbox and the complete test suite enabled.
    (snowflakeCli.overrideAttrs (_:
      lib.optionalAttrs stdenv.hostPlatform.isDarwin {
        __darwinAllowLocalNetworking = true;
      }))
    # sqlit TUI (github:Maxteabag/sqlit), built via upstream's flake with the
    # duckdb/postgres/mysql/ssh extras (+ snowflake where the connector
    # builds — see flake.nix). Driven from keymaps via lua/sql_runner.lua;
    # on OrbStack the host macOS sqlit is preferred at runtime (host_tool.lua).
    sqlitPkg
    tmux # sidekick.cli.mux backend (enabled=false by default, available if wanted)
    # ── AI stack binaries (sidekick + codecompanion — see plugins.nix) ──────
    # opencode CLI — the agent sidekick manages in its terminal AND the
    # `opencode acp` server codecompanion's chat adapter speaks to. Also the
    # target of herdr's own integration (`herdr integration install opencode`).
    opencode
    # claude-code CLI — sidekick's `claude` tool (and codecompanion's
    # claude_code ACP adapter if it is ever enabled via claude-agent-acp).
    # nixpkgs#566625 (Darwin builds stay sandboxed) is in the pinned nixpkgs.
    claude-code
    # lsof + procps — sidekick's opencode external-session backend finds the
    # running `opencode serve` by scanning listening TCP ports; without lsof
    # that backend silently does not exist (guarded by executable("lsof")).
    lsof
    procps
    # markitdown — codecompanion v20's fetch_webpage tool (web page → markdown).
    markitdown
    # herdr — the agent multiplexer; herdr-nvim's backend daemon (owns each
    # agent's PTY, reports working/blocked/idle, resumes sessions). Requires
    # ≥ 0.7.5; our locked nixpkgs ships 0.8.2 (0.9.5 on newer unstable), so no
    # separate pin is needed.
    herdr
  ];
  extraLuaPackages = ps: [ps.magick];
}
