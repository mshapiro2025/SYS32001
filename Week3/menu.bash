#!/bin/bash

# Molly Shapiro - Fall 2023 - SYS320 01

# Storyline: Menu for admin, VPN, and security functions

# Initialize invalid function

function invalid() {
    echo ""
    echo "Invalid option."
    echo ""
    sleep 2
}

# Initialize menu function

function menu() {
    # clear screen
    clear
    # print options to screen
    echo "[A]dmin Menu"
    echo "[S]ecurity Menu" 
    echo "[E]xit"
    read -p "Please enter a choice [1-3]: " userchoice

    case "$userchoice" in 
        A|a) adminmenu
        ;;
        S|s) securitymenu
        ;;
        E|e)exit 0
        ;;
        *)
            invalid
            menu
        ;;
    esac
}


# Initialize admin menu function

function adminmenu() {
    clear
    echo "[L]ist Running Processes"
    echo "[N]etwork Sockets"
    echo "[V]PN Menu"
    echo "[M]ain menu"
    echo "[E}xit"
    read -p "Please enter a choice [L, N, V, M, E]: " userchoice

    case "$userchoice" in
        L|l) ps -ef | less
        ;;
        N|n) netstat -an --inet | less
        ;;
        V|v) vpn
        ;;
        M|m) menu
        ;;
        E|e) exit 0
        ;;
        *)
            invalid
            adminmenu
        ;;
    esac
adminmenu
}

# Initialize VPN menu function

function vpn() {
    clear
    echo "[A]dd a peer"
    echo "[D]elete a peer"
    echo "[B]ack to admin menu"
    echo "[M]ain menu"
    echo "[E]xit"
    read -p "Please select an option [A, D, B, M, E]: " userchoice

    case "$userchoice" in
        A|a) read -p "What peer would you like to create? " peerchoice
            bash manage-users.bash -a -u ${peerchoice}
            tail -6 /etc/wireguard/wg0.conf
            sleep 3
        ;;
        D|d) read -p "What peer would you like to delete? " peerchoice
            bash manage-users.bash -d -u ${peerchoice}
            tail -6 /etc/wireguard/wg0.conf
            sleep 3
            ls /etc/wireguard/wg0.conf
            sleep 3
        ;;
        B|b) adminmenu
        ;;
        M|m) menu
        ;;
        E|e) exit 0
        ;;
        *)
            invalid
        ;;
    esac
vpn 
}

# Initialize block list menu function

function blockmenu() {
	clear
	echo "[C]isco URL blocklist generator"
	echo "[W]indows blocklist generator"
	echo "[M]acOS blocklist generator"
	echo "[I]ptables blocklist generator"
	echo "[S]ecurity menu"
	echo "[B]ack to main menu"
	echo "[E]xit"
	read -p "Please choose an option [C, W, M, I, S, B, E] " blockchoice
	
	case "$blockchoice" in
	C|c) bash /root/SYS32001/Week4/parse-threat.bash -c
	;;
	W|w) bash /root/SYS32001/Week4/parse-threat.bash -w
	;;
	M|m) bash /root/SYS32001/Week4/parse-threat.bash -m
	;;
	I|i) bash /root/SYS32001/Week4/parse-threat.bash -i
	;;
	S|s) securitymenu
	;;
	B|b) menu
	;;
	E|e) exit 0
	;;
	*) invalid
	;;
	esac
blockmenu
}

# Initialize security menu function

function securitymenu() {
    clear
    echo "[L]ist open network sockets"
    echo "[C]heck for non-root users with a UID of 0"
    echo "[S]ee the last 10 logged-in users"
    echo "[I]nspect currently logged-in users"
    echo "[B]lock list menu"
    echo "[M]ain menu"
    echo "[E]xit"
    read -p "Please choose an option [L, C, S, I, B, M, E]: " userchoice
    case "$userchoice" in
        L|l) netstat -an --inet | less
        ;;
        C|c) 
            if [[ $(cat /etc/passwd | awk -F: '{print $3}' | grep -x '0') == '0' ]];
            then
                echo "There is only one user with the UID 0."
            else
                echo "There is more than one user with UID 0."
            fi
            sleep 2
        ;;
        S|s) last | grep -v "reboot" | tail -10 | less
        ;;
        I|i) users | less
        ;;
	B|b) blockmenu
	;;
        M|m) menu
        ;;
        E|e) exit 0
        ;;
        *) invalid
        ;;
    esac
securitymenu
}
menu
