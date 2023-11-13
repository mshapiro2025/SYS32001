# Molly Shapiro - FA2023 - SYS320 01
# Storyline: create a script that retrieves specific host information, saves those sets of information to CSV files, and provides file hashes for those files. 

# Gets the date as a variable for unique file names. 
$datetime = Get-Date -Format MM.dd.HH.mm.ss.fff

# Gets the results location from the user
$folderlocation = read-host -Prompt "Please enter the file path where you would like your files saved (ex. C:\Users\user1)"
$filelocation = $folderlocation + "\IRResults"
mkdir $filelocation

# Create a function that takes a file name, hashes the file, and puts the file hash and name in a text file. 
function get_hash() {
    Param([string]$filetohash)
    $hashfile = "hashfile" + $datetime + ".txt"
    echo "$filename" >> "$filelocation\$hashfile"
    Get-FileHash -Path $filetohash >> "$filelocation\$hashfile"
}

# Get running processes and file paths
$processfilename = "processfile" + $datetime + ".csv"
Get-Process | Select-Object ProcessName, Path | Export-Csv -Path "$filelocation\$processfilename"
get_hash("$filelocation\$processfilename")

# Get services and their paths
$servicefilename = "servicefile" + $datetime + ".csv"
Get-WMIobject -Class Win32_service | select Name, PathName | Export-Csv -Path "$filelocation\$servicefilename"
get_hash("$filelocation\$servicefilename")

# Get all TCP network sockets
$tcpfilename = "tcpfile" + $datetime + ".csv"
Get-NetTCPConnection | Export-Csv -Path "$filelocation\$tcpfilename"
get_hash("$filelocation\$tcpfilename")

# Get all user account info
$userfilename = "userfile" + $datetime + ".csv"
Get-WMIobject -Class Win32_UserAccount | Export-Csv -Path "$filelocation\$userfilename"
get_hash("$filelocation\$processfilename")

# Get all network adapter information
$networkfilename = "networkfile" + $datetime + ".csv"
Get-WMIobject -Class Win32_NetworkAdapterConfiguration | Export-Csv -Path "$filelocation\$networkfilename"
get_hash("$filelocation\$networkfilename")

# Get recent Security event logs - this is helpful for seeing recent Security events. 
$eventlogfilename = "eventlogs" + $datetime + ".csv"
Get-EventLog -LogName Security -Newest 40 | Export-Csv -Path "$filelocation\$eventlogfilename"
get_hash("$filelocation\$eventlogfilename")

# Get drive space info for all drives- this is helpful for IR because if you see an increase in storage being used, you can investigate a potential malicious file or program taking
# up space. You can also see if there are any unknown drives. 
$drivefilename = "drivefile" + $datetime + ".csv"
Get-PSDrive | Export-Csv -Path "$filelocation\$drivefilename"
get_hash("$filelocation\$drivefilename")

# Get run keys in the registry; attackers often try to establish persistence through creating new run keys.
$runkeyfilename = "runkeys" + $datetime + ".csv"
Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run | Export-Csv -Path "$filelocation\$runkeyfilename"
get_hash("$filelocation\$runkeyfilename")

# Get file permissions for the System32 folder- checks to see if attackers have elevated privileges by changing file perms for this directory
$sys32filename = "sys32perms" + $datetime + ".csv"
Get-Acl C:\Windows\System32 | Export-Csv -Path "$filelocation\$sys32filename"
get_hash("$filelocation\$sys32filename")

# Get the current user's username
$currentuser = (Get-ChildItem Env:\USERNAME).Value

# Zip the results directory and save to the current user's desktop
Compress-Archive -Path $filelocation -DestinationPath C:\Users\$currentuser\Desktop\IRResults

$filelocation = "C:\Users\$currentuser\Desktop"

get_hash("C:\Users\$currentuser\Desktop\IRResults.zip")
