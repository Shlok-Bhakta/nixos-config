{ config, lib, pkgs, ... }:

let
  cfg = config.custom.stylix;
in
{
  options.custom.stylix = {
    enable = lib.mkEnableOption "Stylix system theming";
  };

  config = lib.mkIf cfg.enable {
    stylix = {
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
        base00 = "1e1e2e";
        base01 = "181825";
        base02 = "313244";
        base03 = "45475a";
        base04 = "585b70";
        base05 = "cdd6f4";
        base06 = "f5e0dc";
        base07 = "b4befe";
        base08 = "f38ba8";
        base09 = "fab387";
        base0A = "f9e2af";
        base0B = "a6e3a1";
        base0C = "94e2d5";
        base0D = "89b4fa";
        base0E = "cba6f7";
        base0F = "f2cdcd";
      };
      
      image = config.custom.wallpapers.animated;
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
  };
}
