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
    # opencode CLI — the opencode.nvim plugin spawns `opencode serve` itself.
    # (Previously provided by the nixvim `plugins.opencode` module's
    # `dependencies = ["opencode"]`, which we no longer use — see plugins.nix.)
    opencode
    # herdr — herd.nvim's backend daemon. Requires ≥ 0.7.5 (the `--kind`
    # migration); main nixpkgs-unstable ships 0.8.2, no separate pin needed.
    herdr
  ];
  extraLuaPackages = ps: [ps.magick];
}
