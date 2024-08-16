{ config, pkgs, inputs, ... }:

{
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
    pkgs.kitty
    pkgs.direnv
    pkgs.python313
    pkgs.cmatrix
    pkgs.cbonsai
    pkgs.fastfetch
    pkgs.cowsay
    pkgs.fzf
    pkgs.bat
    inputs.UNSTABLE.legacyPackages.${pkgs.system}.p7zip
    inputs.UNSTABLE.legacyPackages.${pkgs.system}.tailscale
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  programs.home-manager.enable = true;
  home.file = {
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
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.UNSTABLE.legacyPackages.${pkgs.system}.hyprland;
    # extraConfig = builtins.readFile ./dotfiles/hyprland.conf;  
    settings = {
      monitor = [
        "DP-1, 1920x1080@144, 0x0, 1"
        "HDMI-A-1, 1920x1080@144, -1080x-650, 1, transform, 1"
      ];
      "$terminal" = "kitty";
      "$fileManager" = "dolphin";
      "$menu" = "wofi --show drun";
      general = { 
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        # Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false; 
        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;
        layout = "dwindle";
      };
      decoration = {
        rounding = 10;
        # Change transparency of focused and unfocused windows
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
        # https://wiki.hyprland.org/Configuring/Variables/#blur
        blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = 0.1696;
        };
      };
      animations = {
        enabled = true;
        # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 0.5, 7, myBezier"
          "windowsOut, 0.5, 7, default, popin 80%"
          "border, 0.5, 10, default"
          "borderangle, 0.5, 8, default"
          "fade, 0.5, 7, default"
          "workspaces, 0.5, 6, default"       
        ];
      };
      dwindle = {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # You probably want this
      };
      misc = { 
        # https://wiki.hyprland.org/Configuring/Variables/#misc
        force_default_wallpaper = -1; # Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = false; # If true disables the random hyprland logo / anime girl background. :(
      };
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
        touchpad = {
          natural_scroll = false;
        };
      };
      gestures = {
        workspace_swipe = false;
      };
      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };
    "$mainMod" = "SUPER";
    bind = [
      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      "$mainMod, Q, exec, $terminal"
      "$mainMod, C, killactive,"
      "$mainMod, M, exit,"
      "$mainMod, E, exec, $fileManager"
      "$mainMod, V, togglefloating,"
      "$mainMod, R, exec, $menu"
      "$mainMod, P, pseudo, # dwindle"
      "$mainMod, J, togglesplit, # dwindle"
      "$mainMod, S, exec, rofi -show  drun -show-icons"
      "$mainMod, B, exec, brave"

      # Move focus with mainMod + arrow keys
      "$mainMod, left, movefocus, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, up, movefocus, u"
      "$mainMod, down, movefocus, d"

      # Switch workspaces with mainMod + [0-9]
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"
      "$mainMod, 0, workspace, 10"

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      "$mainMod SHIFT, 1, movetoworkspace, 1"
      "$mainMod SHIFT, 2, movetoworkspace, 2"
      "$mainMod SHIFT, 3, movetoworkspace, 3"
      "$mainMod SHIFT, 4, movetoworkspace, 4"
      "$mainMod SHIFT, 5, movetoworkspace, 5"
      "$mainMod SHIFT, 6, movetoworkspace, 6"
      "$mainMod SHIFT, 7, movetoworkspace, 7"
      "$mainMod SHIFT, 8, movetoworkspace, 8"
      "$mainMod SHIFT, 9, movetoworkspace, 9"
      "$mainMod SHIFT, 0, movetoworkspace, 10"

      # Example special workspace (scratchpad)
      "$mainMod, S, togglespecialworkspace, magic"
      "$mainMod SHIFT, S, movetoworkspace, special:magic"

      # Scroll through existing workspaces with mainMod + scroll
      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"

    ];
    bindm = [
      # Move/resize windows with mainMod + LMB/RMB and dragging
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];
    windowrulev2 = "suppressevent maximize, class:.*";
    };
  };

  programs.vscode = {
    enable = true;
    package = inputs.UNSTABLE.legacyPackages.${pkgs.system}.vscodium;
    extensions = with inputs.UNSTABLE.legacyPackages.${pkgs.system}.vscode-extensions; [
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
      vscodevim.vim
      yzhang.markdown-all-in-one
      jnoortheen.nix-ide
    ];
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
      nrs = "sudo nixos-rebuild switch --flake \"/home/shlok/nixos-config\" | lolcat -f";
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
    package = inputs.UNSTABLE.legacyPackages.${pkgs.system}.brave;
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
      { id = "clngdbkpkpeebahjckkjfobafhncgmne"; } # stylus
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

  programs.rofi = {
    enable = true;
    font = "/nix/store/nl0aa2y8bixahcx6vmmcajpd3jn06hzm-nerdfonts-3.2.1/share/fonts/truetype/NerdFonts/CaskaydiaCoveNerdFont-Regular.ttf";
    location = "center";
    plugins = [
      pkgs.rofimoji
      pkgs.rofi-rbw
      pkgs.rofi-calc
      pkgs.rofi-screenshot
    ];
    terminal = "kitty";
  };
}


