# NVIDIA driver only. No system-wide CUDA toolkit: Blender ships its own
# kernels, and CUDA projects get the toolkit from their devenv/flake shell.
# Hosts set the driver branch, `open`, and PRIME themselves.
{
  config,
  lib,
  pkgs,
  unstable,
  ...
}:

{
  # Selecting the driver here is what enables hardware.nvidia. No X server
  # needed: Hyprland talks to the GPU directly.
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    # NVIDIA's open kernel modules are recommended for Turing (RTX 20xx) and
    # newer. Older cards must set this to false.
    open = lib.mkDefault true;
    nvidiaSettings = false;
    # Saves VRAM across suspend so apps don't come back corrupted.
    powerManagement.enable = lib.mkDefault true;
    package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Hardware video decode for Firefox/Chromium/mpv via VA-API.
  hardware.graphics.extraPackages = [ pkgs.nvidia-vaapi-driver ];

  environment.systemPackages = [ unstable.nvtopPackages.full ];
}
