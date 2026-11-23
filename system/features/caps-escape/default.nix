{ ... }:
{
  # Evdev-level remap so Caps Lock is Escape in TTY, Hyprland, and Xwayland.
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings.main.capslock = "esc";
    };
  };

  services.xserver.xkb = {
    layout = "us";
    options = "caps:escape";
  };
  console.useXkbConfig = true;
}
