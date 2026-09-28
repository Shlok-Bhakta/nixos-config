{
  config,
  pkgs,
  ...
}:
let
  # Only the owner's phone and tablet may be opened by usbmuxd.
  allowedSerials = [
    "00008140001E4D663468801C" # iPhone
    "000081030001351426F1001E" # iPad
  ];
  deviceRule = serial: ''
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="05ac", ATTR{serial}=="${serial}", GROUP="usbmux", MODE="0660"
  '';
in
{
  users.groups.usbmux = { };
  users.users.usbmux = {
    description = "Apple device multiplexing service";
    group = "usbmux";
    isSystemUser = true;
  };

  services.udev.extraRules = builtins.concatStringsSep "\n" (map deviceRule allowedSerials);

  systemd.services.usbmuxd = {
    description = "usbmuxd for the owner's iPhone and iPad";
    wantedBy = [ "multi-user.target" ];
    unitConfig.Documentation = "man:usbmuxd(8)";
    serviceConfig = {
      ExecStartPre = map (
        serial: "${config.systemd.package}/bin/udevadm trigger -s usb -a idVendor=05ac -a serial=${serial}"
      ) allowedSerials;
      ExecStart = "${pkgs.usbmuxd}/bin/usbmuxd -U usbmux -v";
    };
  };
}
