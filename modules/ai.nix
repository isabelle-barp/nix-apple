{ pkgs, ... }:

let
  ironclawBin = "/Users/isabelle/Source/Code/Personal/iron-chloe/target/release/ironclaw";
  ironclawSrc = "/Users/isabelle/Source/Code/Personal/iron-chloe";
in
{
  # Ollama for local LLM inference (uses Metal GPU acceleration)
  homebrew.casks = [
    "ollama-app"
  ];

  environment.systemPackages = [
    # Start Ollama and wait until it's ready
    (pkgs.writeShellScriptBin "ollama-start" ''
      if pgrep -x "ollama" > /dev/null; then
        echo "Ollama is already running."
        exit 0
      fi

      echo "Starting Ollama..."
      open -a Ollama

      for i in $(seq 1 30); do
        if curl -s http://localhost:11434 > /dev/null 2>&1; then
          echo "Ollama is ready."
          exit 0
        fi
        sleep 1
      done

      echo "ERROR: Ollama failed to start after 30 seconds."
      exit 1
    '')

    # Stop Ollama
    (pkgs.writeShellScriptBin "ollama-stop" ''
      if ! pgrep -x "ollama" > /dev/null; then
        echo "Ollama is not running."
        exit 0
      fi

      echo "Stopping Ollama..."
      pkill -x "Ollama" 2>/dev/null
      pkill -x "ollama" 2>/dev/null
      echo "Ollama stopped."
    '')

    # Pull all required models
    (pkgs.writeShellScriptBin "ai-setup" ''
      echo "==> Ensuring Ollama is running..."
      ollama-start || exit 1

      echo ""
      echo "==> Pulling Hermes 3 8B model..."
      ollama pull hermes3:8b

      echo ""
      echo "==> Available models:"
      ollama list
    '')

    # Start CHLOE interactive (CLI mode)
    (pkgs.writeShellScriptBin "chloe" ''
      # Ensure Ollama is running first
      if ! curl -s http://localhost:11434 > /dev/null 2>&1; then
        echo "Starting Ollama first..."
        ollama-start || exit 1
        echo ""
      fi

      exec ${ironclawBin} --cli-only "$@"
    '')

    # Install CHLOE as a background service (launchd)
    (pkgs.writeShellScriptBin "chloe-service-install" ''
      # Ensure Ollama is running first
      if ! curl -s http://localhost:11434 > /dev/null 2>&1; then
        echo "Starting Ollama first..."
        ollama-start || exit 1
        echo ""
      fi

      echo "==> Installing CHLOE as a background service..."
      ${ironclawBin} service install
      ${ironclawBin} service start
      echo ""
      ${ironclawBin} service status
    '')

    # Start CHLOE background service
    (pkgs.writeShellScriptBin "chloe-start" ''
      # Ensure Ollama is running first
      if ! curl -s http://localhost:11434 > /dev/null 2>&1; then
        echo "Starting Ollama first..."
        ollama-start || exit 1
        echo ""
      fi

      ${ironclawBin} service start
      ${ironclawBin} service status
    '')

    # Stop CHLOE background service
    (pkgs.writeShellScriptBin "chloe-stop" ''
      ${ironclawBin} service stop
    '')

    # Show CHLOE service status
    (pkgs.writeShellScriptBin "chloe-status" ''
      ${ironclawBin} service status
    '')

    # View CHLOE logs
    (pkgs.writeShellScriptBin "chloe-logs" ''
      ${ironclawBin} logs "$@"
    '')

    # Run CHLOE onboarding
    (pkgs.writeShellScriptBin "chloe-setup" ''
      echo "==> Setting up CHLOE (IronClaw agent)..."
      echo ""

      # Ensure Ollama is running
      ollama-start || exit 1
      echo ""

      # Ensure model is pulled
      if ! ollama list 2>/dev/null | grep -q "hermes3:8b"; then
        echo "==> Pulling hermes3:8b model..."
        ollama pull hermes3:8b
        echo ""
      fi

      # Run onboarding
      echo "==> Running IronClaw onboarding..."
      ${ironclawBin} onboard
    '')

    # Rebuild CHLOE from source
    (pkgs.writeShellScriptBin "chloe-build" ''
      echo "==> Building CHLOE from source..."
      cd ${ironclawSrc}
      nix --extra-experimental-features "nix-command flakes" develop --command bash -c "cargo build --release 2>&1"
      if [ $? -eq 0 ]; then
        echo ""
        echo "==> Build complete!"
        echo "    Binary: ${ironclawBin}"
        ${ironclawBin} --version 2>/dev/null || true
      else
        echo ""
        echo "ERROR: Build failed."
        exit 1
      fi
    '')

    # Update CHLOE (git pull + rebuild)
    (pkgs.writeShellScriptBin "chloe-update" ''
      echo "==> Updating CHLOE..."
      cd ${ironclawSrc}

      echo "==> Pulling latest changes..."
      git pull --ff-only || { echo "ERROR: git pull failed"; exit 1; }

      echo ""
      chloe-build
    '')

    # Show status of all AI services
    (pkgs.writeShellScriptBin "ai-status" ''
      echo "=== AI Services Status ==="
      echo ""

      # Ollama
      if curl -s http://localhost:11434 > /dev/null 2>&1; then
        echo "Ollama:  RUNNING"
        echo "Models:"
        ollama list 2>/dev/null | sed 's/^/  /'
      else
        echo "Ollama:  STOPPED"
      fi

      echo ""

      # CHLOE binary
      if [ -x ${ironclawBin} ]; then
        echo "CHLOE:   INSTALLED ($(${ironclawBin} --version 2>/dev/null || echo 'unknown version'))"
      else
        echo "CHLOE:   NOT BUILT (run chloe-build)"
      fi

      echo ""

      # Config
      if [ -f ~/.ironclaw/.env ]; then
        echo "Config:  ~/.ironclaw/.env"
        grep -E "^(AGENT_NAME|OLLAMA_MODEL|LLM_BACKEND|DATABASE_BACKEND)" ~/.ironclaw/.env | sed 's/^/  /'
      else
        echo "Config:  NOT FOUND (run chloe-setup)"
      fi

      echo ""

      # Playwright MCP
      if [ -f ~/.ironclaw/mcp-servers.json ] && grep -q "playwright" ~/.ironclaw/mcp-servers.json 2>/dev/null; then
        echo "Playwright MCP: CONFIGURED"
      else
        echo "Playwright MCP: NOT CONFIGURED (run playwright-setup)"
      fi
    '')

    # Install and configure Playwright MCP for CHLOE
    (pkgs.writeShellScriptBin "playwright-setup" ''
      echo "==> Setting up Playwright MCP for CHLOE..."
      echo ""

      # Install @playwright/mcp globally
      echo "==> Installing @playwright/mcp..."
      npm install -g @playwright/mcp@latest

      echo ""
      echo "==> Playwright MCP installed."
      echo "    CHLOE will launch it automatically when browser tools are needed."
      echo ""
      echo "    To test manually: npx @playwright/mcp@latest --browser chrome"
    '')
  ];
}
