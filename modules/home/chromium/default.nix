{ inputs, pkgs, ... }:
let
  unstable = import ../../../unstable.nix { inherit inputs pkgs; };
in
{
  programs.chromium = {
    enable = true;
    package = unstable.brave;
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; }
      { id = "nngceckbapebfimnlniiiahkandclblb"; }
      { id = "clngdbkpkpeebahjckkjfobafhncgmne"; }
      { id = "bkkmolkhemgaeaeggcmfbghljjjoofoh"; }
    ];
    commandLineArgs = [
      "--disable-features=WebRtcAllowInputVolumeAdjustment"
    ];
  };
}
