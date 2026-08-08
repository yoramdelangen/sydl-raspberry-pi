#!/usr/bin/env bash

if [[ -n "${1:-}" ]]; then
    username="$1"
else
    default_user="$USER"
    read -rp "Username [$default_user]: " username
    username="${username:-$default_user}"
fi

# check if it was enabled already
if [[ "$(loginctl show-user "$username" -p Linger --value)" == "yes" ]]; then
    echo "Linger is enabled"
else
    echo "Linger is disabled, but will be activated"
    # make sure podman 
    sudo loginctl enable-linger "$username"
    
    loginctl show-user "$username" -p Linger
fi
