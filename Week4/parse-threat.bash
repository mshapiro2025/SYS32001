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
	wget https://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -O ${targetedthreatfile}
fi

# Regex to extract the networks

egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0\/[0-9]{1,2}' ${threatfile} | sort -u | tee badIPs.txt

egrep -o '"http*' ${targetedthreatfile} | sort -u | tee -a badIPs.txt

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

function ciscorules() {
	echo 'class-map match-any BAD_URLS" | tee

function blockmenu() {
	clear
	echo "[I]ptables rules"
	echo "[C]isco rules"
	echo "[W]indows rules"
	echo "[M]acOS rules"
	echo "[E]xit"
	read -p "Please enter a choice [I, C, W, M, E] " optionchoice

	case "$OPTION" in 
	I|i) iptablesrules
	;;
	C|c)
	;;
	W|w)
	;;
	M|m) macrules
	;;
	E|e) exit 0
	;;
	*)
		echo "Sorry, invalid option."
		menu
	esac
}

# Call menu function

menu
