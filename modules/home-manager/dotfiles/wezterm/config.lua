''-- Your lua code / config here
return {
  font = wezterm.font("CaskaydiaCove Nerd Font"),
  font_size = 16.0,
  color_scheme = "Catppuccin Mocha",
  default_prog = { "zsh", "--login", "-c", "tmux attach -t dev || tmux new -s dev" },
}
''