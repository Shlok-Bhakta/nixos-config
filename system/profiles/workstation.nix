{
  pkgs,
  config,
  ...
}:

{
  imports = [
    ../features/docker
    ../features/sunshine
  ];

  environment.systemPackages = with pkgs; [
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
    wireshark
    v4l-utils
    man-pages
    man-pages-posix
    android-tools
    cachix
    (callPackage ../../pkgs/deskthing/deskthing.nix { })
  ];

  documentation.dev.enable = true;

  hardware.graphics.enable32Bit = true;

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", MODE="0666", GROUP="users"
    KERNEL=="lp[0-9]*", MODE="0666", GROUP="users"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666"
  '';

  networking.firewall = {
    allowedTCPPorts = [
      53317
      5173
      8080
      80
      443
      8081
      3000
      3001
      3002
      3773
      8082
      8083
    ];
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
  };

  boot.kernelPackages = pkgs.linuxPackages_6_12;
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.extraModprobeConfig = ''
    options kvm ignore_msrs=1 report_ignored_msrs=0
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';

  services.printing.enable = true;
  services.avahi.nssmdns4 = true;

  services.pipewire.alsa.support32Bit = true;

  users.users.shlok.extraGroups = [
    "wireshark"
    "dialout"
    "uinput"
    "libvirtd"
    "adbusers"
  ];
}
