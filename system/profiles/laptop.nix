# Common to every laptop. Hardware specifics live in the host or in thinkpad.nix.
{ ... }:

{
  programs.nm-applet.enable = true;

  services.thermald.enable = true;
  services.fstrim.enable = true;
  services.fwupd.enable = true;
}
