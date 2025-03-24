{
  description = "A nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = {
    nixvim,
    flake-parts,
    ...
  } @ inputs: let
    config = import ./config {nvim-mode = "nvim";}; # import the module directly
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem = { pkgs, system, ... }:
        let
          nixvimLib = nixvim.lib.${system};
          nixvim' = nixvim.legacyPackages.${system};
          nvim = nixvim'.makeNixvimWithModule {
            pkgs = pkgs;
            module = config;
            # You can use `extraSpecialArgs` to pass additional arguments to your module files
            extraSpecialArgs = { inherit (inputs) outputs; };
          };
        in {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              (final: prev: {
                treesitter-nu-grammar-src = prev.fetchFromGitHub {
                  owner = "nushell";
                  repo = "tree-sitter-nu";
                  rev = "1561a947a5505d373e11ca337898e048ac2e389e";
                  hash = "sha256-RAAMBVov4q8b8MJZVlf1qwbLK8hE5AxPK1IV9TMCrTs=";
                };
              })
              (final: prev: {
                treesitter-nu-grammar = prev.tree-sitter.buildGrammar {
                  language = "nu";
                  version = "1561a947a5505d373e11ca337898e048ac2e389e";
                  src = prev.treesitter-nu-grammar-src;
                  meta.homepage = "https://github.com/nushell/tree-sitter-nu";
                };
              })
              # ./overlays/treesitter-nu-grammar.nix
            ];
            config = { };
          };

          checks = {
            # Run `nix flake check .` to verify that your config is not broken
            default = nixvimLib.check.mkTestDerivationFromNvim {
              inherit nvim;
              name = "A nixvim configuration";
            };
          };

          packages = {
            # Lets you run `nix run .` to start nixvim
            default = nvim;
          };
        };
    };
}
