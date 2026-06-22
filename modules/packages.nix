{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    git-lfs
    vim
    htop
    nodejs
    corepack
    jdk11
    devcontainer
    python3
    localstack
    nixd
    nixfmt-rfc-style
    gitkraken
    aseprite
  ];
}
