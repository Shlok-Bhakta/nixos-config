{
  lib,
  writeShellApplication,
  bash,
  coreutils,
  systemd,
}:

writeShellApplication {
  name = "caffeinate";
  runtimeInputs = [
    bash
    coreutils
    systemd
  ];
  text = builtins.readFile ./caffeinate.sh;

  meta = {
    description = "Keep the session awake, with a tiny coffee cup";
    license = lib.licenses.mit;
    mainProgram = "caffeinate";
    platforms = lib.platforms.linux;
  };
}
