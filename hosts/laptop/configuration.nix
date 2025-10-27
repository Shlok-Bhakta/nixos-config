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
    kanata.enable = false;
    steam.enable = false;
  };

  fonts.fontconfig.enable = true;
  services.avahi.nssmdns4 = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "ShlokLAPNIX";
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

  programs.nm-applet.enable = true;

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
    "nvidia_drm.fbdev=1"
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
    NH_FLAKE = "/home/shlok/nixos-config";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    no_hardware_cursors = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    CUDA_PATH = "${pkgs.cudaPackages.cudatoolkit}";
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

  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      theme = "catppuccin-mocha";
      package = pkgs.kdePackages.sddm;
    };
    defaultSession = "hyprland";
  };

  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
  };

  users.users.shlok = {
    isNormalUser = true;
    description = "Shlok Bhakta";
    extraGroups = [ "networkmanager" "wheel" "wireshark" "dialout" "uinput" "libvirtd" "input" "adbusers"];
  };
}
