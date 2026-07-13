{
  config,
  lib,
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

  services.nfs.server = {
    enable = true;
    hostName = "127.0.0.1";
    mountdPort = 4002;
    statdPort = 4000;
    lockdPort = 4001;
    exports = ''
      /home/shlok/Documents/Programming/Sandbox/MBApps 127.0.0.1(rw,sync,no_subtree_check)
      /mnt/pickles/OSX-KVM 127.0.0.1(rw,sync,no_subtree_check)
    '';
  };

  services.nfs.settings.nfsd.udp = false;

  # Keep rpcbind on loopback so the exports stay host-local.
  systemd.sockets.rpcbind.socketConfig = {
    ListenStream = lib.mkForce [
      ""
      "127.0.0.1:111"
      "[::1]:111"
    ];
    ListenDatagram = lib.mkForce [
      ""
      "127.0.0.1:111"
      "[::1]:111"
    ];
  };

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
