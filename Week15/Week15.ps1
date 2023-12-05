# Molly Shapiro - FA2023 - SYS32001
# Parsing threat intel from emergingthreats.net and creating block lists

# Array of websites with threat intel- I'm getting 404 errors with these links so I took a URL from our bash threat intel assignment to use. 
#$threaturls = @('https://rules.emergingthreats.net/blockrules-emergingbotcc.rules','https://rules.emergingthreats.net/blockrules/compromised-ips.txt')
$threaturls = @('https://raw.githubusercontent.com/botherder/targetedthreats/master/targetedthreats.csv')

# Loop thru URLs to make the rules lists
foreach ($u in $threaturls) {

# Get the file name
    $temp = $u.split("/")
    $file_name = $temp[-1]
    if (Test-Path $file_name) {
        continue
    } else {
# Get the rules list
    Invoke-WebRequest -Uri $u -OutFile $file_name
    }

}

# Array with the file name
$input_paths = @('.\targetedthreats.csv')

# Get the IP addresses
$regex = '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'

# Make the temp IP list
select-string -Path $input_paths -Pattern $regex | `
ForEach-Object { $_.Matches } | `
ForEach-Object { $_.Value } | Sort-Object | Get-Unique |`
Out-File -FilePath "ips-bad.tmp"

#Print options menu
print("There are two options for IP rules: iptables and Windows Firewall.")
print("Please select the option from the below menu:")
print("[0] iptables")
print("[1] Windows Firewall")

# Get user input for which one they want
$userchoice = read-host -Prompt "Please select 0 or 1"

# Make a function for iptables rules
function iptables() {
    (Get-Content -Path ".\ips-bad.tmp") | % `
    { $_ -replace "^","iptables -A INPUT -s " -replace "$", " -j DROP"} | `
    Out-File -FilePath "iptables.bash"
}

# Make a function to create Windows firewall rules
function windowsrules() {
    foreach ($line in Get-Content -Path ".\ips-bad.tmp") {
        echo "New-NetFirewallRule -DisplayName `"Block $line`" -Direction Inbound -LocalPort Any -Protocol TCP -Action Block -RemoteAddress $line" >> "badips.ps1"

    }
}

# Switch to run either function
switch ($userchoice) {
    0 { iptables }
    1 { windowsrules }
}
