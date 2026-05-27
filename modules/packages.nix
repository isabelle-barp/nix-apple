{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    git-lfs
    vim
    htop
    nodejs
    corepack
    python3
    localstack
    nixd
    nixfmt-rfc-style
    gitkraken
    aseprite
  ];
}
