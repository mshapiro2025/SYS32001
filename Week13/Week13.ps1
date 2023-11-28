# Molly Shapiro - FA2023 - SYS320 01
# Storyline: create a script for automating SSH logins
cls

# Get IP address and username to connect to
$ip = read-host -Prompt "Please enter the host you want to connect to (ex. 192.168.1.1)"
$username = read-host -Prompt "Please enter the username you would like to connect to"

# Login to a remote SSH server
New-SSHSession -ComputerName $ip -Credential (Get-Credential $username)

while ($True){
    # Add a prompt to run commands
    $newcmd = read-host -Prompt "Please enter the command you would like to run"

    # Run command on remote SSH server
    (Invoke-SSHCommand -index 0 $newcmd).Output
}

# $remotepath = read-host -Prompt "Please enter the remote path you would like to put the file in"
# $localpath = read-host -Prompt "Please enter the local path of the file you would like to send"
# Set-SCPFile -Computername $ip -Credential (Get-Credential $username -RemotePath $remotepath -LocalFile $localpath
# Get-SCPFile -Computername $ip -Credential (Get-Credential $username -RemotePath $remotepath -LocalFile $localpath

# Spambots- Please note I did NOT test this script, I just followed along with the video. 

<#
$message = "hello there"
$emailaddresses = @('send@gmail.com', 'newemail@gmail.com', 'hello@gmail.com')
while ($true) {
    foreach ($email in $emailaddresses) {
        Send-MailMessage -from "molly.shapiro@champlain.edu" -to $email -Subject "Hey There" -Body $message" -SmptServer 192.168.1.1
    }
}
#>
