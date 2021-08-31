<#
    .SYNOPSIS
        Generate passwords.

    .DESCRIPTION
        This script generates a list of passwords and copies them to the clipboard.

    .INPUTS
        Number of passwords to generate (from command line).
        Desired length of passwords (from command line).

    .OUTPUTS
        List of passwords generated.

    .NOTES
        Version:        1.0
        Author:         DMason
        Creation Date:  2017-12-18
        
        History:
		YYYY/MM/DD	    Author
			Notes...
#>

[Reflection.Assembly]::LoadWithPartialName("System.Web")

<#
    Generate a new password by calling System.Web.Security.Membership.GeneratePassword()
    See: https://msdn.microsoft.com/en-us/library/system.web.security.membership.generatepassword(v=vs.110).aspx
    Enforce password policy rules:
        At least one UPPER CASE character.
        At least one lower case character.
        At least one digit.
        At least one special character (this rule should be met by providing a value >= 1 for $numberOfNonAlphanumericCharacters)
    If necessary, call the function recursively until all rules are met.
#>
function Get-NewPassword([System.Int32]$length,`
    [System.Int32]$numberOfNonAlphanumericCharacters)
{
    $pwd = [System.Web.Security.Membership]::GeneratePassword(
        $length,$numberOfNonAlphanumericCharacters)

    #Validation: one UPPER case, one lower case, one digit.
    [bool]$valid = ($pwd -cmatch '[A-Z]') `
        -and ($pwd -cmatch '[a-z]') `
        -and ($pwd -cmatch '[0-9]')

    if (-Not $valid)
    {
        #Call function recursively, try again.
        $pwd = Get-NewPassword -length $length `
            -numberOfNonAlphanumericCharacters $numberOfNonAlphanumericCharacters
    }
    
    return $pwd
} 

# Prompt user.
Write-host "How many passwords do you want to generate?" -ForegroundColor Yellow 
[System.Int32]$passwordCount = Read-Host " (Enter a whole number) " 

# Prompt user.
Write-host "What is the password length?" -ForegroundColor Yellow 
[System.Int32]$passwordLength = Read-Host " (Enter a whole number) " 

$sb = [System.Text.StringBuilder]::new()

try
{
    For ($iLoop = 0; $iLoop -lt $passwordCount; $iLoop++)
    {
        $pwd = Get-NewPassword -length $passwordLength `
            -numberOfNonAlphanumericCharacters 2
        Write-Host $pwd -foregroundcolor "green"
        [void]$sb.AppendLine($pwd)
    }
}
catch
{
    Write-Error  $_
}

Set-Clipboard -Value $sb.ToString().TrimEnd()
Write-host "Passwords have been copied to the clipboard." -ForegroundColor Yellow 
