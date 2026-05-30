{ pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "aseprite"
    "gitkraken"
  ];

  imports = [
    ../../modules/packages.nix
    ../../modules/homebrew.nix
    ../../modules/system.nix
    ../../modules/ai.nix
    ../../modules/shell.nix
    ../../modules/spotlight.nix
  ];

  system.primaryUser = "isabelle";

  ids.gids.nixbld = 350;
  system.stateVersion = 4;
}
