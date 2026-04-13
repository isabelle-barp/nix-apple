# nix-apple - How to Use

Mac Studio system configuration managed by nix-darwin.

## First-Time Setup

```bash
# Apply the system configuration
sudo darwin-rebuild switch --flake /Users/isabelle/Source/Code/Personal/nix-apple

# Set up AI models (pulls hermes3:8b)
ai-setup

# Set up CHLOE agent (onboarding wizard)
chloe-setup
```

## System Aliases

### Nix Rebuild

| Alias | Command |
|-------|---------|
| `rebuild` | Apply system configuration (`sudo darwin-rebuild switch`) |
| `rebuild-check` | Check configuration for errors |
| `rebuild-dry` | Build without activating |
| `flake-update` | Update all flake inputs |

### Shell

| Alias | Command |
|-------|---------|
| `ll` | `ls -la` |
| `la` | `ls -A` |

### AI

| Alias | Command |
|-------|---------|
| `ai` | Show status of all AI services |
| `ai-start` | Start Ollama |
| `ai-stop` | Stop Ollama |

## AI Commands

### Ollama

| Command | Description |
|---------|-------------|
| `ollama-start` | Start Ollama and wait until ready (up to 30s) |
| `ollama-stop` | Stop Ollama |
| `ai-setup` | Start Ollama and pull all required models |
| `ai-status` | Show status of Ollama, CHLOE, and config |
| `ollama list` | List downloaded models |
| `ollama pull <model>` | Download a model |
| `ollama run <model>` | Chat with a model directly |

### CHLOE (IronClaw Agent)

| Command | Description |
|---------|-------------|
| `chloe` | Start CHLOE (auto-starts Ollama if needed) |
| `chloe-setup` | First-time onboarding wizard |
| `chloe-build` | Rebuild CHLOE from source (in nix dev shell) |
| `chloe-update` | Pull latest IronClaw changes and rebuild |

## Installed Packages

### Via Nix

- `git` - Version control
- `vim` - Text editor
- `htop` - Process monitor
- `zsh-powerlevel10k` - Zsh prompt theme
- `zsh-autosuggestions` - Zsh autosuggestions
- `zsh-syntax-highlighting` - Zsh syntax highlighting
- `nixd` - Nix language server (LSP)
- `nixfmt-rfc-style` - Nix code formatter

### Via Homebrew (Casks)

- `claude-code` - Claude Code CLI
- `orbstack` - Docker/Linux VM runtime
- `zed` - Code editor (Rust-based, fast)
- `ollama-app` - Local LLM inference (Metal GPU)
- `font-fira-code-nerd-font` - Nerd Font for terminal

### Via Homebrew (Formulae)

- `mas` - Mac App Store CLI

## Configuration Files

| File | Purpose |
|------|---------|
| `~/.ironclaw/.env` | CHLOE agent config (model, database, name) |
| `~/.p10k.zsh` | Powerlevel10k prompt config |
| `~/Library/Application Support/Zed/settings.json` | Zed editor settings |
| `~/Source/Code/Personal/nix-apple/` | Nix system configuration |
| `~/Source/Code/Personal/iron-chloe/` | IronClaw source code |

## Project Structure

```
nix-apple/
├── flake.nix              # Flake entrypoint
├── flake.lock             # Locked dependencies
├── hosts/
│   └── mac-studio/
│       └── default.nix    # Host-specific config
├── modules/
│   ├── ai.nix             # Ollama + CHLOE scripts
│   ├── homebrew.nix       # Homebrew casks and formulae
│   ├── packages.nix       # Nix packages
│   ├── shell.nix          # Zsh config and aliases
│   └── system.nix         # macOS system settings
└── docker/
    └── open-webui/
        └── docker-compose.yml
```
