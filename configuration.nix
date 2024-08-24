{ lib, config, pkgs, inputs, ... }:
let
  wallpaper-path = /home/shlok/nixos-config/dotfiles/wallpaper/wallpaper.png;
  unstable = inputs.UNSTABLE.legacyPackages.${pkgs.system};
in{
  # imports = [
  #   inputs.home-manager.nixosModules.home-manager
  # ];
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
    vesktop
    wireshark
    v4l-utils
  ];

  system.stateVersion = "24.05"; 
  security.pam.services.swaylock = {};
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
  ];

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
  programs.wireshark = {
    enable = true;
  };
}
