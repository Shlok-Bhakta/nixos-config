{ lib, config, pkgs, inputs, unstable, ... }:
{
  imports = [
    ../../modules/system/configuration.nix
  ];
  fonts.fontconfig.enable = true; 
  environment.variables = {
    CUDA_PATH = "${pkgs.cudaPackages.cudatoolkit}";
  };
  services.avahi.nssmdns4 = true;
}
