{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    git-lfs
    vim
    htop
    nodejs
    corepack
    gradle
    devcontainer
    python3
    localstack
    nixd
    nixfmt-rfc-style
    gitkraken
    aseprite
  ];
}
