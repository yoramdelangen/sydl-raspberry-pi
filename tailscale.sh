mkdir -p /opt/tailscale-state

podman run -d \
   --name tailscale \
   --hostname tailscale-nginx \
   --env-file=tailscale.env \
   -v /opt/tailscale-state:/var/lib/tailscale \
   --cap-add=net_admin \
   --cap-add=net_raw \
   --restart unless-stopped \
   tailscale/tailscale:latest
