{ config, pkgs, inputs, ... }: {

  imports = [
    ../gen-system-settings.nix 
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "ShlokPCNIX"; # Define your hostname.

  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
    displayManager.sddm = {
        enable = true;
        theme = "catppuccin-mocha";
        package = pkgs.kdePackages.sddm;
    };
    xrandrHeads = [
      {
        output = "DP-1";
        primary = true;
      }
      {
        output = "HDMI-A-1";
      }
    ];
  };


  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  environment.sessionVariables = {
    # "LIBVA_DRIVER_NAME" = "neuveau";
    # "XDG_SESSION_TYPE" = "wayland";
    "GBM_BACKEND" = "nvidia-drm";
    # "__GLX_VENDOR_LIBRARY_NAME" = "neuveau";
    # "no_hardware_cursors" = "1";
    # "WLR_NO_HARDWARE_CURSORS" = "1";
    # "NIXOS_OZONE_WL" = "1";
  };

  boot.kernelParams = [
    "initcall_blacklist=simpledrm_platform_driver_init"
    "nvidia-drm.modeset=1"
    "nvidia_drm.fbdev=1"
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];
  # https://nixos.wiki/wiki/OBS_Studio
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';
  

}
