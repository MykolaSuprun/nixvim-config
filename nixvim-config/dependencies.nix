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
    ueberzug.enable = pkgs.stdenv.isLinux;
    git.enable = true;
    gh.enable = true;
    direnv.enable = true;
    curl.enable = true;
  };
  extraPackages = with pkgs; [
    fd
    ripgrep
    jq
    black
    ast-grep
    isort
    stylua
    selene
    deadnix
    statix
    # dockle
    rustfmt
    codespell
    alejandra
    shellcheck
    shellharden
    markdownlint-cli2
    prettier
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
    python313Packages.flake8
    python313Packages.debugpy
    go
    delve
    golangci-lint
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
    snowflakeCli
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
