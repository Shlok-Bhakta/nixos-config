{ pkgs, ... }:

let
  excalidrawIcon = pkgs.fetchurl {
    url = "https://excalidraw.com/apple-touch-icon.png";
    sha256 = "sha256-tqbERkMZo7H66zELy4rCQGGyMBzhndyBRTZ1u9Rh7Y8="; # placeholder
  };
in{
  xdg.desktopEntries.excalidraw = {
    name = "Excalidraw";
    genericName = "Whiteboard";
    exec = "brave --app=https://excalidraw.com";
    terminal = false;
    categories = [ "Graphics" "Office" ];
    icon = "${excalidrawIcon}";
  };  
}
