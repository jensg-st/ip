# if (-NOT (Test-Connection -ComputerName $args[0] -TimeoutSeconds 1 -Quiet)) {
#     EXIT 255
# } 

$username = $args[0]
$password = $args[1]
$new = $args[1]

Write-Output "login in as $username, change from $old to $new"

$pass = ConvertTo-SecureString $password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential -ArgumentList ($username,$pass)

Invoke-Command -Authentication Negotiate -ComputerName $new -ScriptBlock ${ Get-Culture }  -credential $cred