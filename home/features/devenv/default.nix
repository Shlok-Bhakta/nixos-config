{ unstable, ... }:
{
  home.packages = [ unstable.devenv ];

  # direnv + nix-direnv so `use devenv` in .envrc auto-loads shells on cd
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config.global.hide_env_diff = true;
  };
}
