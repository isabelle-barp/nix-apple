{ ... }:

{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      # Homebrew 4.7+ rejects `brew bundle --cleanup` without an explicit
      # force flag; this nix-darwin rev doesn't add one. Required for `zap`.
      extraFlags = [ "--force-cleanup" ];
    };
    taps = [ "jetbrains/utils" "mongodb/brew" ];
    brews = [ "gemini-cli" "gh" "mas" "supabase" "jetbrains/utils/qodana" "mongodb/brew/mongodb-community" ];
    casks = [
      "1password"
      "1password-cli"
      "antigravity"
      "betterdisplay"
      "claude"
      "claude-code"
      "coderabbit"
      "cursor"
      "firefox"
      "godot"
      "google-chrome"
      "jetbrains-toolbox"
      "lapce"
      "mongodb-compass"
      "openwebstart"
      "orbstack"
      "postman"
      "spotify"
      "wavebox"
      "unity-hub"
      "visual-studio-code"
      "yubico-authenticator"
      "zed"
      "font-fira-code-nerd-font"
    ];
  };
}
