{ pkgs, ... }:
{
  programs.btop = {
    enable = true;
    # Only adds /run/opengl-driver/lib to the rpath so btop finds the NVIDIA
    # driver's NVML and shows the GPU panel. No CUDA toolkit, and it's prebuilt
    # in cache.nixos-cuda.org. Harmless on machines without NVIDIA.
    package = pkgs.btop.override { cudaSupport = true; };
  };
}
