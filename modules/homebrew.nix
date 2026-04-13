{ ... }:

{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };
    brews = [ "mas" ];
    casks = [
      "1password"
      "1password-cli"
      "claude-code"
      "google-chrome"
      "jetbrains-toolbox"
      "orbstack"
      "wavebox"
      "yubico-authenticator"
      "zed"
      "font-fira-code-nerd-font"
    ];
  };
}
