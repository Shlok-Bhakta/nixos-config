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

    # Expose OpenCode web on a non-standard port.
    web = {
      enable = true;
      extraArgs = [
        "--hostname"
        "0.0.0.0"
        "--port"
        "4097"
      ];
    };

    # Skill scaffolding only; SKILL.md contents can be filled in later.
    skills = {
      human-writing = ./skills/human-writing;
      frontend-design = ./skills/frontend-design;
    };
  };
}
