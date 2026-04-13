{ pkgs, ... }:

let
  # Flake path for rebuild commands
  flakePath = "/Users/isabelle/Source/Code/Personal/nix-apple";
in
{
  # ZSH as default shell
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;

    # Powerlevel10k prompt
    promptInit = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

      # Load p10k config if it exists
      [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
    '';

    interactiveShellInit = ''
      # History
      HISTSIZE=10000
      SAVEHIST=10000
      setopt SHARE_HISTORY
      setopt HIST_IGNORE_DUPS
      setopt HIST_IGNORE_SPACE

      # Aliases
      alias ll="ls -la"
      alias la="ls -A"

      # Nix rebuild aliases
      alias rebuild="sudo darwin-rebuild switch --flake ${flakePath}"
      alias rebuild-check="darwin-rebuild check --flake ${flakePath}"
      alias rebuild-dry="darwin-rebuild build --flake ${flakePath}"
      alias flake-update="nix flake update --flake ${flakePath}"

      # AI aliases
      alias ai="ai-status"
      alias ai-start="ollama-start"
      alias ai-stop="ollama-stop"
    '';
  };

  # Zsh-related packages
  environment.systemPackages = with pkgs; [
    zsh-powerlevel10k
    zsh-autosuggestions
    zsh-syntax-highlighting
  ];
}
