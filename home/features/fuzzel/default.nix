{ ... }:
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "kitty";
        layer = "overlay";
        anchor = "center";
        lines = 15;
        width = 45;
        font = "CaskaydiaCove Nerd Font:size=20";
      };
      colors = {
        background = "#11111bff";
        text = "#cdd6f4ff";
        match = "#181825ff";
        selection = "#1e1e2eff";
        selection-text = "#b4befeff";
        border = "#89b4faff";
      };
      border = {
        width = 2;
      };
    };
  };
}
