{ pkgs, opencode-unstable, inputs, ... }:
let

opencode-patched = inputs.opencode.packages.${pkgs.system}.opencode.overrideAttrs (old: {
        preBuild = (old.preBuild or "") + ''
          substituteInPlace packages/opencode/src/cli/cmd/generate.ts \
            --replace-fail 'const prettier = await import("prettier")' 'const prettier: any = { format: async (s: string) => s }' \
            --replace-fail 'const babel = await import("prettier/plugins/babel")' 'const babel = {}' \
            --replace-fail 'const estree = await import("prettier/plugins/estree")' 'const estree = {}'
        '';
      });
in{
  programs.opencode = {
    enable = true;

    # Use the newer unstable package instead of nixpkgs stable.
    # package = opencode-unstable.opencode;
    package = opencode-patched;

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
  xdg.configFile."opencode/skills/competitive-programming/SKILL.md".source =
    ./skills/competitive-programming/SKILL.md;
}
