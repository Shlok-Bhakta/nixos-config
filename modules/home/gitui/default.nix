{ ... }:
{
  programs.gitui = {
    enable = true;
    theme = builtins.readFile ./catppuccin-mocha.ron;
  };
}
