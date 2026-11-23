{
  lib,
  rustPlatform,
  src,
}:

rustPlatform.buildRustPackage {
  pname = "dekit";
  version =
    (lib.importTOML "${src}/src/Cargo.toml").package.version + "-unstable-${src.shortRev or "dirty"}";

  inherit src;

  # Read deps straight from upstream's lockfile so updates need no hash bumps.
  cargoLock.lockFile = "${src}/Cargo.lock";

  cargoBuildFlags = [
    "--package"
    "dekit"
  ];

  # Test suite spawns PTYs and a runner daemon, which the sandbox does not allow.
  doCheck = false;

  meta = {
    description = "Process manager for dev and prod (successor to mprocs)";
    homepage = "https://dekit.run";
    license = lib.licenses.mit;
    mainProgram = "dekit";
    platforms = lib.platforms.linux;
  };
}
