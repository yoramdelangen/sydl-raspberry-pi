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
