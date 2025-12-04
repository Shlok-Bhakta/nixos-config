{ pkgs, config, lib, ... }:

{
  imports = [
    ../shared/configuration.nix
    ./hardware-configuration.nix
  ];

  custom = {
    kanata.enable = true;
    kanata.devices = [
      "/dev/input/by-id/usb-Keychron_Keychron_K8_Pro-event-kbd"
    ];
    steam.enable = true;
    nix-serve.enable = true;
  };

  hardware.opentabletdriver.enable = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.supportedFilesystems = [ 
    "ntfs" 
    "nfs"
    "nfs4"
  ];

  networking.hostName = "ShlokPCNIX";

  boot.kernelParams = [
    "initcall_blacklist=simpledrm_platform_driver_init"
    "nvidia-drm.modeset=1"
    "nvidia_drm.fbdev=1"
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  services.xserver.xrandrHeads = [
    {
      output = "DP-1";
      primary = true;
    }
    {
      output = "HDMI-A-1";
    }
  ];

  services.displayManager.sddm.wayland.enable = lib.mkForce false;
  services.displayManager.sddm.setupScript = ''
    ${pkgs.xorg.xrandr}/bin/xrandr --output DP-1 --primary --auto --output HDMI-A-1 --auto --right-of DP-1
  '';
}
