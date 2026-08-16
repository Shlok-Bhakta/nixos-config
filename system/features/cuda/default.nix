{
  pkgs,
  inputs,
  unstable,
  ...
}:

{
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    libva-vdpau-driver
    libvdpau
    libvdpau-va-gl
    nvidia-vaapi-driver
    vdpauinfo
    libva
    libva-utils
  ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
  };

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
  };

  environment.sessionVariables = {
    CUDA_PATH = "${pkgs.cudaPackages_12_8.cudatoolkit}";
    GBM_BACKEND = "nvidia-drm";
    WLR_NO_HARDWARE_CURSORS = "1";
    no_hardware_cursors = "1";
  };

  environment.systemPackages = [
    pkgs.cudaPackages_12_8.cudatoolkit
    pkgs.cudaPackages_12_8.cudnn
    pkgs.nvidia-vaapi-driver
    unstable.egl-wayland
    (unstable.whisper-cpp.override { cudaSupport = true; })
    unstable.nvtopPackages.full
    unstable.blender
    inputs.yapper.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
