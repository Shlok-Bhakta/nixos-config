{
  waybar,
  fetchFromGitHub,
}:

# Waybar 0.15.0 still sends `dispatch workspace N`. Hyprland 0.55 Lua configs
# reject that, so workspace clicks do nothing. Master has the hl.dsp IPC fix.
(waybar.override { cavaSupport = false; }).overrideAttrs (old: {
  version = "0.15.0-unstable-2026-08-20";
  src = fetchFromGitHub {
    owner = "Alexays";
    repo = "Waybar";
    rev = "d561b9d6a11d34f459aab3986507d6907ff319c7";
    hash = "sha256-1JFW1v/v539cS0M3KwCf3NAo9ulNawyaOTxDe1naPe4=";
  };
  mesonFlags = (old.mesonFlags or [ ]) ++ [ "-Dwwan=disabled" ];
  # meson.project_version is still 0.15.0 on this commit.
  doInstallCheck = false;
})
