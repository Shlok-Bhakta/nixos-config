{ lib, config, pkgs, inputs, ... }:
{
  imports = [
    ../gen-configuration.nix 
  ];
  fonts.fontconfig.enable = true; 
  environment.variables = {
    CUDA_PATH = "${pkgs.cudaPackages.cudatoolkit}";
  };
  services.avahi.nssmdns4 = true;
}
