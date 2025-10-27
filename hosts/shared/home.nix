{ lib, config, inputs, pkgs, mynvf, ... }:

let
  unstable = import ../../unstable.nix { inherit inputs pkgs; };
in
{
  home.username = "shlok";
  home.homeDirectory = "/home/shlok";
  home.stateVersion = "25.05";

  home.sessionVariables = {
    EDITOR = "code";
    XCURSOR_SIZE = 24;
  };

  imports = [
    inputs.ags.homeManagerModules.default
    ../../modules/home/bat
    ../../modules/home/btop
    ../../modules/home/chromium
    ../../modules/home/eza
    ../../modules/home/fuzzel
    ../../modules/home/git
    ../../modules/home/gitui
    ../../modules/home/hyprland
    ../../modules/home/kitty
    ../../modules/home/obs-studio
    ../../modules/home/ripgrep
    ../../modules/home/rofi
    ../../modules/home/starship
    ../../modules/home/stylix
    ../../modules/home/swaync
    ../../modules/home/tmux
    ../../modules/home/vscode
    ../../modules/home/walker
    ../../modules/home/wallpapers
    ../../modules/home/waybar
    ../../modules/home/wlogout
    ../../modules/home/yazi
    ../../modules/home/zoxide
    ../../modules/home/zsh
  ];

  custom = {
    hyprland.enable = true;
    stylix.enable = true;
    swaync.enable = true;
    waybar.enable = true;
    wlogout.enable = true;
  };

  programs.home-manager.enable = true;

  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    tray = "auto";
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "candy-icons";
    };
    gtk3.bookmarks = [
      "file:///home/shlok/Documents/"
      "file:///home/shlok/Downloads/"
      "file:///home/shlok/Documents/Programming/"
      "file:///home/shlok/Sync"
      "file:///home/shlok/Obsidian"
    ];
  };

  services.syncthing = {
    enable = true;
  };

  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };

  services.gnome-keyring = {
    enable = true;
    components = [
      "secrets"
    ];
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      icon-theme = "candy-icons";
    };
    "org/gnome/nautilus/preferences" = {
      show-hidden-files = true;
    };
    "org/gnome/calculator" = {
      show-thousands = true;
      base = 10;
      word-size = lib.hm.gvariant.mkUint32 64;
    };
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  services.cliphist = {
    enable = true;
    allowImages = true;
  };

  services.arrpc = {
    enable = true;
  };

  home.packages = [
    pkgs.lolcat
    pkgs.direnv
    pkgs.python313
    pkgs.cmatrix
    pkgs.cbonsai
    pkgs.fastfetch
    pkgs.cowsay
    pkgs.fzf
    unstable.p7zip
    unstable.localsend
    inputs.swww.packages.${pkgs.system}.swww
    pkgs.cliphist
    pkgs.playerctl
    pkgs.dbus
    pkgs.wl-clipboard
    unstable.onlyoffice-bin
    pkgs.openssl
    pkgs.bemoji
    pkgs.youtube-music
    pkgs.nh
    pkgs.nix-output-monitor
    pkgs.wtype
    pkgs.nodejs_22
    pkgs.nvidia-vaapi-driver
    pkgs.ffmpeg
    unstable.openai-whisper-cpp
    unstable.nvtopPackages.panthor
    unstable.egl-wayland
    pkgs.pciutils
    pkgs.udisks2
    pkgs.udiskie
    pkgs.polkit
    pkgs.polkit_gnome
    pkgs.libnotify
    pkgs.yt-dlp
    unstable.docker-compose
    unstable.vesktop
    unstable.obsidian
    pkgs.wget
    inputs.zen-browser.packages."${pkgs.system}".default
    inputs.yapper.packages."${pkgs.system}".default
    pkgs.speechd
    pkgs.nautilus
    unstable.deckmaster
    pkgs.gnome-calculator
    pkgs.gnome-characters
    pkgs.apostrophe
    pkgs.impression
    pkgs.textpieces
    pkgs.candy-icons
    pkgs.gnome-themes-extra
    pkgs.dust
    pkgs.ripgrep
    pkgs.gcc
    pkgs.gnumake
    pkgs.libgccjit
    unstable.hyprshot
    unstable.annotator
    unstable.anki
    pkgs.gnome-clocks
    pkgs.fragments
    pkgs.gnome-disk-utility
    pkgs.nixfmt-rfc-style
    pkgs.vlc
    unstable.gnome-pomodoro
    pkgs.yt-dlg
    pkgs.github-desktop
    pkgs.git-credential-manager
    pkgs.rclone
    pkgs.rclone-browser
    unstable.immich-go
    unstable.kando
    unstable.nodePackages_latest.pnpm
    pkgs.parabolic
    pkgs.libqalculate
    pkgs.wlogout
    unstable.rofi-power-menu
    pkgs.tesseract
    pkgs.pavucontrol
    mynvf.neovim
    pkgs.brightnessctl
    pkgs.lazygit
    unstable.bun
    unstable.claude-code
    pkgs.uv
    pkgs.wl-clicker
    unstable.crush
    inputs.opencode.packages.${pkgs.system}.default
    inputs.printer-cli.packages.${pkgs.system}.default
  ];
}
