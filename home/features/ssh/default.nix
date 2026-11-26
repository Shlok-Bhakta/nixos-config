# SSH mesh aliases (mirrors the `ssh` skill in ~/.agents) and the shared
# agents/skills checkout.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  home = config.home.homeDirectory;
  agentsDir = "${home}/.agents";

  meshHost = hostname: user: {
    inherit hostname user;
    identityFile = "~/.ssh/id_ed25519";
    identitiesOnly = true;
    extraOptions.StrictHostKeyChecking = "accept-new";
  };
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "*" = {
        addKeysToAgent = "yes";
        serverAliveInterval = 30;
        serverAliveCountMax = 4;
      };

      # Tailscale hosts.
      "macbook shloks-macbook-air" = meshHost "100.126.23.125" "shlok";
      "crabcake" = meshHost "100.100.163.102" "crabcake";
      "kiwi" = meshHost "100.88.30.127" "shlok";
      "thinkpad shlokthinkpad" = meshHost "100.111.119.76" "shlok";

      # Steam Deck (SteamOS). Tailscale SSH is off on it (the tailnet ACL puts
      # Tailscale SSH in browser-check mode), so this hits the Deck's sshd.
      "deck steamdeck" = meshHost "100.105.213.9" "deck";

      # Homelab VMs (Tailscale addresses; taco's LAN SSH times out).
      "salsa" = meshHost "100.66.170.31" "shlok";
      "taco" = meshHost "100.92.93.154" "shlok";

      # Proxmox lives on 10.11.0.0/22, which only crabcake routes. Its
      # Tailscale address triggers a separate Tailscale SSH approval flow.
      "proxmox" = meshHost "10.11.1.240" "root" // {
        proxyJump = "crabcake";
      };
    };
  };

  # Clone the shared skills repo and point Claude Code at it, the same way
  # crabcake is set up (~/.claude/skills -> ~/.agents/skills).
  home.activation.agentsRepo = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export PATH=${
      lib.makeBinPath [
        pkgs.git
        pkgs.openssh
        pkgs.coreutils
      ]
    }:$PATH

    if [ ! -d ${agentsDir}/.git ]; then
      run git clone \
        --config core.sshCommand="ssh -i ${home}/.ssh/id_ed25519 -o IdentitiesOnly=yes -o BatchMode=yes -o StrictHostKeyChecking=accept-new" \
        git@github.com:Shlok-Bhakta/agents.git ${agentsDir} \
        || warnEcho "Could not clone Shlok-Bhakta/agents into ${agentsDir}; skipping skills link."
    fi

    if [ -d ${agentsDir}/skills ]; then
      skills=${home}/.claude/skills
      run mkdir -p ${home}/.claude
      if [ -d "$skills" ] && [ ! -L "$skills" ]; then
        # Keep any machine-local skills (e.g. synced/) by moving them into
        # the checkout; they're gitignored there.
        for entry in "$skills"/* "$skills"/.[!.]*; do
          [ -e "$entry" ] || continue
          name=$(basename "$entry")
          if [ ! -e ${agentsDir}/skills/"$name" ]; then
            run mv "$entry" ${agentsDir}/skills/"$name"
          fi
        done
        run rmdir "$skills" 2>/dev/null || run mv "$skills" "$skills.old"
      fi
      if [ ! -e "$skills" ]; then
        run ln -s ${agentsDir}/skills "$skills"
      fi
    fi
  '';
}
