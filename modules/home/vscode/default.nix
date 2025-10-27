{ inputs, pkgs, ... }:
let
  unstable = import ../../../unstable.nix { inherit inputs pkgs; };
in
{
  programs.vscode = {
    enable = true;
    package = unstable.vscode.fhs;
    profiles.default.extensions = with unstable.vscode-extensions; [
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
      vscodevim.vim
      yzhang.markdown-all-in-one
      jnoortheen.nix-ide
    ];
  };
}
