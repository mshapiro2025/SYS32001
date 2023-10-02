# !/bin/bash

# Molly Shapiro - Fall 2023 - SYS320 01

# Storyline: This is a script made to perform security checks of settings and permissions as identified in the CIS Benchmark
# file. 

# Create a function that takes four variables- security policy name, the value the policy should be, the current value, and the remediation, and compares the current and correct values, then returns an output based on that. 

function checks() {
	if [[ $2 != $3 ]]
	then
		echo -e "\e[1;31mThe $1 is not compliant. The current value should be: $2. The current value is: $3.\e[0m"
		echo -e "\e[1;31mThe remediation for this policy is: $4.\e[0m"
	else
		echo -e "\e[1;32mThe $1 is compliant. The current value is $3.\e[0m"
fi
}

# Check that IP forwarding is disabled.

ipforward=$(sysctl net.ipv4.ip_forward | awk '{print $3}')
checks "ip forwarding policy" "0" "${ipforward}" "Set the net.ipv4.ip_forward parameter in the /etc/sysctl.conf or a /etc/sysctl.d/* file to 0"

# Check that secure ICMP redirects are not accepted

icmpred=$(sysctl net.ipv4.conf.all.secure_redirects | awk '{print $3}')
checks "ICMP redirection policy" "0" "$icmpred" "Set the net.ipv4.conf.all.secure_redirects parameter in the /etc/sysctl.conf or a /etc/sysctl.d/* file to 0"

# Check that perms on /etc/crontab are configured properly

cronpermsu=$(stat /etc/crontab | grep "Access: (" | awk '{print $5}')
cronpermsg=$(stat /etc/crontab | grep "Access: (" | awk '{print $9}')
cron_perms=$(stat /etc/crontab | grep "Access: (" | awk '{print $2}')
if [[ $cron_perms == *"------"* ]]
then
	cron_perms="(****/****------)"
	cronperms=$cronpermsu$cronpermsg$cron_perms
else
	cronperms=$cronpermsu$cronpermsg$cron_perms
fi
checks "perms on /etc/crontab" '0/0/(****/****------)' "$cronperms" "Run the chown root:root /etc/crontab and chmod og-rwx /etc/crontab commands"

# Check that perms on /etc/cron.hourly are configured properly

cronpermsu=$(stat /etc/cron.hourly | grep "Access: (" | awk '{print $5}')
cronpermsg=$(stat /etc/cron.hourly | grep "Access: (" | awk '{print $9}')
cron_perms=$(stat /etc/cron.hourly | grep "Access: (" | awk '{print $2}')
if [[ $cron_perms == *"------"* ]]
then
	cron_perms="(****/****------)"
	cronperms=$cronpermsu$cronpermsg$cron_perms
else
	cronperms=$cronpermsu$cronpermsg$cron_perms
fi
checks "perms on /etc/cron.hourly" "0/0/(****/****------)" "$cronperms" "Run the chown root:root /etc/cron.hourly and chmod og-rwx /etc/cron.hourly commands"


# Check that perms on /etc/cron.daily are configured properly

cronpermsu=$(stat /etc/cron.daily | grep "Access: (" | awk '{print $5}')
cronpermsg=$(stat /etc/cron.daily | grep "Access: (" | awk '{print $9}')
cron_perms=$(stat /etc/cron.daily | grep "Access: (" | awk '{print $2}')
if [[ $cron_perms == *"------"* ]]
then
	cron_perms="(****/****------)"
	cronperms=$cronpermsu$cronpermsg$cron_perms
else
	cronperms=$cronpermsu$cronpermsg$cron_perms
fi
checks "perms on /etc/cron.daily" "0/0/(****/****------)" "$cronperms" "Run the chown root:root /etc/cron.daily and chmod og-rwx /etc/cron.daily commands"


# Check that perms on /etc/cron.weekly are configured properly

cronpermsu=$(stat /etc/cron.weekly | grep "Access: (" | awk '{print $5}')
cronpermsg=$(stat /etc/cron.weekly | grep "Access: (" | awk '{print $9}')
cron_perms=$(stat /etc/cron.weekly | grep "Access: (" | awk '{print $2}')
if [[ $cron_perms == *"------"* ]]
then
	cron_perms="(****/****------)"
	cronperms=$cronpermsu$cronpermsg$cron_perms
else
	cronperms=$cronpermsu$cronpermsg$cron_perms
fi
checks "perms on /etc/cron.weekly" "0/0/(****/****------)" "$cronperms" "Run the chown root:root /etc/cron.weekly and chmod og-rwx /etc/cron.weekly commands"


# Check that perms on /etc/cron.monthly are configured properly

cronpermsu=$(stat /etc/cron.monthly | grep "Access: (" | awk '{print $5}')
cronpermsg=$(stat /etc/cron.monthly | grep "Access: (" | awk '{print $9}')
cron_perms=$(stat /etc/cron.monthly | grep "Access: (" | awk '{print $2}')
if [[ $cron_perms == *"------"* ]]
then
	cron_perms="(****/****------)"
	cronperms=$cronpermsu$cronpermsg$cron_perms
else
	cronperms=$cronpermsu$cronpermsg$cron_perms
fi
checks "perms on /etc/cron.monthly" "0/0/(****/****------)" "$cronperms" "Run the chown root:root /etc/cron.monthly and chmod og-rwx /etc/cron.monthly commands"


# Check that perms on /etc/passwd are configured properly

passwdu=$(stat /etc/passwd | grep "Access: (" | awk '{print $5}')
passwdg=$(stat /etc/passwd | grep "Access: (" | awk '{print $9}')
passwd_perms=$(stat /etc/passwd | grep "Access: (" | awk '{print $2}')
if [[ $passwd_perms == *"644"* ]]
then
	passwd_perms="(*644/**********)"
	passwdperms=$passwdu$passwdg$passwd_perms
else
	passwdperms=$passwdu$passwdg$passwd_perms
fi
checks "perms on /etc/passwd" "0/0/(*644/**********)" "$passwdperms" "Run the chown root:root /etc/passwd and chmod 644 /etc/passwd commands"

# Check what users have a UID of 0. 

uidusers=$(cat /etc/passwd | awk -F: '($3 == 0) {print $1}')
checks "number of users with UID 0" "root" "${uidusers}" "Remove any users with a UID of 0 other than root or assign them a new UID if applicable"


