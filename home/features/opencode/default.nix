{ opencode-unstable, ... }:
{
  programs.opencode = {
    enable = true;

    # Use the newer unstable package instead of nixpkgs stable.
    package = opencode-unstable.opencode;

    # This writes to ~/.config/opencode/opencode.json.
    settings = {
      theme = "catppuccin";
    };

  };

  # Keep desktop app and CLI in sync from the same unstable source.
  home.packages = [ opencode-unstable.opencode-desktop ];

  # TODO(26.05): migrate this to `programs.opencode.skills` once available.
  xdg.configFile."opencode/skills/human-writing/SKILL.md".source = ./skills/human-writing/SKILL.md;
  xdg.configFile."opencode/skills/frontend-design/SKILL.md".source =
    ./skills/frontend-design/SKILL.md;
}
