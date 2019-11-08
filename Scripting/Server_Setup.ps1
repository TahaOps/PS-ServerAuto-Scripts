<#
Author : Taha Ghazali
Creation Date : 2019-10-11
Version : 1.3.1
Edition Date : 2019-11-05
#>

# TASK - Customizing Prompt
function prompt{'SCRIPT 1: ' + (get-location) + '> '}

# PROMPT - List AD Computers / NOT OPTIMIZED YET
$BoolListAdCom = Read-Host -Prompt "0. Do you want to list the computers/servers of the Domain ? (y/n)"
if ($BoolListAdCom -match "[yY]")
{
Write-Host "Do you want me to print the whole list of all computers, the servers only or the computers only ?"
$ComType = Read-Host -Prompt "Please type [a]ll, [s]ervers or [c]omputers"
if ($ComType -match "[aA]")
{
Get-ADComputer -Filter * -Property * | Format-Table Name,OperatingSystem,OperatingSystemServicePack,OperatingSystemVersion -Wrap –Auto
}
elseif ($ComType -match "[sS]")
{
Get-ADComputer -Filter {OperatingSystem -Like “*server*”} -Property * | Format-Table Name,OperatingSystem,OperatingSystemServicePack -Wrap -Auto
}
elseif ($ComType -match "[cC]")
{
Get-ADComputer -Filter {OperatingSystem -NotLike “*server*”} -Property * | Format-Table Name,OperatingSystem,OperatingSystemServicePack -Wrap -Auto
}
else{
Write-Host "Did not understood, sorry" #while loop
}
}
elseif ($BoolListAdCom -match "[nN]")
{
Write-Host "No computer will be listed"
Write-Host "Clearing screen in 2 seconds"
Start-Sleep -Seconds 2
Clear-Host
}
else{
Write-Host "Did not understood, sorry" #while loop
}
# PROMPT - Computer name
Write-Host "1. Rename the computer"
$ComputerName = Read-Host -Prompt "Enter the computer name"
"" ; "" ; "" 
# PROMPT - IPs
Write-Host "2. Give IP addresses"
$IPAddr = Read-Host -Prompt "Enter the computer IP (IPv4 supported only)"
$SubnetMask = Read-Host -Prompt "Enter 8,16,24 or 32 for the subnet mask (CIDR)"
$GTAddr = Read-Host -Prompt "Enter the gateway IP (blank if none)"
$DNSAddr = Read-Host -Prompt "Enter the main DNS address"
"" ; "" ; "" 
# PROMPT - Firewall disbaling
Write-Host "3. Set firewall preferences"
Write-Host "All domains will be disabled (Domain, Public and Private). Be sure to be secured through a domain firewall or any other solution"
"" ; "" ; "" 

# TRANSITION
Write-Host "Time to do the changes"
Write-Host "Clearing screen in 3 seconds"
Start-Sleep -Seconds 3

# TASK - Computer Name
Rename-Computer -NewName $ComputerName 

# TASK - IPs
New-NetIPAddress –InterfaceAlias “Ethernet0” –IPAddress $IPAddr –PrefixLength $SubnetMask -DefaultGateway $GTAddr 
Set-DnsClientServerAddress -InterfaceAlias "Ethernet0" -ServerAddresses $DNSAddr 

# TASK - Firewall disabling
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False 

# TASK - Toggle Num Lock
Set-ItemProperty -Path 'Registry::HKU\.DEFAULT\Control Panel\Keyboard' -Name "InitialKeyboardIndicators" -Value "2" 

# TASK - Power Config : Screen never turns off
PowerCfg /Change monitor-timeout-ac 0 
PowerCfg /Change monitor-timeout-dc 0 

# END MESSAGE
Write-Host "Script ended."

# CRON TASK
Write-Host "Now we are scheduling a new script at boot in order to include this computer ($ComputerName) to the the domain"
$Step2 = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-File %HOMEDRIVE%\Scripting\Domain_Merger.ps1"
$trigger = New-ScheduledTaskTrigger -AtLogon
Register-ScheduledTask -TaskName "Domain Merger" -Action $Step2 -Trigger $trigger
Restart-Computer