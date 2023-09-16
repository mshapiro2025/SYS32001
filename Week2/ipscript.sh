#!/bin/bash

# Molly Shapiro - Fall 2023 - SYS320 01

# Storyline: this script uses the ip addr command to only show the relevant IP address

# The first part of this script is the ip addr command
# The second part of this script looks for the string 'inet', which will start all IP addresses with ip addr
# The third part of this script excludes the address 127.0.0.1, which is the local loopback address and is not relevant
# The final part of this script is using awk.
# awk breaks down the text it is given by white space, so each string separated by white space gets assigned a variable
# starting at $1. Since 'inet' is the first string and the IP address is the second, I used $2. 

ip addr | grep 'inet ' | grep -v 127.0.0.1 | awk '{print $2}'
