{ unstable, ... }:
{
  programs.waybar = {
    enable = true;
    package = unstable.waybar;
  };

  xdg.configFile."waybar".source = ./.;
}
