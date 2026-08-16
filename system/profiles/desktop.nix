{ ... }:

{
  imports = [
    ./workstation.nix
    ../features/cuda
    ../features/steam
    ../features/nix-serve
  ];
}
