<# 
   .SYNOPSIS
   This script encrypts a given password and saves the file to a password.txt file that can be used by any user on any machine. 
   .DESCRIPTION
   This script creates an AES.key file with random number generation that is used to encrypt the password into the password.txt.
   The purpose of this method is to be able to use the encrypted password file with the AES.key under any user context, like LOCAL SYSTEM

   .INPUTS
   None. You cannot pipe any objects to this script.

   .Example

   .\Encrypt_Password.ps1 


   .Notes 
   Version:        1.0
   Author:         Adam Bergh (adam.berghn@veeam.com)
 #>



PROCESS {

$WorkingDir = read-host -Prompt 'Enter the dir to save your files, example c:\scripts\ '


$KeyFile = $WorkingDir + "AES.key"

$Key = New-Object Byte[] 16   # You can use 16, 24, or 32 for AES
[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($Key)
$Key | out-file $KeyFile

$PasswordFile = $WorkingDir + "password.txt"

$Key = Get-Content $KeyFile

$passinput = read-host -assecurestring -Prompt 'Enter the password you would like to encrypt'
#$passinput = read-host -Prompt 'Enter the password you would like to encrypt'


$securedValue = Read-Host -AsSecureString -Prompt 'Enter the password you would like to encrypt'
$bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securedValue)
$pass = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)

$Password = $pass| ConvertTo-SecureString -AsPlainText -Force
$Password | ConvertFrom-SecureString -key $Key | Out-File $PasswordFile


Write-host "AES.key and password.txt have been written to " $WorkingDir
}
