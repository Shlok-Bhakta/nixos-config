{
  lib,
  pkgs,
  inputs,
  unstable,
  ...
}:
{
  home.username = "shlok";
  home.homeDirectory = "/home/shlok";
  home.stateVersion = lib.mkDefault "25.11";

  home.sessionVariables = {
    EDITOR = "code";
    XCURSOR_SIZE = 24;
  };

  imports = [
    inputs.ags.homeManagerModules.default
    # ./features/arrpc
    ./features/ai
    ./features/bat
    ./features/btop
    ./features/chromium
    ./features/cliphist
    ./features/dconf
    ./features/excalidraw
    ./features/eza
    ./features/git
    ./features/gitui
    ./features/gnome-keyring
    ./features/gtk
    ./features/hyprland
    ./features/kitty
    ./features/nextcloud
    ./features/obs-studio
    ./features/ripgrep
    ./features/rofi
    ./features/starship
    ./features/stylix
    ./features/swaync
    ./features/syncthing
    ./features/tmux
    ./features/udiskie
    ./features/vscode
    # ./features/walker
    ./features/wlogout
    # ./features/yazi
    ./features/zoxide
    ./features/zsh
  ];

  programs.home-manager.enable = true;
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
    inputs.swww.packages.${pkgs.stdenv.hostPlatform.system}.swww
    pkgs.cliphist
    pkgs.playerctl
    pkgs.dbus
    pkgs.wdisplays
    pkgs.wl-clipboard
    pkgs.xdg-utils
    unstable.onlyoffice-desktopeditors
    pkgs.openssl
    pkgs.bemoji
    pkgs.pear-desktop
    pkgs.nh
    pkgs.nix-output-monitor
    # pkgs.wtype
    pkgs.nodejs_22
    pkgs.ffmpeg
    pkgs.pciutils
    pkgs.udisks2
    pkgs.udiskie
    pkgs.polkit
    pkgs.polkit_gnome
    pkgs.libnotify
    pkgs.yt-dlp
    unstable.vesktop
    unstable.obsidian
    pkgs.wget
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
    pkgs.speechd
    pkgs.nautilus
    # unstable.deckmaster
    pkgs.gnome-calculator
    # pkgs.gnome-characters
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
    pkgs.hyprpicker
    unstable.annotator
    unstable.anki
    pkgs.gnome-clocks
    pkgs.fragments
    pkgs.gnome-disk-utility
    pkgs.nixfmt
    pkgs.vlc
    unstable.gnome-pomodoro
    pkgs.yt-dlg
    # pkgs.github-desktop
    pkgs.git-credential-manager
    # pkgs.rclone
    # pkgs.rclone-browser
    # unstable.immich-go
    unstable.kando
    unstable.pnpm
    pkgs.parabolic
    pkgs.libqalculate
    pkgs.wlogout
    unstable.rofi-power-menu
    pkgs.tesseract
    pkgs.pavucontrol
    pkgs.brightnessctl
    pkgs.lazygit
    unstable.bun
    pkgs.uv
    pkgs.wl-clicker
    inputs.printer-cli.packages.${pkgs.stdenv.hostPlatform.system}.default
    unstable.go
    pkgs.nmap
    pkgs.jdk25_headless
    # pkgs.ttyper
    # pkgs.kdePackages.ktouch
    # pkgs.gtypist
    pkgs.unzip
    pkgs.mprocs
    pkgs.cloudflared
    unstable.gh
    pkgs.sshpass
    # unstable.zed-editor
    pkgs.inotify-tools
  ];
}
