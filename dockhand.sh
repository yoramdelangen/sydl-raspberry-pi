# Create the directory on the host
mkdir -p /opt/dockhand

systemctl --user start podman.socket

# Use matching paths with DATA_DIR
podman run -d \
  --name dockhand \
  -p 3000:3000 \
  -v /run/user/$UID/podman/podman.sock:/var/run/docker.sock:Z \
  -v /opt/dockhand:/opt/dockhand \
  -e DATA_DIR=/opt/dockhand \
  fnsys/dockhand:latest
