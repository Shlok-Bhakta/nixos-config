{ pkgs, config, ... }:

{
  imports = [
    ../shared/configuration.nix
    ./hardware-configuration.nix
    ../../modules/system/power-profiles
  ];

  custom = {
    kanata.enable = false;
    steam.enable = false;
    power-profiles.enable = true;
  };

  fonts.fontconfig.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "ShlokLAPNIX";

  programs.nm-applet.enable = true;

  boot.kernelParams = [
    "nvidia_drm.fbdev=1"
  ];

  hardware.nvidia = {
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  environment.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    no_hardware_cursors = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    CUDA_PATH = "${pkgs.cudaPackages.cudatoolkit}";
  };

  services.displayManager.defaultSession = "hyprland";
}
