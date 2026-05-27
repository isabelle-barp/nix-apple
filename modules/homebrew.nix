{ ... }:

{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };
    taps = [ "jetbrains/utils" ];
    brews = [ "gemini-cli" "gh" "mas" "supabase" "jetbrains/utils/qodana" ];
    casks = [
      "1password"
      "1password-cli"
      "betterdisplay"
      "claude"
      "claude-code"
      "coderabbit"
      "firefox"
      "godot"
      "google-chrome"
      "jetbrains-toolbox"
      "orbstack"
      "postman"
      "spotify"
      "wavebox"
      "unity-hub"
      "yubico-authenticator"
      "zed"
      "font-fira-code-nerd-font"
    ];
  };
}
