{ inputs, pkgs }:

import inputs.UNSTABLE {
  system = pkgs.stdenv.hostPlatform.system;
  config = {
    allowUnfree = true;
  };
}