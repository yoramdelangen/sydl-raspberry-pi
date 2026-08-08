
if [[ -n "${1:-}" ]]; then
    username="$1"
else
    default_user="$USER"
    read -rp "Username [$default_user]: " username
    username="${username:-$default_user}"
fi

sudo mkdir -p /opt/tailscale-state
sudo chown -R "$username" /opt/tailscale-state/

NAME="tailscale"

podman run -d \
   --name "$NAME" \
   --hostname tailscale-nginx \
   --env-file=tailscale.env \
   -v /opt/tailscale-state:/var/lib/tailscale \
   --cap-add=net_admin \
   --cap-add=net_raw \
   --restart unless-stopped \
   tailscale/tailscale:latest

if [ ! -f "$HOME/.config/systemd/user/container-$NAME.service" ]; then
    mkdir -p "$HOME/.config/systemd/user/"
    cd $HOME 
    # Generate the systemd file
    podman generate systemd --files --name "$NAME"
    mv "container-$NAME.service" ~/.config/systemd/user/
	
    systemctl --user daemon-reload
    systemctl --user enable "container-$NAME.service"

    systemctl --user status container-tailscale.service
    systemctl --user stop container-tailscale.service
    systemctl --user start container-tailscale.service
    systemctl --user status container-tailscale.service
fi

