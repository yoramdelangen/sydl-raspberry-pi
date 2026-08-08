# Create the directory on the host
sudo mkdir -p /opt/dockhand
sudo chown -R "$(whoami)" /opt/dockhand

if ! systemctl --user is-enabled --quiet podman.socket ||
   ! systemctl --user is-active --quiet podman.socket; then
    echo "Podman socket is not fully enabled/active"

    systemctl --user start podman.socket
    systemctl --user enable podman.socket

    # Verify
    systemctl --user is-enabled podman.socket
    ls -la /run/user/$(id -u)/podman/podman.sock
elif systemctl --user is-enabled --quiet podman.socket && systemctl --user is-active --quiet podman.socket; then
    echo "Podman.socket was already activated and enabled during startup"
else
    echo "Something was unexpected, enabled?"
    systemctl --user is-enabled podman.socket
    echo "Podman.socket was started already"
    ls -la /run/user/$(id -u)/podman/podman.sock
fi

# Use matching paths with DATA_DIR
podman run -d \
  --name dockhand \
  -p 3000:3000 \
  -v /run/user/$UID/podman/podman.sock:/var/run/docker.sock:Z \
  -v /opt/dockhand:/opt/dockhand \
  -e DATA_DIR=/opt/dockhand \
  fnsys/dockhand:latest
