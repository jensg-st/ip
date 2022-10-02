function Set-IP
{

    $ip = (Get-NetIPAddress -AddressFamily IPv4 | 
    Where-Object { $_.PrefixOrigin -eq "Dhcp" } |
    Where-Object InterfaceAlias -NotLike "*Loopback*" |
    Select-Object IPV4Address).IPV4Address

    $prefix = (Get-NetIPAddress -AddressFamily IPv4 | 
    Where-Object { $_.PrefixOrigin -eq "Dhcp" } |
    Where-Object InterfaceAlias -NotLike "*Loopback*" |
    Select-Object PrefixLength).PrefixLength

    $alias = (Get-NetIPAddress -AddressFamily IPv4 | 
    Where-Object { $_.PrefixOrigin -eq "Dhcp" } |
    Where-Object InterfaceAlias -NotLike "*Loopback*" |
    Select-Object InterfaceAlias).InterfaceAlias

    Write-Output "changing $alias $ip/$prefix"
    [Console]::Out.Flush() 


    Set-NetIPInterface -InterfaceAlias $alias -Dhcp Disabled
    Remove-NetIPAddress -InterfaceAlias $alias -Confirm:$false
    New-NetIPAddress -InterfaceAlias $alias -IPAddress $args[0] -AddressFamily IPv4 -DefaultGateway $args[1] -PrefixLength $args[2]
    Set-DnsClientServerAddress -InterfaceAlias $alias -serveraddresses 8.8.8.8
    
}

$username = $args[0]
$password = $args[1]
$old = $args[2]
$new = $args[3]
$gw = $args[4]
$prefix = $args[5]



Write-Output "login in as $username, change from $old to $new"

$pass = ConvertTo-SecureString $password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential -ArgumentList ($username,$pass)

Invoke-Command -Authentication Negotiate -ComputerName $old -ScriptBlock ${function:Set-IP} -ArgumentList $new,$gw,$prefix -credential $cred



