# Molly Shapiro - Fall 2023 - SEC32001
# Storyline: Using the Get-Process and Get-Service cmdlets

# Get time and use for file name creation
$datetime = Get-Date -Format MM.dd.HH.mm.ss.fff
$processfilename = "myProcesses" + $datetime + ".csv"
$servicefilename = "myServices" + $datetime + ".csv"

# Get process names and export to CSV
Get-Process | Select-Object ProcessName, Path, ID | Export-Csv -Path "C:\Users\champuser\Desktop\$processfilename" -NoTypeInformation

#Get-Process | Get-Member

# Get running services and export to CSV
Get-Service | Where {$_.Status -eq "Running"} | Export-Csv -Path "C:\Users\champuser\Desktop\$servicefilename" -NoTypeInformation

# Use the Get-WMIobject cmdlet
#Get-WMIobject -Class Win32_service | select Name, PathName, ProcessId
#Get-WMIobject -list | where {$_.Name -ilike "Win32_[n-z]*"} | sort-object
#Get-WMIobject -Class Win32_Account | get-member

# Get the DHCP server and DNS server info using the WMI class
Get-WMIobject -Class Win32_NetworkAdapterConfiguration -Filter "DHCPEnabled=$true" | Select DHCPServer, DNSServerSearchOrder

# Start and stop the calculator

Start-Process calc.exe

Start-Sleep -Seconds 5

Stop-Process -Name win32calc
