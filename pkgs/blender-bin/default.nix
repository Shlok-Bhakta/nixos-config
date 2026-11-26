# Official Blender release build instead of the nixpkgs source build.
#  - Always the newest upstream release (nixpkgs usually lags a version).
#  - CUDA / OptiX / HIP kernels are bundled, so GPU rendering works with no
#    local compile and no system-wide CUDA toolkit.
# Bump with ./update.sh (rewrites source.json from the release checksums).
{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  alsa-lib,
  libdecor,
  libdrm,
  libGLU,
  libglvnd,
  libice,
  libpulseaudio,
  libsm,
  libx11,
  libxfixes,
  libxi,
  libxkbcommon,
  libxrender,
  libxxf86vm,
  numactl,
  ocl-icd,
  openal,
  SDL2,
  vulkan-loader,
  wayland,
  zlib,
}:

let
  source = lib.importJSON ./source.json;
  inherit (source) version;
  series = lib.versions.majorMinor version;
  file = "blender-${version}-linux-x64.tar.xz";

  runtimeLibs = [
    alsa-lib
    libdecor
    libdrm
    libGLU
    libglvnd
    libice
    libpulseaudio
    libsm
    libx11
    libxfixes
    libxi
    libxkbcommon
    libxrender
    libxxf86vm
    numactl
    ocl-icd
    openal
    SDL2
    stdenv.cc.cc.lib
    vulkan-loader
    wayland
    zlib
  ];
in
stdenv.mkDerivation {
  pname = "blender-bin";
  inherit version;

  # download.blender.org sits behind a bot challenge, so use official mirrors.
  src = fetchurl {
    urls = [
      "https://mirrors.ocf.berkeley.edu/blender/release/Blender${series}/${file}"
      "https://ftp.nluug.nl/pub/graphics/blender/release/Blender${series}/${file}"
      "https://download.blender.org/release/Blender${series}/${file}"
    ];
    inherit (source) sha256;
  };

  nativeBuildInputs = [ makeWrapper ];

  dontConfigure = true;
  dontBuild = true;
  # Bundled libraries must stay exactly as shipped.
  dontStrip = true;
  dontPatchELF = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/libexec $out/bin $out/share/applications $out/share/icons/hicolor/scalable/apps
    cp -r . $out/libexec/blender

    interp="$(cat $NIX_CC/nix-support/dynamic-linker)"
    patchelf --set-interpreter "$interp" $out/libexec/blender/blender
    for py in $out/libexec/blender/${series}/python/bin/python3*; do
      [ -L "$py" ] || patchelf --set-interpreter "$interp" "$py"
    done

    # /run/opengl-driver/lib provides libcuda / libnvoptix from the driver.
    makeWrapper $out/libexec/blender/blender $out/bin/blender \
      --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib:${lib.makeLibraryPath runtimeLibs}

    install -m644 $out/libexec/blender/blender.desktop $out/share/applications/blender.desktop
    install -m644 $out/libexec/blender/blender.svg $out/share/icons/hicolor/scalable/apps/blender.svg

    runHook postInstall
  '';

  meta = {
    description = "3D creation suite (official upstream binary with CUDA/OptiX)";
    homepage = "https://www.blender.org";
    license = lib.licenses.gpl3Plus;
    mainProgram = "blender";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
