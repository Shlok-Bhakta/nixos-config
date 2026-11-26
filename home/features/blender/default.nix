# Official Blender binary (newest release, CUDA/OptiX built in).
# Update: pkgs/blender-bin/update.sh, then rebuild.
{ pkgs, ... }:
{
  home.packages = [ (pkgs.callPackage ../../../pkgs/blender-bin { }) ];
}
