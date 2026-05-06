{ ... }:

{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };
    brews = [ "gemini-cli" "gh" "mas" "supabase" ];
    casks = [
      "1password"
      "1password-cli"
      "claude"
      "claude-code"
      "coderabbit"
      "firefox"
      "google-chrome"
      "jetbrains-toolbox"
      "orbstack"
      "postman"
      "spotify"
      "wavebox"
      "yubico-authenticator"
      "zed"
      "font-fira-code-nerd-font"
    ];
  };
}
