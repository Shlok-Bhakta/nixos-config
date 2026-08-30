{ pkgs, ... }:

let
  enroll-tpm-unlock = pkgs.writeShellScriptBin "enroll-tpm-unlock" ''
    set -euo pipefail

    if [ "$(id -u)" -ne 0 ]; then
      exec sudo "$0" "$@"
    fi

    shopt -s nullglob
    mappers=(/dev/mapper/luks-*)
    if [ ''${#mappers[@]} -eq 0 ]; then
      echo "No LUKS mapped devices found under /dev/mapper/luks-*" >&2
      exit 1
    fi

    echo "Enrolling TPM2 (PCR 7) for LUKS unlock. Enter the existing disk passphrase when asked."
    echo "The passphrase stays as a fallback if the TPM will not unseal."
    echo

    for mapper in "''${mappers[@]}"; do
      uuid="''${mapper##*/luks-}"
      dev="/dev/disk/by-uuid/$uuid"
      if [ ! -e "$dev" ]; then
        echo "Skipping $mapper (no $dev)" >&2
        continue
      fi
      echo "==> $dev"
      ${pkgs.systemd}/bin/systemd-cryptenroll \
        --wipe-slot=tpm2 \
        --tpm2-device=auto \
        --tpm2-pcrs=7 \
        "$dev"
      echo
    done

    echo "Done. Reboot into the generation that has systemd initrd + tpm2-device=auto."
    echo "Firmware or Secure Boot changes will fail TPM unseal; passphrase still works, then re-run this."
  '';
in
{
  security.tpm2.enable = true;
  security.tpm2.tctiEnvironment.enable = true;

  # systemd-cryptsetup in initrd is what actually talks to the TPM at boot.
  boot.initrd.systemd.enable = true;

  users.users.shlok.extraGroups = [ "tss" ];

  environment.systemPackages = [
    enroll-tpm-unlock
    pkgs.tpm2-tools
  ];
}
