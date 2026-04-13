{ pkgs, ... }:

{
  imports = [
    ../../modules/packages.nix
    ../../modules/homebrew.nix
    ../../modules/system.nix
    ../../modules/ai.nix
    ../../modules/shell.nix
  ];

  system.primaryUser = "isabelle";

  ids.gids.nixbld = 350;
  system.stateVersion = 4;
}
