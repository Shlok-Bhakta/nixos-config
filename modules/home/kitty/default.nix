{ ... }:
{
  programs.kitty = {
    enable = true;
    font.name = "CaskaydiaCove Nerd Font";
    themeFile = "Catppuccin-Mocha";
    settings = {
      shell = "tmux";
    };
  };
}
