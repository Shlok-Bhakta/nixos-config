{ lib, config, pkgs, inputs, ... }:
let
  unstable = import inputs.UNSTABLE {
    system = pkgs.system;
    config = {
      allowUnfree = true;
    };
  };
  wallpaper-path = /home/shlok/nixos-config/dotfiles/wallpaper/wallpaper.gif;
  # goo-engine = pkgs.callPackage ./goo/goo-engine.nix {
  #   pkgs = unstable;
  # };
  fabric-ai = unstable.callPackage ./pkgs/fabric/package.nix {};

in{
  imports = [ 
    inputs.ags.homeManagerModules.default 
    inputs.stylix.homeManagerModules.stylix
    ./pkgs/hypr.nix
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
    pkgs.bat
    unstable.p7zip
    unstable.localsend
    unstable.swww
    unstable.hypridle
    pkgs.cliphist
    unstable.nautilus
    pkgs.playerctl
    pkgs.dbus
    pkgs.wl-clipboard
    pkgs.grim
    pkgs.slurp
    unstable.onlyoffice-bin
    pkgs.openssl
    pkgs.bemoji
    pkgs.youtube-music
    pkgs.nh
    pkgs.nix-output-monitor
    pkgs.wtype
    pkgs.nodejs_22
    fabric-ai
    unstable.ollama
    pkgs.ffmpeg
    unstable.openai-whisper-cpp
    unstable.nvtopPackages.panthor
    pkgs.nvidia-vaapi-driver
    unstable.egl-wayland
    pkgs.pciutils
    pkgs.udisks2
    pkgs.udiskie
    pkgs.polkit
    pkgs.libnotify
    unstable.via
    pkgs.yt-dlp
    # unstable.blender
    # hypkgs.hyprpanel
    # goo-engine
    # agsconf
  ];


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  programs.home-manager.enable = true;
  home.file = {
    # "ags".source = "./dotfiles/ags";
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

  };
  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    tray = "auto";
  };
  xdg.configFile = {
    # "ags".source = ./dotfiles/ags;
    "waybar".source = ./dotfiles/waybar;
  };
  

  programs.ags = {
      enable = true;

      # null or path, leave as null if you don't want hm to manage the config
      # configDir = ./dotfiles/ags1;
      configDir = null;

      extraPackages = with pkgs; [
        gtksourceview
        gtksourceview4
        ollama
        python311Packages.material-color-utilities
        python311Packages.pywayland
        pywal
        sassc
        webkitgtk
        webp-pixbuf-loader
        ydotool
        sass
      ];
    };
  programs.hyprlock = {
    enable = true;
    package = unstable.hyprlock;
    # settings = builtins.imprty
    extraConfig = builtins.readFile ./dotfiles/hypr/hyprlock.conf;
  };


  stylix =  {
    enable = true;
    targets = {
      vscode.enable = false;
      fuzzel.enable = false;
      kitty.enable = false;
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
  services.hypridle = {
    enable = true;
    package = unstable.hypridle;
    # settings = builtins.imprty
    settings = {
      "$lock_cmd" = "pidof hyprlock || hyprlock";
      "$suspend_cmd" = "pidof steam || systemctl suspend || loginctl suspend"; # f*** nvidia
      general = {
          lock_cmd = "$lock_cmd";
          before_sleep_cmd = "loginctl lock-session";
      };

      listener = [
        {
          timeout = 1200; # 20mins
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 1500; # 25mins
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1800; # 30mins
          on-timeout = "$suspend_cmd";
        }
      ];
    };
  };

  programs.vscode = {
    enable = true;
    package = unstable.vscodium;
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

  programs.starship = {
    enable = true;
    # package.disabled = true;
    # Configuration written to ~/.config/starship.toml
    settings = pkgs.lib.importTOML ./dotfiles/starship.toml;
  };

  programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      plugins = [
          pkgs.vimPlugins.lazy-nvim
          pkgs.vimPlugins.lazygit-nvim
          pkgs.vimPlugins.catppuccin-nvim
      ];
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

