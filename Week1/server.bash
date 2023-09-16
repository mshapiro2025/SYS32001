#!/bin/bash

# Molly Shapiro - SYS320 01 Fall 2023

# Storyline: script to create a Wireguard server 

# Create a private key
privkey="$(wg genkey)"

# Create a public key
pubkey="$(echo ${privkey} | wg pubkey)"

# Set the addresses
address="10.254.132.0/24,172.16.28.0/24"

# Set the Listen port
lisport="4282"

# Create the format for the client configuration options
peerInfo="# ${address} 192.168.83.121:4282 ${pubkey} 8.8.8.8,1.1.1.1 1280 120 0.0.0.0/0"

# Create the configuration file

# Create a function to create the configuration file

create_config(){
	echo "${peerInfo}
[Interface]
Address=${address}
# PostUp = /etc/wireguard/wg-up.bash
# PostDown = /etc/wireguard/wg-down.bash
ListenPort = ${lisport}
PrivateKey= ${privkey}" > /etc/wireguard/wg0.conf
}

# Check if the configuration file exists
# If it does, ask the user if they want to overwrite it
# If it doesn't, create a new config file

configfile=/etc/wireguard/wg0.conf
if test -f "${configfile}"; then
    read -p "Your Wireguard configuration already exists. Would you like to overwrite it? [yes/no] " answer
    if [ "${answer}" == "yes" ]; then
        create_config
    elif [ "${answer}" == "no" ]; then
        echo "Ok, then we're done!"
    else
        echo "Sorry, that's not a valid answer."
    fi
else
    echo "You don't have a configuration file yet. Let's make one!"
    create_config
fi
