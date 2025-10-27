{ pkgs, inputs, ... }:

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
    ../../modules/system/steam
  ];

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

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.cudaSupport = true;

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
    (catppuccin-sddm.override {
      flavor = "mocha";
      font = "CaskaydiaCove Nerd Font";
      fontSize = "9";
      background = "${../../modules/home/hyprland/background.png}";
      loginBackground = true;
    })
    man-pages
    man-pages-posix
    cachix
    (callPackage ../../pkgs/deskthing/deskthing.nix {})
  ];

  system.stateVersion = "25.05";
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
}
