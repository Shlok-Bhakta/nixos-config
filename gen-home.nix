{ lib, config, pkgs, inputs, ... }:
let
  unstable = import ./unstable.nix { inherit inputs pkgs; };  
  wallpaper-path = /home/shlok/nixos-config/dotfiles/wallpaper/wallpaper.gif;
  # goo-engine = pkgs.callPackage ./goo/goo-engine.nix {
  #   pkgs = unstable;
  # };
  fabric-ai = unstable.callPackage ./pkgs/fabric/package.nix {};

in{
  imports = [ 
    inputs.ags.homeManagerModules.default 
    inputs.stylix.homeManagerModules.stylix
  ];
  home.username = "shlok";
  home.homeDirectory = "/home/shlok";
  home.sessionVariables = {
    EDITOR = "code";
    XCURSOR_SIZE = 24;
    HYPRCURSOR_SIZE = 24;
  };

  home.stateVersion = "24.05"; 
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
    unstable.swww
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
    fabric-ai
    # unstable.ollama
    pkgs.ffmpeg
    unstable.openai-whisper-cpp
    unstable.nvtopPackages.panthor
    # pkgs.nvidia-vaapi-driver
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
    # pkgs.modrinth-app
    unstable.obsidian
    pkgs.wget
    # update with "nix flake lock --update-input zen-browser"
    inputs.zen-browser.packages."${pkgs.system}".default
    pkgs.speechd
    pkgs.gnome.nautilus
    pkgs.boatswain
    pkgs.gnome.gnome-calculator
    pkgs.gnome.gnome-characters
    pkgs.apostrophe
    pkgs.impression
    pkgs.textpieces
    # pkgs.gnome.adwaita-icon-theme
    pkgs.candy-icons
    pkgs.gnome.gnome-themes-extra
    pkgs.dust
    pkgs.ripgrep
    pkgs.speedtest-rs
    pkgs.gcc
    pkgs.gnumake
    pkgs.libgccjit
    unstable.hyprshot
    unstable.annotator
    unstable.anki
    # pkgs.pureref
    # unstable.blender
    # hypkgs.hyprpanel
    # goo-engine
    # agsconf
  ];

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
  };

  stylix =  {
    enable = true;
    targets = {
      vscode.enable = false;
      fuzzel.enable = false;
      kitty.enable = false;
      hyprland.enable = false;
      bat.enable = false;
    };
    base16Scheme = { 
      base00 = "1e1e2e"; # base
      base01 = "181825"; # mantle
      base02 = "313244"; # surface0
      base03 = "45475a"; # surface1
      base04 = "585b70"; # surface2
      base05 = "cdd6f4"; # text
      base06 = "f5e0dc"; # rosewater
      base07 = "b4befe"; # lavender
      base08 = "f38ba8"; # red
      base09 = "fab387"; # peach
      base0A = "f9e2af"; # yellow
      base0B = "a6e3a1"; # green
      base0C = "94e2d5"; # teal
      base0D = "89b4fa"; # blue
      base0E = "cba6f7"; # mauve
      base0F = "f2cdcd"; # flamingo
    };
    image = wallpaper-path;
    polarity = "dark";
    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "CaskaydiaCove Nerd Font";
      };

      sansSerif = { 
        package = pkgs.dejavu_fonts;
        name = "CaskaydiaCove Nerd Font";
      };

      monospace = {
        package = pkgs.dejavu_fonts;
        name = "CaskaydiaCove Nerd Font Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
  programs.bat = {
    enable = true;
    config = {
      theme = "catppuccin";
    };
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
      batgrep
      batwatch
    ];
    themes = {
      catppuccin = {
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat"; # Bat uses sublime syntax for its themes
          rev = "d714cc1d358ea51bfc02550dabab693f70cccea0";
          sha256 = "Q5B4NDrfCIK3UAMs94vdXnR42k4AXCqZz6sRn8bzmf4=";
        };
        file = "themes/Catppuccin Mocha.tmTheme";
      };
    };
  };

  programs.vscode = {
    enable = true;
    package = unstable.vscode.fhs;
    extensions = with unstable.vscode-extensions; [
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
      vscodevim.vim
      yzhang.markdown-all-in-one
      jnoortheen.nix-ide
    ];
  };
  
  programs.kitty = {
    enable = true;
    font.name = "CaskaydiaCove Nerd Font";
    theme = "Catppuccin-Mocha";
  };
  programs.obs-studio = {
    enable = true;
    package = unstable.obs-studio;
  };
  programs.zsh = {
    # zsh conf
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
      gnrs = "git add . && git commit -m \"update config\" && git push && sudo nixos-rebuild switch --flake \"/home/shlok/nixos-config\" | lolcat -f";
      nrs = "nh os switch | lolcat";
      # code = "codium";
      c = "code";
      C = "code .";
      cn = "code /home/shlok/nixos-config";
      cat = "bat";
      man = "batman";
      cd = "z";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    # oh my zsh
    oh-my-zsh = {
      enable = true;
      plugins = [ "git"];
    };
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
  };
  
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.ripgrep = {
    enable = true;
  };
  programs.tmux = {
    enable = true;
    plugins = [
      pkgs.tmuxPlugins.catppuccin
    ];
  };

  programs.starship = {
    enable = true;
    settings = pkgs.lib.importTOML ./dotfiles/starship.toml;
  };

  programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      plugins = [
          unstable.vimPlugins.lazy-nvim
          unstable.vimPlugins.lazygit-nvim
          unstable.vimPlugins.catppuccin-nvim
      ];
  };
  xdg.configFile."nvim" = {
    source = ./dotfiles/lazyvim;
    recursive = true;
  };

  programs.chromium = {
    enable = true;
    package = unstable.brave;
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
      { id = "clngdbkpkpeebahjckkjfobafhncgmne"; } # stylus
      { id = "bkkmolkhemgaeaeggcmfbghljjjoofoh"; } # catppuccin mocha
    ];
    commandLineArgs = [
      "--disable-features=WebRtcAllowInputVolumeAdjustment"
    ];
  };

  programs.git = {
    enable = true;
    userName  = "Shlok Bhakta";
    userEmail = "shlokbhakta1@gmail.com";
  };

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "kitty";
        layer = "overlay";
        anchor = "center";
        lines = 15;
        width = 45;
        font = "CaskaydiaCove Nerd Font:size=20";
      };
      colors = {
        background = "#11111bff";
        text = "#cdd6f4ff";
        match = "#181825ff";
        selection = "#1e1e2eff";
        selection-text = "#b4befeff";
        border = "#89b4faff";
      };
      border = {
        width = 2;
      };
    };
  };
  programs.btop = {
    enable = true;
  };

  programs.yazi = {
    enable = true;
    package = unstable.yazi-unwrapped;
  };

  services.cliphist = {
    enable = true;
    allowImages = true;
  };
  programs.waybar = {
    enable = true;
  };

  services.swaync = {
    enable = true;
    settings = {
      "positionX" = "right";
      "positionY" = "top";
      "control-center-margin-top" = 0;
      "control-center-margin-bottom" = 0;
      "control-center-margin-right" = 0;
      "control-center-margin-left" = 0;
      "notification-icon-size" = 64;
      "notification-body-image-height" = 100;
      "notification-body-image-width" = 200;
      "timeout" = 10;
      "timeout-low" = 5;
      "timeout-critical" = 0;
      "fit-to-screen" = true;
      "control-center-width" = 500;
      "control-center-height" = 600;
      "notification-window-width" = 500;
      "keyboard-shortcuts" = true;
      "image-visibility" = "when-available";
      "transition-time" = 200;
      "hide-on-clear" = false;
      "hide-on-action" = true;
      "script-fail-notify" = true;
      "scripts" = {};
      "notification-visibility" = {};
      "widgets" = [];
      "widget-config" = {};
    };
    style = builtins.readFile ./dotfiles/SwayNC/mocha.css;
  };

  programs.wlogout = {
    enable = true;
    layout = [
      {
      label = "shutdown";
      action = "systemctl poweroff";
      text = "Shutdown";
      keybind = "s";
      }
    ];
  };
}

