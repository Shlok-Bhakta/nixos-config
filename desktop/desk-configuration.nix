{ lib, config, pkgs, inputs, ... }:
{
  imports = [
    ../gen-configuration.nix 
  ];
  
  # environment.variables = {
  #   CUDA_PATH = "${pkgs.cudaPackages.cudatoolkit}";
  # };
  services.avahi.nssmdns = true;
}
