{ pkgs, inputs, config, ... }:

let
  unstable = import ../../unstable.nix { inherit inputs pkgs; };
in
{
  imports = [
    ../../modules/system/bluetooth
    ../../modules/system/docker
    ../../modules/system/fonts
    ../../modules/system/hyprland
    ../../modules/system/kanata
    ../../modules/system/networking
    ../../modules/system/nix-serve
    ../../modules/system/steam
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.cudaSupport = true;

  custom = {
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
    docker.enable = true;
    docker.dataRoot = "/home/shlok/Docker";
    fonts.enable = true;
    hyprland.enable = true;
    networking.enableTailscale = true;
    networking.enableAvahi = true;
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    home-manager
    pyprland
    hyprpicker
    hyprcursor
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
    wireshark
    v4l-utils
    cudaPackages.cudatoolkit
    cudaPackages.cudnn

    man-pages
    man-pages-posix
    cachix
    (callPackage ../../pkgs/deskthing/deskthing.nix {})
  ];

  system.stateVersion = "25.11";
  security.pam.services.swaylock = {};

  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.upower.enable = true;
  documentation.dev.enable = true;

  programs.adb.enable = true;

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", MODE="0666", GROUP="users"
    KERNEL=="lp[0-9]*", MODE="0666", GROUP="users"
  '';

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.trusted-users = [
    "root"
    "shlok"
  ];
  nix.settings.accept-flake-config = true;

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
      libva-vdpau-driver
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
  };

  environment.sessionVariables = {
    NH_FLAKE = "/home/shlok/nixos-config";
    GBM_BACKEND = "nvidia-drm";
  };

  security.polkit.enable = true;
  security.sudo.enable = true;
  security.rtkit.enable = true;

  services.printing.enable = true;
  services.avahi.nssmdns4 = true;

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
  };

  services.displayManager.sddm = let
    sddmTheme = pkgs.catppuccin-sddm.override {
      flavor = "mocha";
      font = "CaskaydiaCove Nerd Font";
      fontSize = "9";
      background = "${../../modules/home/hyprland/background.png}";
      loginBackground = true;
    };
  in {
    enable = true;
    wayland.enable = true;
    theme = "${sddmTheme}/share/sddm/themes/catppuccin-mocha-mauve";
    package = pkgs.kdePackages.sddm;
  };

  users.users.shlok = {
    isNormalUser = true;
    description = "Shlok Bhakta";
    extraGroups = [ "networkmanager" "wheel" "wireshark" "dialout" "uinput" "libvirtd" "input" "adbusers"];
  };
}
