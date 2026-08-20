{ ... }:

{
  services.howdy = {
    enable = true;
    control = "sufficient";
    settings = {
      core.no_confirmation = true;
      video = {
        device_path = "/dev/v4l/by-id/usb-SunplusIT_Inc_SPCA2085_PC_Camera_01.00.00-video-index0";
        dark_threshold = 90;
      };
    };
  };

  # Do not brute-force UVC controls. That is what knocked both cameras
  # into generic Sunplus IDs; a battery disconnect did not restore them.
  services.linux-enable-ir-emitter.enable = false;

  # greetd/tuigreet has no useful face-unlock UI; keep password login there.
  security.pam.services.greetd.howdy.enable = false;
  security.pam.services.login.howdy.enable = false;

  # polkit 127 isolates /dev/video*, which blocks Howdy in auth prompts.
  systemd.services."polkit-agent-helper@".serviceConfig = {
    DeviceAllow = "char-video4linux rw";
    PrivateDevices = "no";
  };

  services.tlp.settings.USB_DENYLIST = "04f2:b615 1bcf:0b09";
}
