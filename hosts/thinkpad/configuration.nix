{
  imports = [
    ../shared/configuration.nix
    ./hardware-configuration.nix
    ../../system/profiles/thinkpad.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-8831e440-bd59-4465-b1fe-af738d91cab2".device =
    "/dev/disk/by-uuid/8831e440-bd59-4465-b1fe-af738d91cab2";

  networking.hostName = "shlokthinkpad";
  programs.nm-applet.enable = true;

  system.stateVersion = "26.05";
}
