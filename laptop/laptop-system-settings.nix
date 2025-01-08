{ config, pkgs, inputs, ... }: {

  imports = [
    ../gen-system-settings.nix 
  ];
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "ShlokLAPNIX"; # Define your hostname.

  # Enable network manager applet
  programs.nm-applet.enable = true;

  services.xserver.videoDrivers = ["nvidia"];
  # services.xserver.videoDrivers = ["neuveau"];
  services.displayManager = {
        sddm = {
        enable = true;
        wayland.enable = true;
        theme = "catppuccin-mocha";
        package = pkgs.kdePackages.sddm;
    };
    defaultSession = "hyprland";
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
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
    # "LIBVA_DRIVER_NAME" = "neuveau";
    "XDG_SESSION_TYPE" = "wayland";
    "GBM_BACKEND" = "nvidia-drm";
    # "__GLX_VENDOR_LIBRARY_NAME" = "neuveau";
    "no_hardware_cursors" = "1";
    "WLR_NO_HARDWARE_CURSORS" = "1";
    # "NIXOS_OZONE_WL" = "1";
  };
  boot.kernelParams = [
    "nvidia_drm.fbdev=1"
    # "nvidia-drm.modeset=1"
  ];
  # https://nixos.wiki/wiki/OBS_Studio
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';

}
