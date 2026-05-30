{ config, lib, pkgs, ... }:

let
  user = "isabelle";
  home = "/Users/${user}";

  # Per-directory exclusions via .metadata_never_index markers.
  # Spotlight skips the entire subtree below any directory containing this file.
  excludePaths = [
    # Nix (user-level symlink farms; the /nix volume itself is handled below)
    "${home}/.nix-defexpr"
    "${home}/.nix-profile"

    # Claude Code state
    "${home}/.claude"

    # Developer caches
    "${home}/.cache"
    "${home}/Library/Caches"
    "${home}/.npm"
    "${home}/.local"

    # Tool configs
    "${home}/.config"
    "${home}/.gemini"

    # Source trees
    "${home}/Source"

    # OrbStack (VM/container data)
    "${home}/.orbstack"
    "${home}/OrbStack"

    # Postman (legacy path + current Application Support path)
    "${home}/Postman"
    "${home}/Library/Application Support/Postman"
  ];

  # Whole-volume exclusions via `mdutil -i off`.
  # Only valid for paths that are their own APFS volume.
  excludeVolumes = [
    "/nix"
  ];

  # Hash the exclusion set so we force a reindex only when it actually changes,
  # not on every darwin-rebuild switch.
  configHash = builtins.hashString "sha256"
    (builtins.toJSON { inherit excludePaths excludeVolumes; });

  stateFile = "/var/db/spotlight-exclusions-nix.hash";
in
{
  system.activationScripts.postActivation.text = lib.mkAfter ''
    echo "[spotlight] applying exclusions" >&2

    ${lib.concatMapStringsSep "\n" (vol: ''
      if [ -d "${vol}" ]; then
        /usr/bin/mdutil -i off "${vol}" >/dev/null 2>&1 || true
      fi
    '') excludeVolumes}

    ${lib.concatMapStringsSep "\n" (path: ''
      if [ -d "${path}" ]; then
        /usr/bin/touch "${path}/.metadata_never_index"
        /usr/sbin/chown ${user}:staff "${path}/.metadata_never_index" 2>/dev/null || true
      fi
    '') excludePaths}

    mkdir -p "$(dirname '${stateFile}')"
    prev_hash="$(cat '${stateFile}' 2>/dev/null || echo none)"
    if [ "$prev_hash" != "${configHash}" ]; then
      echo "[spotlight] exclusion set changed, erasing index on /" >&2
      /usr/bin/mdutil -E / >/dev/null 2>&1 || true
      echo "${configHash}" > '${stateFile}'
    else
      echo "[spotlight] exclusion set unchanged, skipping reindex" >&2
    fi
  '';
}
