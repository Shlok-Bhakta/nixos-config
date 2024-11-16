{ pkgs, fetchurl }:

let
  pname = "pureref";
  version = "1.11.1";

  # src = ./PureRef.Appimage;
  src = pkgs.fetchurl {
    url = "https://fh.shloklab.us/api/files/bgmnvuddbyf3jcb/yprdm5hyfe2azft/pure_ref_64XVSZ4oPB.Appimage?token=";
    sha256 = "sha256-0iR1cP2sZvWWqKwRAwq6L/bmIBSYHKrlI8u8V2hANfM="; # Replace with actual hash
  };
in

pkgs.runCommand "pureref" {
  buildInputs = with pkgs; [ appimage-run ];
} ''
  mkdir -p $out/bin

  cat <<-EOF > $out/bin/pureref
  #!/bin/sh
  ${pkgs.appimage-run}/bin/appimage-run ${src}
  EOF

  chmod +x $out/bin/pureref
''

  # # Optional: Create a desktop entry
  # xdg.desktopEntries.pureref = {
  #   name = "Pureref";
  #   exec = "pureref";
  #   icon = "art";
  #   comment = "Custom Blender build (Goo Engine)";
  #   categories = [ "Graphics" ];
  # };