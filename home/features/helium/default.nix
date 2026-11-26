# Default browser. Chromium-based, so PWAs work ("Install page as app") and
# `helium --app=URL` gives a chromeless app window.
{ pkgs, inputs, ... }:

let
  helium-unwrapped = inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default;

  # Carried over from Brave: stop WebRTC from auto-adjusting mic gain.
  helium = pkgs.symlinkJoin {
    name = "helium-wrapped";
    paths = [ helium-unwrapped ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/helium \
        --add-flags "--disable-features=WebRtcAllowInputVolumeAdjustment"
    '';
    inherit (helium-unwrapped) meta;
  };

  browserTypes = [
    "text/html"
    "application/xhtml+xml"
    "x-scheme-handler/http"
    "x-scheme-handler/https"
    "x-scheme-handler/about"
    "x-scheme-handler/unknown"
  ];
in
{
  home.packages = [ helium ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = builtins.listToAttrs (
      map (type: {
        name = type;
        value = [ "helium.desktop" ];
      }) browserTypes
    );
  };
}
