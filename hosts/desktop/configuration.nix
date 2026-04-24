{
  config,
  ...
}:

{
  imports = [
    ../shared/configuration.nix
    ./hardware-configuration.nix
    ../../system/profiles/desktop.nix
  ];

  hardware.opentabletdriver.enable = true;
  services.usbmuxd.enable = true;

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
    "amd_iommu=on"
    "iommu=pt"
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

}
