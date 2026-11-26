{ ... }:
{
  # Rootless by default: no daemon, containers run as the invoking user.
  # Images/containers live in ~/.local/share/containers.
  virtualisation.podman = {
    enable = true;
    # Provides a `docker` alias for the podman CLI.
    dockerCompat = true;
    # Lets containers on the default network resolve each other by name (compose).
    defaultNetwork.settings.dns_enabled = true;
  };

  # Point Docker API clients (docker-compose, lazydocker, testcontainers) at the
  # per-user rootless podman socket, which the podman module enables.
  environment.extraInit = ''
    if [ -z "$DOCKER_HOST" -a -n "$XDG_RUNTIME_DIR" ]; then
      export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
    fi
  '';
}
