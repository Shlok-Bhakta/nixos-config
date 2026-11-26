# Desktop tower: NVIDIA-only GPU, gaming, streaming.
{ ... }:

{
  imports = [
    ../features/dev-workstation
    ../features/gaming
    ../features/nvidia
    ../features/sunshine
  ];

  # NVIDIA is the only GPU here, so point VA-API at it directly.
  # (Not on PRIME laptops: there the Intel iGPU drives the desktop.)
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    NVD_BACKEND = "direct";
  };
}
