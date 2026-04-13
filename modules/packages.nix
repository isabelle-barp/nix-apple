{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    vim
    htop
    nodejs
    nixd
    nixfmt-rfc-style
  ];
}
