PORT=13378
LOC=/srv/audiobookshelf
# LOC=.

docker run -it --rm \
 -p "$PORT:80" \
 -v "$LOC/config:/config" \
 -v "$LOC/metadata:/metadata" \
 -v "$LOC/audiobooks:/audiobooks" \
 -v "$LOC/podcasts:/podcasts" \
 --name audiobookshelf \
 -e TZ="Europe/Amsterdam" \
 ghcr.io/advplyr/audiobookshelf:latest

sudo tailscale serve --bg --tcp "$PORT" "tcp://dockhand-agent-hawser:$PORT"
