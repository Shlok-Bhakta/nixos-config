{ pkgs, ... }:

let
  startHyprland = pkgs.writeShellScript "start-hyprland" ''
    legacy_config="$HOME/.config/hypr/hyprland.conf"

    if [ -f "$legacy_config" ] && ${pkgs.gnugrep}/bin/grep -q "This config is a STUB" "$legacy_config"; then
      rm "$legacy_config"
    fi

    exec /etc/profiles/per-user/shlok/bin/start-hyprland
  '';
in
{
  imports = [
    ../../system/base.nix
  ];

  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  programs.nh = {
    enable = true;
    flake = "/home/shlok/nixos-config";
  };

  environment.systemPackages = with pkgs; [
    home-manager
    pyprland
    hyprpicker
    hyprcursor
  ];

  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.upower.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    openssl
    curl
    glib
    glibc
    libGL
    libGLU
    libx11
    libxcursor
    libxi
    libxrandr
    libxrender
    libxext
    libxfixes
    libxcb
    libxkbcommon
    freetype
    fontconfig
    cairo
    pango
    expat
    dbus
    nspr
    nss
    cups
    libdrm
    mesa
    alsa-lib
    at-spi2-atk
    gtk3
    fuse
    fuse3
    icu
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.trusted-users = [
    "root"
    "shlok"
  ];
  nix.settings.accept-flake-config = true;
  nix.settings.auto-optimise-store = true;

  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

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

  hardware.graphics.enable = true;

  environment.sessionVariables = {
    NH_FLAKE = "/home/shlok/nixos-config";
    NIXOS_OZONE_WL = "1";
    XDG_SESSION_TYPE = "wayland";
  };

  security.polkit.enable = true;
  security.sudo.enable = true;
  security.rtkit.enable = true;

  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --asterisks --cmd ${startHyprland}";
        user = "greeter";
      };
    };
  };

  users.users.shlok = {
    isNormalUser = true;
    description = "Shlok Bhakta";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "audio"
      "input"
    ];
  };
}
