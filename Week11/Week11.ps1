# Molly Shapiro - FA2023 - SYS320 01
# Storyline: View event logs, check for a valid log, and print the results

function selectlog() {
    cls
    $logs = Get-EventLog -list | select Log
    $logs | Out-Host

    $logarray = @()

    foreach ($templog in $logs) {
        $logarray += $templog
    }
    $readLog = read-host -Prompt "Please enter a log from the list above or enter 'q' to quit the program. "

    if ($readLog -match "^[qQ]$") {
        break
    }
    logcheck -logToSearch $readLog

    
}

function logcheck() {
    Param([string]$logToSearch)
    $thelog = "^@{Log = " + $logToSearch + "}$"

    if ($logarray -match $thelog){
        write-host -BackgroundColor Green -ForegroundColor white "Please wait, it may take a few moments to retrieve the log entries. "
        sleep 2
        viewlog -logToSearch $logToSearch
    } else {
        write-host -BackgroundColor red -ForegroundColor white "The log specified doesn't exist."
        sleep 2
        selectlog
    }
}

function viewlog() {
    cls
    Param([string]$logToSearch)
    Get-EventLog -Log $logToSearch -Newest 10 -after "7/1/2023"
    read-host -Prompt "Press enter when you are done."
    selectlog

}

selectlog
