{ unstable, ... }:
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
