{ unstable, ... }:
{
  programs.obs-studio = {
    enable = true;
    package = unstable.obs-studio;
  };
}
