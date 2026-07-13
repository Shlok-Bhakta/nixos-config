{ ai-unstable, ... }:
{
  programs.opencode = {
    enable = true;

    package = ai-unstable.opencode;

    tui = {
      theme = "catppuccin";
    };
  };

  home.packages = [ ai-unstable.opencode-desktop ];

  # TODO(26.05): migrate this to `programs.opencode.skills` once available.
  xdg.configFile."opencode/skills/human-writing/SKILL.md".source = ./skills/human-writing/SKILL.md;
  xdg.configFile."opencode/skills/frontend-design/SKILL.md".source =
    ./skills/frontend-design/SKILL.md;
  xdg.configFile."opencode/skills/competitive-programming/SKILL.md".source =
    ./skills/competitive-programming/SKILL.md;
}
