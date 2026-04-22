{ ... }:

{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };
    brews = [ "gemini-cli" "gh" "mas" ];
    casks = [
      "1password"
      "1password-cli"
      "claude-code"
      "firefox"
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
