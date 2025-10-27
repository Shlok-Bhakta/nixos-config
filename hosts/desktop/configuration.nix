{ pkgs, inputs, config, ... }:

let
  unstable = import ../../unstable.nix { inherit inputs pkgs; };
in
{
  imports = [
    ../shared/configuration.nix
    ./hardware-configuration.nix
  ];

  custom = {
    kanata.enable = true;
    kanata.devices = [
      "/dev/input/by-id/usb-Keychron_Keychron_K8_Pro-event-kbd"
    ];
    steam.enable = true;
  };

  hardware.opentabletdriver.enable = true;
  services.avahi.nssmdns4 = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.supportedFilesystems = [ 
    "ntfs" 
    "nfs"
    "nfs4"
  ];

  networking.hostName = "ShlokPCNIX";
  networking.networkmanager.enable = true;
  networking.firewall = { 
    enable = true;
    allowedTCPPorts = [ 
      53317
      5173
      8080
      80
      443
    ];
    allowedTCPPortRanges = [ 
      { from = 1714; to = 1764; }
    ];  
    allowedUDPPortRanges = [ 
      { from = 1714; to = 1764; }
    ];  
  };

  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  
  boot.kernelPackages = pkgs.linuxPackages_6_12;
  boot.kernelParams = [
    "initcall_blacklist=simpledrm_platform_driver_init"
    "nvidia-drm.modeset=1"
    "nvidia_drm.fbdev=1"
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau
      libvdpau-va-gl
      nvidia-vaapi-driver
      vdpauinfo
      libva
      libva-utils
    ];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  environment.sessionVariables = {
    NH_FLAKE = "/home/shlok/nixos-config";
    GBM_BACKEND = "nvidia-drm";
  };

  security.polkit.enable = true;
  security.sudo.enable = true;
  security.rtkit.enable = true;

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

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

  users.users.shlok = {
    isNormalUser = true;
    description = "Shlok Bhakta";
    extraGroups = [ "networkmanager" "wheel" "wireshark" "dialout" "uinput" "libvirtd" "input" "adbusers"];
  };
}
