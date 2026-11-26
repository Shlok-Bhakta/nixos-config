# Terminal. Settings live in ./config (native Ghostty format).
{ unstable, ... }:
{
  programs.ghostty = {
    enable = true;
    package = unstable.ghostty;
    enableZshIntegration = true;
    # Background instance (app-com.mitchellh.ghostty.service) so new windows
    # open instantly. Hyprland starts it, since graphical-session.target
    # never fires in this session.
    systemd.enable = true;
  };

  xdg.configFile."ghostty/config".source = ./config;

  # Terminal=true desktop entries (btop, nvim, ...) launched from GTK apps go
  # through xdg-terminal-exec; rofi has its own `terminal` setting.
  xdg.terminal-exec = {
    enable = true;
    settings.default = [ "com.mitchellh.ghostty.desktop" ];
  };
}
