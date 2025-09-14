{ lib, config, pkgs, inputs, ... }:
let
  wallpaper-path = ./dotfiles/wallpaper/wallpaper.png;
  unstable = import ./unstable.nix { inherit inputs pkgs; };

in{

  # hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # package = inputs.UNSTABLE.packages."${pkgs.system}".hyprland;
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    home-manager
    pyprland
    hyprpicker
    hyprcursor
    (pkgs.discord.override {
      # remove any overrides that you don't want
      withOpenASAR = true;
      withVencord = true;
    })
    wireshark
    v4l-utils
    cudaPackages.cudatoolkit
    cudaPackages.cudnn
    (pkgs.catppuccin-sddm.override {
      flavor = "mocha";
      font  = "CaskaydiaCove Nerd Font";
      fontSize = "9";
      background = "${./dotfiles/hypr/background.png}";
      loginBackground = true;
    })
    pkgs.man-pages
    pkgs.man-pages-posix
    pkgs.cachix
    (pkgs.callPackage ./pkgs/deskthing/deskthing.nix {})
  ];

  # kanata
  services.kanata = {
    enable = true;
    package = pkgs.kanata;
    keyboards.keychron = {
      devices = [
        "/dev/input/by-id/usb-Keychron_Keychron_K8_Pro-event-kbd"
      ];
      configFile = ./dotfiles/kanata/kanata.kbd;
    };
  };

  nixpkgs.config.cudaSupport = true;
  system.stateVersion = "25.05"; 
  security.pam.services.swaylock = {};
  fonts.packages = with pkgs; [
    nerd-fonts.caskaydia-cove
    (stdenv.mkDerivation {
      name = "allura-font";
      src = ./dotfiles/customfont/allura;
      installPhase = ''
        mkdir -p $out/share/fonts/truetype
        cp $src/Allura-Regular.ttf $out/share/fonts/truetype/
      '';
    })
    (stdenv.mkDerivation {
      name = "lofty-font";
      src = ./dotfiles/customfont/lofty;
      installPhase = ''
        mkdir -p $out/share/fonts/truetype
        cp $src/LoftyGoals.otf $out/share/fonts/truetype/
      '';
    })
    times-newer-roman
    corefonts
  ];
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  # services.blueman.enable = true;
  services.tailscale = {
    enable = true;
    package = unstable.tailscale;
  };
  environment.sessionVariables = {
    # NIXOS_OZONE_WL = "1";
    # ELECTRON_OZONE_PLATFORM_HINT = "x11";
    # NVD_BACKEND = "direct";
  };
  virtualisation.docker = {
    enable = true; 
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
    daemon.settings = {
      data-root = "/home/shlok/Docker";
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" "shlok" ];
  programs.wireshark = {
    enable = true;
  };

  # Enable ADB for DeskThing device detection
  programs.adb.enable = true;

  services.avahi.enable = true;
  services.upower.enable = true;
  documentation.dev.enable = true;

  # Car Thing udev rules for flashing
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1b8e", ATTRS{idProduct}=="c003", OWNER="shlok", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1d6b", ATTRS{idProduct}=="1014", OWNER="shlok", MODE="0666"
  '';

  # Virt Manager Setup
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["shlok"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  # VirtualBox Setup because virt manager bork stuff
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "shlok" ];


}
