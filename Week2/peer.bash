#!/bin/bash

# Molly Shapiro - Fall 2023 - SYS320 01

# Storyline: create peer VPN configuration file

# Ask the user for the peer's name

if [[ $1 == "" ]]
then
    read -p "What is the peer's name? " peername
else
    peername="$1"
fi
# Generate key

privkey="$(wg genkey)"

# Generate a public key

pubkey="$(echo ${privkey} | wg pubkey)"

# Generate a preshared key

prekey="$(wg genpsk)"

# 10.254.132.0/24,172.16.28.0/24 192.168.83.121:4282 [pubkey] 8.8.8.8,1.1.1.1 1280 120 0.0.0.0/0

# Endpoint

end="$(head -1 /etc/wireguard/wg0.conf | awk '{print $3}')"

# Server Public Key

pub="$( head -1 /etc/wireguard/wg0.conf | awk '{print $4}')"

# DNS Servers

dns="$(head -1 /etc/wireguard/wg0.conf | awk '{print $5}')"

# MTU

mtu="$(head -1 /etc/wireguard/wg0.conf | awk '{print $6}')"

# KeepAlive

keep="$(head -1 /etc/wireguard/wg0.conf | awk '{print $7}')"

# ListenPort 

lisport="$(shuf -n1 -i 40000-50000)"

# Generate the IP address

tempip=$(grep AllowedIPs /etc/wireguard/wg0.conf | sort -u | tail -1| cut -d\. -f4 | cut -d\/ -f1)
ip=$(expr ${tempip} + 1)

# Default routes for VPN

routes="$(head -1 /etc/wireguard/wg0.conf | awk '{print $8}')"

# Create the client configuration file

create_config(){
	echo "[Interface]
Address = 10.254.132.${ip}/24
DNS = ${dns}
ListenPort = ${lisport}
MTU = ${mtu}
PrivateKey = ${privkey}

[Peer]
AllowedIPs = ${routes} 
PersistentKeepalive = ${keep}
PresharedKey = ${prekey}
PublicKey = ${pubkey}
Endpoint = ${end}" > /etc/wireguard/${peername}-wg0.conf
}

# Add peer configuration to the server config
peertoserver(){
echo "
# ${peername} start
[Peer]
PublicKey = ${pubkey}
PresharedKey = ${prekey}
AllowedIPs = 10.234.132.${ip}/32
# ${peername} end
" | tee -a /etc/wireguard/wg0.conf
} 

# Check if the peer file exists

# Filename variable

conffile=/etc/wireguard/${peername}-wg0.conf

if test -f "${conffile}"; then
	read -p "This peer already has a configuration file. Do you want to overwrite it? [y/n] " uchoice
	if [ "${uchoice}" == "y" ]; then
		create_config
		peertoserver
	elif [ "${uchoice}" == "n" ]; then
		echo "Ok, then we're done!"
	else
		echo "Sorry, that's not a valid answer."
	fi
else
	echo "You don't have a configuration file yet. Let's make one!"
	create_config
	peertoserver
fi
