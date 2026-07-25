if [[ ! -d /opt/beszel ]]; then
    sudo mkdir -p /opt/
    sudo chown "$UID:$GID" /opt/beszel
fi

docker run -d \
  --name beszel \
  --restart=unless-stopped \
  -v /opt/beszel:/beszel_data \
  -e APP_URL=http://localhost:8090 \
  -p 8090:8090 \
  henrygd/beszel
