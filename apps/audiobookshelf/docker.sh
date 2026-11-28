PORT=13378
V_DATA=/srv/audiobookshelf
# V_DATA=.

docker run -it --rm \
 -p "$PORT:80" \
 -v "$V_DATA/config:/config" \
 -v "$V_DATA/metadata:/metadata" \
 -v "$V_DATA/audiobooks:/audiobooks" \
 -v "$V_DATA/podcasts:/podcasts" \
 --name audiobookshelf \
 -e TZ="Europe/Amsterdam" \
 ghcr.io/advplyr/audiobookshelf:latest

# sudo tailscale serve --bg --tcp "$PORT" "tcp://audiobookshelf:$PORT"
