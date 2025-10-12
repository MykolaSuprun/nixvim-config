{
  description = "A nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixvim.url = "github:nix-community/nixvim";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = {
    nixpkgs,
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

        nixvimModule = {
          inherit system; # or alternatively, set `pkgs`
          module = import ./nixvim-config; # import the module directly
          # You can use `extraSpecialArgs` to pass additional arguments to your module files
          extraSpecialArgs = {
            # inherit (inputs) foo;
          };
        };

        lazyvimModule = {
          inherit system; # or alternatively, set `pkgs`
          module = import ./lazyvim-config; # import the module directly
          # You can use `extraSpecialArgs` to pass additional arguments to your module files
          extraSpecialArgs = {
            # inherit (inputs) foo;
          };
        };

        nix_vim = nixvim'.makeNixvimWithModule nixvimModule;
        lazy_vim = nixvim'.makeNixvimWithModule lazyvimModule;

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
      in {
        checks = {
          # Run `nix flake check .` to verify that your config is not broken
          NixVim = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
          LazyVim = nixvimLib.check.mkTestDerivationFromNixvimModule lazyvimModule;
        };
        packages = {
          # Original packages
          NixVim = nix_vim;
          LazyVim = lazy_vim;

          # Wrapper scripts
          nixvim = nixvim-wrapper;
          lazyvim = lazyvim-wrapper;
          nvim = nvim-wrapper;

          default = nixvim-wrapper;
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
        };
      };
    };
}
