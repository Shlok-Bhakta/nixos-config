{
  inputs,
  pkgs,
  ...
}:

let
  # Imports must be resolved before Home Manager's config-derived pkgs.
  sourcePkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
  source = (sourcePkgs.callPackage ../../../pkgs/tabcomplete-engine { }).source;
in
{
  imports = [ "${source}/nix/nes/home-manager.nix" ];

  # Sweep next-edit 0.5B on the CPU with the workspace context engine.
  # Tab jumps to / accepts suggestions; telemetry goes to the collector.
  services.tabcomplete-nes = {
    enable = true;
    package = pkgs.callPackage ../../../pkgs/tabcomplete-engine { };
    threads = 4;
    threadsBatch = 6;
    predictKey = "<M-p>";
  };
}
