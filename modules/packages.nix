{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    vim
    htop
    nodejs
    pnpm
    nixd
    nixfmt-rfc-style
  ];
}
