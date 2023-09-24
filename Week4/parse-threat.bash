#!/bin/bash

# Molly Shapiro - Fall 2023 - SYS320 01

# Storyline: Extract IPs from emergingthreats.net and create firewall rulesets

# Obtain the threat intel file if it doesn't already exist. 

threatfile=/tmp/emerging-drop.suricata.rules

if test -f "${threatfile}"; then
	read -p "You have the threat file already. Do you want to download it again? [y/n] " userchoice
	if [[ "${userchoice}" == "y" ]]; then
		wget https://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -O ${threatfile}
	elif [[ "${userchoice}" == "n" ]]; then
		echo "Ok, we won't download the file again!"
	else
		echo "Sorry, that's not a valid answer."
	fi
else
	echo "You don't have the threat file yet. Let's download it!"
	wget https://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -O ${threatfile}
fi

# Extract IPs from the targetedthreat Github

targetedthreatfile=/tmp/targetedthreats.rules

if test -f "${targetedthreatfile}"; then
	read -p "You have the targetedthreat Github file already. Do you want to download it again? [y/n] " targeteduserchoice
	if [[ "${targeteduserchoice}" == "y" ]]; then
		wget https://raw.githubusercontent.com/botherder/targetedthreats/master/targetedthreats.csv -O ${targetedthreatfile}
	elif [[ "${targeteduserchoice}" == "n" ]]; then
		echo "Ok, we won't download the file again!"
	else
		echo "Sorry, that's not a valid answer."
	fi
else
	echo "You don't have the targetedthreat Github file yet. Let's download it!"
	wget https://raw.githubusercontent.com/botherder/targetedthreats/master/targetedthreats.csv -O ${targetedthreatfile}
fi

# Regex to extract the networks

egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0\/[0-9]{1,2}' ${threatfile} | sort -u | tee badIPs.txt

# Grep to extract the domain names

grep "domain" ${targetedthreatfile} | awk -F, '{print $2}' | sort -u | tee baddomains.txt

# Create a firewall ruleset for iptables

function iptablesrules() {
	for eachIP in $(cat badIPs.txt)
	do
		echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a badIPs.iptables
	done
}

# Create a firewall ruleset for MacOS

function macrules() {
	echo '
scrub-anchor "com.apple/*"
nat-anchor "com.apple/*"
dummynet-anchor "com.apple/*"
anchor "com.apple/*"
load anchor "com.apple" from "/etc/pf.anchors/com.apple"
' | tee pf.conf
	for eachIP in $(cat badIPs.txt)
	do
		echo "block in from ${eachIP} to any" | tee -a pf.conf
	done
}

# Create a firewall ruleset for Cisco

function ciscorules() {
	echo 'class-map match-any BAD_URLS' | tee ciscoblocklist.txt
	for line in $(cat baddomains.txt)
	do
		echo "match protocol http host $line" | tee -a ciscoblocklist.txt
	done
}

# Create a firewall ruleset for Windows Defender

function windowsrules() {
	for line in $(cat badIPs.txt)
	do
		echo "New-NetFirewallRule -DisplayName \"Block $line\" -Direction Outbound -LocalPort Any -Protocol TCP -Action Block -RemoteAddress $line" | tee -a windowsblocklist.ps1
	done
}

# Create a menu with switches to make it usable with the menu.bash script 

while getopts 'icwmh' OPTION; do
	case "$OPTION" in 
	I|i) iptablesrules
	;;
	C|c) ciscorules
	;;
	W|w) windowsrules
	;;
	M|m) macrules
	;;
	H|h)
		echo ""
		echo "Usage: $(basename $0) [-i] | [-c] | [-w] | [-m]"
		echo ""
		echo 1
	;;
	*)
		echo "Sorry, invalid option."
		echo 1
	;;
	esac
done
