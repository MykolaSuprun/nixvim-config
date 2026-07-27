{
  description = "A nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # Pinned separately from the main nixpkgs input: at nixpkgs-unstable (and
    # current nixos-unstable), `snowflake-cli` fails to build on aarch64-linux
    # because its `snowflake-connector-python` dependency has a unit test
    # (test_log_debug_config_file_parent_dir_permissions) that assumes it is
    # not running as root — Nix's build sandbox always runs as root, so the
    # chmod-based permission check never triggers and the test fails. This
    # pin only feeds `snowflake-cli` (see dependencies.nix); everything else
    # still comes from the main `nixpkgs` input above. Bump/drop this once
    # the fix lands upstream: https://github.com/NixOS/nixpkgs/issues (check
    # snowflake-connector-python test suite for the root-permission test).
    nixpkgs-snowflake.url = "github:nixos/nixpkgs/nixos-25.05";
    nixvim.url = "github:nix-community/nixvim";
    flake-parts.url = "github:hercules-ci/flake-parts";
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
        # nixvim-config/dependencies.nix via extraSpecialArgs.
        snowflakeCli = (import nixpkgs-snowflake {inherit system;}).snowflake-cli;

        nixvimModule = {
          inherit pkgs; # pkgs has config.allowUnfree = true
          module = import ./nixvim-config;
          extraSpecialArgs = {
            inherit snowflakeCli;
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
