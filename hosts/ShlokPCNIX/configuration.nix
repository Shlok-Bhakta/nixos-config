{ lib, config, pkgs, inputs, unstable, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./system-settings.nix
    ../../modules/system/configuration.nix
  ];
  # support for my wakom drawing tablet!

  # lets hope they merge this in lol 
  # anyways future me how you doin?? I hope you are doing well
  # future me was doing great, how are you doing even further future me?
  
  hardware.opentabletdriver = {
    enable = true;
    # package = unstable.opentabletdriver;
  };
  # environment.variables = {
  #   CUDA_PATH = "${pkgs.cudaPackages.cudatoolkit}";
  # };
  services.avahi.nssmdns = true;
}
