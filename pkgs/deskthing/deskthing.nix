{ lib, pkgs }:
let
  pname = "deskthing";
  version = "0.11.17";
  
  src = pkgs.fetchurl {
    url = "https://github.com/ItsRiprod/DeskThing/releases/download/v${version}/deskthing-linux-${version}-setup.AppImage";
    sha256 = "sha256-BdWibxt3vHHlBzUST5fMW9H+pnejf5kcl/E8fxwg2nE=";
  };

  appimageContents = pkgs.appimageTools.extract { inherit pname version src; };
  
  deskthing-run = pkgs.appimage-run.override {
    extraPkgs = pkgs: with pkgs; [
      android-tools  # Provides adb for device detection
      glibc
      libGL
      xorg.libX11
      xorg.libXext
      xorg.libXi
      xorg.libXrender
      xorg.libXtst
      gtk3
      cairo
      pango
      gdk-pixbuf
      atk
      at-spi2-atk
      dbus
      cups
      libdrm
      mesa
      expat
      libxkbcommon
      nspr
      nss
      systemd
    ];
  };
in
pkgs.stdenv.mkDerivation {
  inherit pname version;
  
  buildInputs = [ deskthing-run ];
  
  dontUnpack = true;
  
  installPhase = ''
    mkdir -p $out/bin
    
    # Create wrapper script
    cat > $out/bin/${pname} << EOF
    #!/bin/sh
    exec ${deskthing-run}/bin/appimage-run ${src} "\$@"
    EOF
    chmod +x $out/bin/${pname}
    
    # Install desktop file if it exists
    if [ -f ${appimageContents}/${pname}.desktop ]; then
      install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=${pname}'
    fi
    
    # Install icon if it exists
    find ${appimageContents} -name "*.png" -o -name "*.svg" | head -1 | while read icon; do
      if [ -n "$icon" ]; then
        install -m 444 -D "$icon" $out/share/icons/hicolor/512x512/apps/${pname}.png
      fi
    done
  '';

  meta = with lib; {
    description = "A Node.js application that manages desk accessories";
    homepage = "https://github.com/ItsRiprod/DeskThing";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}