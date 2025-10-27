{ lib, ... }:

{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      icon-theme = "candy-icons";
    };
    "org/gnome/nautilus/preferences" = {
      show-hidden-files = true;
    };
    "org/gnome/calculator" = {
      show-thousands = true;
      base = 10;
      word-size = lib.hm.gvariant.mkUint32 64;
    };
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
}
