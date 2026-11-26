{
  waybar,
}:

# 0.16.0+ includes the hl.dsp IPC fix for Hyprland 0.55 Lua configs, so no
# source override is needed anymore.
(waybar.override { cavaSupport = false; }).overrideAttrs (old: {
  mesonFlags = (old.mesonFlags or [ ]) ++ [ "-Dwwan=disabled" ];
})
