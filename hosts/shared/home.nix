{ lib, config, inputs, pkgs, mynvf, ... }:

let
  unstable = import ../../unstable.nix { inherit inputs pkgs; };
  
  importModules = dir:
    let
      entries = builtins.readDir dir;
      validModules = lib.filterAttrs (name: type:
        type == "directory" && builtins.pathExists (dir + "/${name}/default.nix")
      ) entries;
    in
      map (name: dir + "/${name}") (builtins.attrNames validModules);
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
  ] ++ (importModules ../../modules/home);

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
    unstable.go
    pkgs.nmap
  ];
}
