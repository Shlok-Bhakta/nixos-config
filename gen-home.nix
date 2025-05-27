{ lib, config, pkgs, inputs, mynvf, ... }:
let
  unstable = import ./unstable.nix { inherit inputs pkgs; };  
  affinity = import inputs.affinity { 
    system = pkgs.system;
    config = {
      allowUnfree = true;
    };
  };
  wallpaper-path = ./dotfiles/wallpaper/wallpaper.gif;
  # goo-engine = pkgs.callPackage ./pkgs/goo-engine/default.nix {
  # };
  # fabric-ai = unstable.callPackage ./pkgs/fabric/package.nix {};
  pureref = pkgs.callPackage (import ./pkgs/pureref/pureref.nix) {};

in{
  imports = [ 
    inputs.ags.homeManagerModules.default 
    inputs.stylix.homeModules.stylix
    ./pkgs/goo-engine/goo.nix

  ];
  home.username = "shlok";
  home.homeDirectory = "/home/shlok";
  home.sessionVariables = {
    EDITOR = "code";
    XCURSOR_SIZE = 24;
    HYPRCURSOR_SIZE = 24;
  };
  # inputs.yapper.config.allowUnfree = true;

  home.stateVersion = "25.05"; 
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
    # fabric-ai
    pkgs.nvidia-vaapi-driver
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
    inputs.yapper.packages."${pkgs.system}".default
    # inputs.affinity.packages.${pkgs.system}.photo
    # affinity.Photo
    pkgs.speechd
    pkgs.nautilus
    pkgs.boatswain
    unstable.deckmaster
    pkgs.gnome-calculator
    pkgs.gnome-characters
    pkgs.apostrophe
    pkgs.impression
    pkgs.textpieces
    # pkgs.gnome.adwaita-icon-theme
    pkgs.candy-icons
    pkgs.gnome-themes-extra
    pkgs.dust
    pkgs.ripgrep
    pkgs.speedtest-rs
    pkgs.gcc
    pkgs.gnumake
    pkgs.libgccjit
    unstable.hyprshot
    unstable.annotator
    unstable.anki
    pkgs.gnome-calendar
    pkgs.gnome-clocks
    # nix flake lock --update-input kando-nixpkgs
    pkgs.fragments
    pkgs.gnome-disk-utility
    pureref
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
    pkgs.prismlauncher
    # unstable.blender
    unstable.walker
    pkgs.libqalculate
    pkgs.wlogout
    unstable.rofi-power-menu
    pkgs.tesseract
    pkgs.pavucontrol           
    mynvf.neovim
    pkgs.brightnessctl
    pkgs.uv
    # fabric-ai = unstable.callPackage ./pkgs/fabric/package.nix {};.git
    # unstable.alvr
    # pkgs.bottles
    # pkgs.lazydocker
    # pkgs.wine
    # pkgs.ollama-cuda
    # hypkgs.hyprpanel
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
  };

  stylix =  {
    enable = true;
    targets = {
      vscode.enable = false;
      fuzzel.enable = false;
      kitty.enable = false;
      hyprland.enable = false;
      bat.enable = false;
      hyprlock.enable = false;
      swaync.enable = false;
      tmux.enable = false;
      rofi.enable = false;
      starship.enable = false;
      gitui.enable = false;
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
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
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
    profiles.default.extensions = with unstable.vscode-extensions; [
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
    themeFile = "Catppuccin-Mocha";
    settings = {
      shell = "tmux";
    };
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
      C = "code";
      c = "code .";
      cn = "code /home/shlok/nixos-config";
      cat = "bat";
      man = "batman";
      cd = "z";
      plz = "sudo";
      s = "sudo";
      tmuxhelp = ''echo "$(tput setaf 4)TMUX CHEATSHEET$(tput sgr0)
        $(tput setaf 4)---------------$(tput sgr0)
        $(tput bold)Prefix is Ctrl-e$(tput sgr0)

        $(tput setaf 2)PANES$(tput sgr0)
        prefix + s          Split horizontally
        prefix + v          Split vertically 
        prefix + h/j/k/l    Navigate panes
        prefix + x          Kill current pane
        prefix + q          Show pane numbers
        prefix + z          Toggle pane zoom
        Ctrl + h/j/k/l      Smart pane switching (works with vim)

        $(tput setaf 2)WINDOWS$(tput sgr0)
        prefix + c          Create new window
        prefix + n          Next window
        prefix + p          Previous window
        prefix + &          Kill window
        prefix + ,          Rename window
        prefix + number     Go to window by number
        prefix + l          Toggle last active window
        prefix + w          List windows

        $(tput setaf 2)SESSIONS$(tput sgr0)
        prefix + d          Detach from session
        prefix + $          Rename session
        prefix + s          List/switch sessions
        tmux ls            List sessions
        tmux attach -t 0   Attach to session 0
        tmux kill-session  Kill current session

        $(tput setaf 2)MISC$(tput sgr0)
        prefix + r          Reload tmux config
        prefix + [          Enter copy mode (use vim keys)
        prefix + ?          Show all keybindings"'';
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
   extraConfig = builtins.readFile ./dotfiles/tmux/tmux.conf;
  };


  programs.starship = {
    enable = true;
    settings = pkgs.lib.importTOML ./dotfiles/starship.toml;
  };

  xdg.configFile."walker" = {
    source = ./dotfiles/walker;
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
    lfs.enable = true;

  };

  programs.git-credential-oauth = {
    enable = true;
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
    package = unstable.waybar;
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

  # xdg.configFile."wlogout" = {
  #   source = ./dotfiles/wlogout;
  #   recursive = true;
  # };

  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "hyprlock";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "Hibernate";
        keybind = "h";
      }
      {
        label = "logout";
        action = "hyprctl dispatch exit 0";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
    ];
    style = ''
      * {
        background-image: none;
      }
      window {
        background-color: rgba(30, 30, 46, 0.9);
      }
      button {
        color: #cdd6f4;
        background-color: #313244;
        border-style: solid;
        border-width: 2px;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 25%;
      }
      button:focus, button:active, button:hover {
        background-color: #45475a;
        outline-style: none;
      }
      #lock {
          background-image: url("/home/shlok/.config/wlogout/icons/lock.svg");
      }

      #logout {
          background-image: url("/home/shlok/.config/wlogout/icons/logout.svg");
      }

      #suspend {
          background-image: url("/home/shlok/.config/wlogout/icons/suspend.svg");
      }

      #hibernate {
          background-image: url("/home/shlok/.config/wlogout/icons/hibernate.svg");
      }

      #shutdown {
          background-image: url("/home/shlok/.config/wlogout/icons/shutdown.svg");
      }

      #reboot {
          background-image: url("/home/shlok/.config/wlogout/icons/reboot.svg");
      }
    '';
  };

  # Config for Virt-Manager
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  # enable rofi
  programs.rofi = {
    enable = true;
    
    package = pkgs.rofi-wayland.override { 
      plugins = [ 
        unstable.rofi-calc 
        unstable.rofi-emoji
        
        unstable.rofi-rbw
    ]; };
    # font = "CaskaydiaCove Nerd Font:size=20";
    # terminal = "kitty";
  };
  xdg.configFile."rofi" = {
    source = ./dotfiles/rofi;
    recursive = true;
  };

  # fonts.fontconfig.enable = true;

  programs.gitui = {
    enable = true;
    theme = builtins.readFile ./dotfiles/gitui/catppuccin-mocha.ron;
  };

}

