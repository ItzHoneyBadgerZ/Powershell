#encrypt password and store as non-plain-text file that can only be decrypted with certificate it was encrypted with
#run this once to get encrypted 
$certName = read-host "Please enter the certificate subject name: "
$Cert = Get-ChildItem Cert:\LocalMachine\My | Where-Object {$_.Subject -like "*$certName*"}
$Password = Read-Host -AsSecureString "Enter your password here (don't worry, it's read in as secure): "
$EncodedPwd = [system.text.encoding]::UTF8.GetBytes($Password)
$EncryptedBytes = $Cert.PublicKey.Key.Encrypt($EncodedPwd, $true)
$location = Read-Host "Enter location where you want encrypted file saved to. Press Enter if you want it saved on your desktop: "
if(!$location){
  $filePath = "$home\Desktop\encrypted.txt"
}else{
  $filePath = $location
}
$EncryptedPwd = [System.Convert]::ToBase64String($EncryptedBytes) | Out-File $filePath
