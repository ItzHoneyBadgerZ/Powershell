#decrypt Password and store as variable (not plain text)
#can easily be modified to have static variables for $user, $certname, and $encryptedPassLocation for automation purposes.
$user = Read-Host "Enter UPN here i.e. user@domain.com: "
$certName = read-host "Please enter the certificate subject name: "
$cert = Get-ChildItem Cert:\LocalMachine\my | Where-Object {$_.Subject -like "*$certName*"}
$encryptedPassLocation = Read-Host "Enter location of encrypted password file i.e. 'C:\users\bob\encrypted.txt'"
$encryptedPass = gc $encryptedPassLocation
$encryptedBytes = [System.convert]::FromBase64String($encryptedPass)
$decryptedBytes = $cert.PrivateKey.Decrypt($encryptedBytes, $true)
$decryptedPass = [system.text.encoding]::UTF8.getstring($decryptedbytes) | ConvertTo-SecureString -AsPlainText -Force

#create credential object and clear out other variables for security
$creds = New-Object System.Management.Automation.PSCredential -ArgumentList $User, $decryptedPass
Clear-Variable decryptedPass,decryptedBytes,encryptedBytes,user
