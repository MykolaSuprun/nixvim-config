{
  description = "A nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # Pinned separately from the main nixpkgs input: at nixpkgs-unstable,
    # `snowflake-cli` does not build on aarch64-linux because its
    # `snowflake-connector-python` dependency has a unit test
    # (test_log_debug_config_file_parent_dir_permissions) that assumes it is
    # not running as root — Nix's build sandbox always runs as root, so the
    # chmod-based permission check never triggers and the test fails. This
    # pin only feeds `snowflake-cli` (see dependencies.nix); everything else
    # still comes from the main `nixpkgs` input above.
    # 2026-11-07: moved off the EOL nixos-25.05 to nixos-26.05, where
    # snowflake-cli 3.13.1 is in cache.nixos.org for aarch64-linux (it is
    # still uncached on unstable). Drop this pin once unstable builds it.
    # Related: NixOS/nixpkgs#545397, NixOS/nixpkgs#543941.
    nixpkgs-snowflake.url = "github:nixos/nixpkgs/nixos-26.05";
    # sqlit — terminal UI for SQL databases (github:Maxteabag/sqlit). NOT wired
    # through `follows`: upstream's flake.lock pins a nixpkgs rev that its CI
    # builds against (sqlit's textual/hatchling version floors move fast), so
    # using its own input is the tested path. Used via lib.makeSqlit below.
    sqlit.url = "github:Maxteabag/sqlit";
    nixvim.url = "github:nix-community/nixvim";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-snowflake,
    nixvim,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem = {system, ...}: let
        nixvimLib = nixvim.lib.${system};
        nixvim' = nixvim.legacyPackages.${system};

        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [];
        };

        # snowflake-cli specifically, from the nixos-25.05-pinned nixpkgs (see
        # comment on the `nixpkgs-snowflake` flake input above) — passed to
        # nixvim-config/dependencies.nix via extraSpecialArgs. allowUnfree set
        # for parity with the main pkgs import above.
        snowflakeCli =
          (import nixpkgs-snowflake {
            inherit system;
            config.allowUnfree = true;
          })
          .snowflake-cli;

        # sqlit TUI, built via upstream's flake (see the sqlit input comment).
        # The `snowflake` extra pulls in snowflake-connector-python, which hits
        # the same aarch64-linux test failure described above for `snow` — so
        # it is only enabled where it builds. On aarch64-linux (the OrbStack
        # target) Snowflake is instead reached through the HOST macOS sqlit via
        # OrbStack's `mac` shim (see nixvim-config/plugins.nix host_tool.lua),
        # which is the preferred path there anyway for external-browser OAuth.
        sqlitPkg = inputs.sqlit.lib.${system}.makeSqlit {
          extras =
            [
              "duckdb"
              "postgres"
              "mysql"
              "ssh"
            ]
            ++ pkgs.lib.optionals (system != "aarch64-linux") ["snowflake"];
        };

        nixvimModule = {
          inherit pkgs; # pkgs has config.allowUnfree = true
          module = import ./nixvim-config;
          extraSpecialArgs = {
            inherit snowflakeCli sqlitPkg;
          };
        };

        lazyvimModule = {
          inherit pkgs; # pkgs has config.allowUnfree = true
          module = import ./lazyvim-config;
          extraSpecialArgs = {
            # inherit (inputs) foo;
          };
        };

        codevimModule = {
          inherit pkgs; # pkgs has config.allowUnfree = true
          module = import ./codevim-config;
          extraSpecialArgs = {
            # inherit (inputs) foo;
          };
        };

        nix_vim = nixvim'.makeNixvimWithModule nixvimModule;
        lazy_vim = nixvim'.makeNixvimWithModule lazyvimModule;
        code_vim = nixvim'.makeNixvimWithModule codevimModule;

        # Wrapper scripts to create executables for different builds
        nixvim-wrapper = pkgs.writeShellScriptBin "nixvim" ''
          exec ${nix_vim}/bin/nvim "$@"
        '';
        nvim-wrapper = pkgs.writeShellScriptBin "nvim" ''
          exec ${nix_vim}/bin/nvim "$@"
        '';
        lazyvim-wrapper = pkgs.writeShellScriptBin "lazyvim" ''
          exec ${lazy_vim}/bin/nvim "$@"
        '';
        codevim-wrapper = pkgs.writeShellScriptBin "codevim" ''
          exec ${code_vim}/bin/nvim "$@"
        '';

        # Docker images — self-contained, loadable on any machine with Docker.
        # Build: nix build .#docker-nixvim
        # Load:  docker load < result
        # Run:   docker run --rm -it nixvim:latest
        docker-nixvim = pkgs.dockerTools.buildImage {
          name = "nixvim";
          tag = "latest";
          copyToRoot = nix_vim;
          config.Entrypoint = ["/bin/nvim"];
        };

        docker-lazyvim = pkgs.dockerTools.buildImage {
          name = "lazyvim";
          tag = "latest";
          copyToRoot = lazy_vim;
          config.Entrypoint = ["/bin/nvim"];
        };

        docker-codevim = pkgs.dockerTools.buildImage {
          name = "codevim";
          tag = "latest";
          copyToRoot = code_vim;
          config.Entrypoint = ["/bin/nvim"];
        };
      in {
        checks = {
          # Run `nix flake check .` to verify that your config is not broken
          NixVim = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
          LazyVim = nixvimLib.check.mkTestDerivationFromNixvimModule lazyvimModule;
          CodeVim = nixvimLib.check.mkTestDerivationFromNixvimModule codevimModule;
        };
        packages = {
          # Original packages
          NixVim = nix_vim;
          LazyVim = lazy_vim;
          CodeVim = code_vim;

          # Wrapper scripts
          nixvim = nixvim-wrapper;
          lazyvim = lazyvim-wrapper;
          codevim = codevim-wrapper;
          nvim = nvim-wrapper;

          default = nixvim-wrapper;

          # Docker images
          docker-nixvim = docker-nixvim;
          docker-lazyvim = docker-lazyvim;
          docker-codevim = docker-codevim;
        };
        apps = {
          NixVim = {
            type = "app";
            program = "${nix_vim}/bin/nvim";
            meta = {
              description = "Custom NixVim configuration";
            };
          };
          LazyVim = {
            type = "app";
            program = "${lazy_vim}/bin/nvim";
            meta = {
              description = "LazyVim-based NixVim configuration";
            };
          };
          CodeVim = {
            type = "app";
            program = "${code_vim}/bin/nvim";
            meta = {
              description = "VSCode-embedded Neovim configuration";
            };
          };
        };
      };
    };
}
