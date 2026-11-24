TOKEN=${1:-}

if [ -z "$TOKEN" ]; then
    echo "Missing token argument"
    exit 1
fi

sudo mkdir -p /opt/dockhand-agent-hawser
sudo chown -R "$(whoami)" /opt/dockhand-agent-hawser

NAME=dockhand-agent-hawser

# requires docker socket
docker run -d \
  --name "$NAME" \
  --restart unless-stopped \
  -v /run/kiri/docker.sock:/var/run/docker.sock:Z \
  -v /opt/dockhand-agent-hawser:/opt/hawser-stacks \
  -e STACKS_DIR=/opt/hawser-stacks \
  -p 127.0.0.1:2376:2376 \
  -e "TOKEN=$TOKEN" \
  ghcr.io/finsys/hawser:latest


# when running together with tailscale, we should connect both containers in the same network.
# and run the following command to make sure the dockhand agent container is being served via tailscale.
# The following command stores the serve in a config file, which is persistent;
#
# podman exec tailscale tailscale serve --bg --tcp=2376 tcp://dockhand-agent-hawser:2376
# or
# sudo tailscale serve --bg --tcp 2376 tcp://dockhand-agent-hawser:2376

