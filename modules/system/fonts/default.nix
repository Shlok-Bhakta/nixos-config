{ config, lib, pkgs, ... }:

let
  cfg = config.custom.fonts;
in
{
  options.custom.fonts = {
    enable = lib.mkEnableOption "custom fonts configuration";
  };

  config = lib.mkIf cfg.enable {
    fonts.packages = with pkgs; [
      nerd-fonts.caskaydia-cove
      (stdenv.mkDerivation {
        name = "allura-font";
        src = ./customfont/allura;
        installPhase = ''
          mkdir -p $out/share/fonts/truetype
          cp $src/Allura-Regular.ttf $out/share/fonts/truetype/
        '';
      })
      (stdenv.mkDerivation {
        name = "lofty-font";
        src = ./customfont/lofty;
        installPhase = ''
          mkdir -p $out/share/fonts/truetype
          cp $src/LoftyGoals.otf $out/share/fonts/truetype/
        '';
      })
      times-newer-roman
      corefonts
    ];
  };
}
