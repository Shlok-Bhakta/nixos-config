{ inputs, pkgs }:

import inputs.UNSTABLE {
  system = pkgs.system;
  config = {
    allowUnfree = true;
  };
}