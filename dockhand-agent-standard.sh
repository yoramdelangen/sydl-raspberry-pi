TOKEN=${1:-}

if [ -z "$TOKEN" ]; then
    echo "Missing token argument"
    exit 1
fi

sudo mkdir -p /opt/dockhand-agent-hawser
sudo chown -R "$(whoami)" /opt/dockhand-agent-hawser

NAME=dockhand-agent-hawser

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

# requires podman socket
podman run -d \
  --name "$NAME" \
  --restart unless-stopped \
  --network sydl-network \
  -v /run/user/$UID/podman/podman.sock:/var/run/docker.sock:Z \
  -v /opt/dockhand-agent-hawser:/opt/hawser-stacks \
  -e STACKS_DIR=/opt/hawser-stacks \
  -p 127.0.0.1:2376:2376 \
  -e "TOKEN=$TOKEN" \
  ghcr.io/finsys/hawser:latest

if [ ! -f "$HOME/.config/systemd/user/container-$NAME.service" ]; then
    mkdir -p "$HOME/.config/systemd/user/"
    cd $HOME 
    # Generate the systemd file
    podman generate systemd --files --name "$NAME"
    mv "container-$NAME.service" ~/.config/systemd/user/
	
    systemctl --user daemon-reload
    systemctl --user enable "container-$NAME.service"

    systemctl --user status "container-$NAME.service"
    systemctl --user stop "container-$NAME.service"
    systemctl --user start "container-$NAME.service"
    systemctl --user status "container-$NAME.service"
fi

# when running together with tailscale, we should connect both containers in the same network.
# and run the following command to make sure the dockhand agent container is being served via tailscale.
# The following command stores the serve in a config file, which is persistent;
#
# podman exec tailscale tailscale serve --bg --tcp=2376 tcp://dockhand-agent-hawser:2376
