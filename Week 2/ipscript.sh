#!/bin/bash

# Molly Shapiro - Fall 2023 - SYS320 01

# Storyline: this script uses the ip addr command to only show the relevant IP address

ip addr | grep 'inet ' | grep -v 127.0.0.1 | awk '{print $2}'
