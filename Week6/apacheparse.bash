#!/bin/bash

# Molly Shapiro - FA2023 - SYS320 01

# Week 6 Script for parsing Apache logs

# Check that the Apache file doesn't already exist

# Arguments using the position

APACHE_LOG="$1"

# Check if the file exists

if [[ ! -f ${APACHE_LOG} ]]
then
	echo "Please specify the path to a log file."
	exit 1
fi

# Looking for web scanners

sed -e 's/\[//g' -e 's/\"//g' ${APACHE_LOG} | \
egrep -i "test|shell|echo|passwd|select|phpmyadmin|setup|admin|w00t" | \
awk ' BEGIN { format = "%-15s %-20s %-7s %-6s %-10s %s\n"
		printf format, "IP", "Date", "Method", "Status", "Size", "URI"
		printf format, "--", "----", "------", "------", "----", "---" }
{ printf format, $1, $4, $6, $9, $10, $7 }'

# Obtain IP addresses, sorted and not including duplicates

function getips() {
	cat ${APACHE_LOG} | awk '{print $1}' | sort -u | tee badIPs.txt
}

# Creating an iptables ruleset (and create a document of bad IPs if it hasn't already been created)

function iptablesrules() {
	if [[ -f badIPs.txt ]]
		for eachIP in $(cat badIPs.txt)
		do
			echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a badIPs.iptables
		done
	else
		getips
		for eachIP in $(cat badIPs.txt)
		do 
			echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a badIPs.iptables
	fi
}

# Creating a Windows Powershell ruleset (and create a document of bad IPs if it hasn't already been created)

function windowsrules() {
	if [[ -f badIPs.txt ]]
	then
		for eachIP in $(cat badIPs.txt) 
		do
			echo "New-NetFirewallRule -DisplayName \"Block $eachIP\" -Direction Inbound -LocalPort Any -Protocol TCP -Action Block -RemoteAddress $eachIP" | tee -a windowsblocklist.ps1
		done
	else
		getips
		for eachIP in $cat badIPs.txt)
		do
			echo "New-NetFirewallRule -DisplayName \"Block $eachIP\" -Direction Inbound -LocalPort Any -Protocol TCP -Action Block -RemoteAddress $eachIP" | tee -a windowsblocklist.ps1
		done
	fi
}

# Call functions to create rule lists

iptablesrules
windowsrules
