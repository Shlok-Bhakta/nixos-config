{ unstable, ... }:
{
  programs.yazi = {
    enable = true;
    package = unstable.yazi-unwrapped;
  };
}
