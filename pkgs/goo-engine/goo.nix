{ lib, config, pkgs, inputs, ... }: let
goo-engine = pkgs.stdenv.mkDerivation {
    name = "goo-engine";
    src = pkgs.fetchurl {
      url = "https://fh.shloklab.us/api/files/bgmnvuddbyf3jcb/zuu5bqkjm1yxcbh/goo_engine_vGIB9TLSUd.tar.xz?token=";
      sha256 = "sha256-7my9WK/GqXSO58IahDxUEDSxg6jQTH3h5IyQyPiTwmA="; # Replace with actual hash
    };
    unpackPhase = ''
      mkdir source
      tar -xf $src -C source
      sourceRoot=source
    '';

    installPhase = ''
        mkdir -p $out/bin
        cp -r . $out/
        ln -s $out/blender $out/bin/blender  # Adjust the binary name if different
      '';
  };

  goo-engine-fhs = pkgs.buildFHSUserEnv {
    name = "goo-engine-fhs";
    targetPkgs = pkgs: (with pkgs; [
      goo-engine
      # X11 libraries
      libdecor
      xorg.libX11
      xorg.libXi
      xorg.libXext
      xorg.libXrender
      xorg.libXfixes
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXcursor
      xorg.libXrandr
      xorg.libXinerama
      xorg.libXxf86vm
      # OpenGL libraries
      libGL
      libGLU
      # Input libraries
      libxkbcommon
      wayland
      # Audio libraries
      alsa-lib
      pulseaudio
      # Other common dependencies
      zlib
      glib
      fontconfig
      freetype
      dbus
      # Additional libraries that might be needed
      libdrm
      libxslt
      libcap
      libpng
      libtiff
      libjpeg
      openexr
      opencolorio
      openimageio
      openvdb
      tbb
      cairo
      pango
      gtk3
      python3
      ffmpeg
      xorg.libSM
      xorg.libICE
      python312Packages.pillow
      # Add any other runtime dependencies here
    ]);
    runScript = "blender";
  };
in {
  # Optional: Create a desktop entry
  xdg.desktopEntries.goo-engine = {
    name = "Goo Engine";
    exec = "goo-engine-fhs";
    icon = "blender"; # You may want to provide a custom icon
    comment = "Custom Blender build (Goo Engine)";
    categories = [ "Graphics" ];
  };

  home.packages = [
    goo-engine-fhs
  ];
}