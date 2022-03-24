#Plain text string.
$string = "my sup3r c0mp1ex p@ssword"

#Convert to secure string.
$secureString = ConvertTo-SecureString -String $string -AsPlainText -Force
Write-Host $secureString -ForegroundColor Yellow

#Encrypt secure string.
$Encrypted = ConvertFrom-SecureString -SecureString $secureString
Write-Host $Encrypted -ForegroundColor Yellow

#Encrypted string literal value (copy/paste the output from Write-Host)
$EncryptedLiteral = "01000000d08c9ddf0115d1118c7a00c04fc297eb0100000020cb3948e04710468f" + `
    "bee0a2884057000000000002000000000003660000c00000001000000025c25203e79479d2a6ee3a47" + `
    "0c3325550000000004800000a0000000100000001c2759111e5f1554d7b864109974340838000000e1" + `
    "61e50327733b520bb9a113780a7ad721251865f86dadf7291e23b4def1a5fd37afc9b96db01c17cd5f0" + `
    "542613e814a9664c8272e3add9a140000009aab3372fa8e6ce4edb091f6b0cbbb52607c50f9"

#Convert encrypted string to secure string.
$secureString = $null
$secureString = ConvertTo-SecureString -String $EncryptedLiteral
Write-Host $secureString -ForegroundColor Yellow

#Convert secure string back to plain text.
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureString)
$UnsecurePassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
Write-Host $UnsecurePassword -ForegroundColor Yellow
