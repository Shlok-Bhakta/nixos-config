{pkgs ? import <nixpkgs> {}}:

pkgs.mkShell
{
  # https://search.nixos.org/
  nativeBuildInputs = with pkgs; [
    bun
  ];
  shellHook = ''
    zsh
  '';
}