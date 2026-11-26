{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../system/profiles/shared.nix
    ../../system/profiles/pc.nix
  ];

  networking.hostName = "ShlokPCNIX";

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.supportedFilesystems = [ "ntfs" ];

  # RTX 2060 (Turing): open kernel modules are supported and recommended.
  hardware.nvidia.open = true;

  hardware.opentabletdriver.enable = true;
  services.usbmuxd.enable = true;

  system.stateVersion = "25.11";
}
