{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../system/profiles/shared.nix
    ../../system/profiles/laptop.nix
    ../../system/features/dev-workstation
    ../../system/features/msi-power
    ../../system/features/nvidia
  ];

  networking.hostName = "ShlokLAPNIX";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Intel iGPU drives the desktop; NVIDIA wakes up only for `nvidia-offload`.
  hardware.graphics.extraPackages = [ pkgs.intel-media-driver ];
  hardware.nvidia = {
    # Unchanged from before. Set true if the card is RTX 20xx or newer.
    open = false;
    powerManagement.finegrained = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  system.stateVersion = "25.11";
}
