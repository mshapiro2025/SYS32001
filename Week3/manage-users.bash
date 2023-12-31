#!/bin/bash

# Molly Shapiro - Fall 2023 - SYS320 01

# Storyline: Script to add and delete VPN peers

while getopts 'hdau:' OPTION ; do
    case "$OPTION" in
        d) u_del=${OPTION}
        ;;
        a) u_add=${OPTION}
        ;;
        u) t_user=${OPTARG}
        ;;
        h) 
            echo ""
            echo "Usage: $(basename $0) [-a] | [-d] -u username"
            echo ""
            exit 1
        ;;
        *)
            echo "Invalid value."
            exit 1
        ;;

    esac
done

# Check to see if the -a and -d are empty or if they are both specified- throw an error

if [[ (${u_del} == "" && ${u_add} == "") || (${u_del} != "" && ${u_add} != "") ]]
then
    echo "Please specify -a or -d and the -u and username."
fi

# Check to see if -u is specified
if [[ (${u_del} != "" || ${u_add} != "") && ${t_user} == "" ]]
then
    echo "Please specify a user (-u)."
    echo "Usage: $(basename $0) [-a][-d] -u username}"
    exit 1
fi

# Delete a user
if [[ ${u_del} ]]
then
    if [[ $(grep -ic "${t_user}" /etc/wireguard/wg0.conf) -ge 1 ]]
    then
        echo "Deleting user..."
        sed -i "/# ${t_user} start/,/# ${t_user} end/d" /etc/wireguard/wg0.conf
        rm /etc/wireguard/${t_user}-wg0.conf
    else
        echo "This user doesn't exist in the wg0.conf file. "
    fi
fi

# Add a user

if [[ ${u_add} ]]
then
    if [[ $(grep -ic "${t_user}" /etc/wireguard/wg0.conf) -ge 1 ]]
    then
        echo "This user already exists in the wg0.conf file. "
    else
        echo "Creating user..."
        bash /root/SYS32001/Week2/peer.bash ${t_user}
    fi
fi
