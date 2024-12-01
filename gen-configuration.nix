{ lib, config, pkgs, inputs, ... }:
let
  wallpaper-path = /home/shlok/nixos-config/dotfiles/wallpaper/wallpaper.png;
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
      background = "${/home/shlok/nixos-config/dotfiles/hypr/background.png}";
      loginBackground = true;
    })
    pkgs.man-pages
    pkgs.man-pages-posix
    pkgs.cachix
  ];

  # kanata
  services.kanata = {
    enable = true;
    package = pkgs.kanata;
    keyboards.keychron = {
      devices = [
        "/dev/input/by-id/usb-Keychron_Keychron_K8_Pro-event-kbd"
      ];
      configFile = /home/shlok/nixos-config/dotfiles/kanata/kanata.kbd;
    };
  };

  nixpkgs.config.cudaSupport = true;
  system.stateVersion = "24.05"; 
  security.pam.services.swaylock = {};
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
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
    NIXOS_OZONE_WL = "1";
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

  services.avahi.enable = true;
  services.upower.enable = true;

  # systemd.user.services.kdeconnect-indicator = {
  #   description = "KDE Connect Indicator";
  #   wantedBy = [ "graphical-session.target" ];
  #   partOf = [ "graphical-session.target" ];
  #   serviceConfig = {
  #     ExecStart = "${pkgs.kdeconnect}/bin/kdeconnect-indicator";
  #     Restart = "on-failure";
  #   };
  # };
  documentation.dev.enable = true;
}
