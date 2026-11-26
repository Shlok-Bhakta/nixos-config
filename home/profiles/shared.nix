# Home config every machine gets. pc.nix / laptop.nix / thinkpad.nix only add
# machine-specific bits on top.
{
  lib,
  pkgs,
  inputs,
  unstable,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  home.username = "shlok";
  home.homeDirectory = "/home/shlok";
  home.stateVersion = lib.mkDefault "25.11";

  home.sessionVariables = {
    EDITOR = "code";
    XCURSOR_SIZE = 24;
    TABCOMPLETE_COLLECTOR_URL = "http://100.100.163.102:8787";
  };

  imports = [
    ../features/ai
    ../features/bat
    ../features/btop
    ../features/cliphist
    ../features/dconf
    ../features/devenv
    ../features/excalidraw
    ../features/eza
    ../features/git
    ../features/gitui
    ../features/gnome-keyring
    ../features/gtk
    ../features/helium
    ../features/hyprland
    ../features/kitty
    ../features/lazyvim
    ../features/nextcloud
    ../features/obs-studio
    ../features/ripgrep
    ../features/rofi
    ../features/starship
    ../features/stylix
    ../features/swaync
    ../features/syncthing
    ../features/tmux
    ../features/udiskie
    ../features/vscode
    ../features/wlogout
    ../features/zoxide
    ../features/zsh
  ];

  programs.home-manager.enable = true;

  # Home Manager owns mimeapps.list, so apps can't register handlers at
  # runtime. Browser defaults live in features/helium.
  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/discord" = [ "discord.desktop" ];
    "x-scheme-handler/claude-cli" = [ "claude-code-url-handler.desktop" ];
    "x-scheme-handler/t3code" = [ "com.t3tools.T3Code.desktop" ];
  };

  home.packages = with pkgs; [
    # Desktop apps. Fast-moving ones come from unstable (prebuilt, no compile).
    # Official client, with OpenASAR (faster startup) and Vencord (plugins).
    (unstable.discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
    unstable.obsidian
    unstable.localsend
    pear-desktop
    nautilus
    gnome-calculator
    gnome-clocks
    gnome-disk-utility
    impression
    parabolic
    vlc
    pavucontrol
    wdisplays

    # Wayland / Hyprland session tools.
    unstable.awww
    unstable.hyprshot
    hyprpicker
    wl-clipboard
    wl-clicker
    playerctl
    brightnessctl
    libnotify
    xdg-utils
    speechd
    bemoji
    candy-icons
    gnome-themes-extra

    # CLI.
    fzf
    unstable.p7zip
    unzip
    wget
    dust
    yt-dlp
    ffmpeg
    pciutils
    inotify-tools
    libqalculate
    nmap
    sshpass
    cloudflared
    lazygit
    unstable.gh
    mprocs
    (callPackage ../../pkgs/dekit { src = inputs.dekit; })
    inputs.printer-cli.packages.${system}.default
    unstable.docker-compose # talks to rootless podman via DOCKER_HOST
    nix-output-monitor
    nixfmt

    # Toolchains. Per-project versions belong in devenv; these are defaults.
    gcc
    gnumake
    python313
    uv
    nodejs_22
    unstable.pnpm
    unstable.bun
    unstable.go
    jdk25_headless
    cargo
    rustc
    rustfmt
    clippy
    rust-analyzer
    openssl

    # Fun.
    fastfetch
    lolcat
    cowsay
    cmatrix
    cbonsai
  ];
}
