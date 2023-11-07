# Molly Shapiro - FA2023 - SYS320 01
# Storyline: View event logs, check for a valid log, and print the results

function select_log() {
    cls
    $theLogs = Get-EventLog -list | select Log
    $theLogs | Out-Host
    $arrLog = @()
    foreach ($tempLog in $theLogs) {
        $arrLog += $tempLog
    }
    $readLog = read-host -Prompt "Please enter a log from the list above or enter 'q' to quit the program."
    if ($readLog -match "^[qQ]$") {
        break
    }
    log_check -logToSearch $readLog
}

function log_check() {
    Param([string]$logToSearch)
    $theLog = "^@{Log=" + $logToSearch + "}$"
    if ($arrLog -match $theLog) {
        write-host -BackgroundColor green -ForegroundColor white "Please wait, it may take a few moments to retrieve the log entries."
        sleep 2
        view_log -logToSearch $logToSearch
    } else {
        write-host -BackgroundColor red -ForegroundColor white "The log specified doesn't exist."
        sleep 2
        select_log
    }
}

function view_log() {
    cls
    Get-EventLog -Log $logToSearch -Newest 10 -after "7/1/2023"
    read-host -Prompt "Press enter when you're done."
    select_log
}

function select_service() {
    cls
    $servicechoice = read-host -Prompt "Please choose if you would like to see [R]unning, [S]topped, or [A]ll processes or enter 'q' to quit the program: "    
    $arrservice = @("Running", "Stopped", "All")
    if ($servicechoice -match "^[qQ]") {
        break }
    else {
        if ($servicechoice -match "^[rR]") {
        Get-Service | Where {$_.Status -eq "Running"}
        read-host -Prompt "Press enter when you're done."
        select_service } 
        else {
            if ($servicechoice -match "^[sS]") {
            Get-Service | Where {$_.Status -eq "Stopped"}
            read-host -Prompt "Press enter when you're done."
            select_service }
            else {
                if ($servicechoice -match "^[aA]") {
                Get-Service
                read-host -Prompt "Press enter when you're done."
                select_service } 
                else { 
                    if ($servicechoice -match "^[qQ]") {
                    break }
                    else {
                        print "Sorry, that's not an option."
                        sleep 2
                        select_service
                    }
                 }
             }
        }
    }
}

function select_choice() {
    $choiceselection = read-host -Prompt "Please select [E]vent Logs or [S]ervices: "
    if ($choiceselection -match "^[eE]") {
        select_log
    } else {
        if ($choiceselection -match "^[sS]") {
        select_service }
    } 
        else {
            print "That's not a valid option."
            select_choice
        }
}

select_choice
