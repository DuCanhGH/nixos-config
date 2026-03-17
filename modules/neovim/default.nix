{ inputs, pkgs }:
(inputs.nvf.lib.neovimConfiguration {
  inherit pkgs;
  modules = [
    ./autocomplete.nix
    ./config.nix
    ./copilot.nix
    ./formatter.nix
    ./languages.nix
    ./treesitter.nix
  ];
}).neovim
