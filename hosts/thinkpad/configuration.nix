{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../system/profiles/shared.nix
    ../../system/profiles/thinkpad.nix
  ];

  networking.hostName = "shlokthinkpad";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # TPM unseals these the way BitLocker does. Passphrase remains a fallback slot.
  boot.initrd.luks.devices = {
    "luks-e6828f57-55f3-43b4-a7ad-99541f6a2fa4".crypttabExtraOpts = [
      "tpm2-device=auto"
    ];
    "luks-8831e440-bd59-4465-b1fe-af738d91cab2" = {
      device = "/dev/disk/by-uuid/8831e440-bd59-4465-b1fe-af738d91cab2";
      crypttabExtraOpts = [ "tpm2-device=auto" ];
    };
  };

  system.stateVersion = "26.05";
}
