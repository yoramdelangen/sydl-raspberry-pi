# Installation

Request auth-key on Tailscale:

```
Settings -> Keys -> Auth-keys (preferable single use)
```

copy tailscale env so we can register with entered auth-key

```bash
cp tailscale.env.example tailscale.env
```

## Allow `docker.io` and `ghcr.io` for pulling images

```bash
sudo vi /etc/containers/registries.conf
```

## Run the scripts

```bash
# start tailscale container
./tailscale.sh

# starting dockhand container
./dockhand.sh
```
