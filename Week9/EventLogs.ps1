# Molly Shapiro - Fall 2023 - SYS32001
# Storyline: review security Event Logs

# List all available logs
Get-EventLog -list

# Create a prompt to allow the user to select the specific log to view
$useranswer = Read-Host -Prompt "Please select a log to review from the list above: "

# Directory to save files
$dirname = "C:\Users\user1\Desktop"

# Create log file variable
$filename = $useranswer + "Logs.csv"

# Task: create a prompt that allows the user to filter for a specific keyword or phrase within the logs

$keyword = Read-Host -Prompt "Please enter a keyword or phrase you would like to filter the logs for: "

# Print the results
Get-EventLog -LogName $useranswer -Newest 40 | where {$_.Message -ilike "*$keyword*"} |Export-Csv -NoTypeInformation -Path "$dirname\$filename"
