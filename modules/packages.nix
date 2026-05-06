{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    vim
    htop
    nodejs
    corepack
    localstack
    pnpm
    nixd
    nixfmt-rfc-style
  ];
}
