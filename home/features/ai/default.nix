{ ai-unstable, ... }:

let
  # Electron doesn't recognize Hyprland for automatic password-store
  # selection and falls back to basic_text, so safeStorage reports
  # encryption unavailable and T3 Code refuses to save remote
  # environments ("Desktop secure storage is unavailable in this system
  # context"). Force the libsecret backend explicitly.
  # Upstream: https://github.com/pingdotgg/t3code/issues/2880
  t3code = ai-unstable.t3code.overrideAttrs (oldAttrs: {
    postBuild = (oldAttrs.postBuild or "") + ''
      wrapProgram $out/bin/t3code-desktop --add-flags "--password-store=gnome-libsecret"
    '';
  });
in
{
  imports = [ ../opencode ];

  home.packages = [
    ai-unstable.claude-code
    ai-unstable.codex
    t3code
  ];
}
