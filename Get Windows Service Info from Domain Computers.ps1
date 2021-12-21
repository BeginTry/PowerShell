<#
    .SYNOPSIS
        List Windows services

    .DESCRIPTION
        Lists Windows services and their properties for any domain machine/server that can be accessed remotely.

    .INPUTS
        None (However, note the hard-coded string filter for Get-ADComputer.)

    .NOTES
        Version:        1.0
        Author:         DMason/@BeginTry
        Creation Date:  2021/12/21
            Cmdlet Get-ADComputer may not be available on all machines. 
            It will often be available on a machine with Active Directory tools installed.
        History:
#>
begin {
    Write-Host -ForegroundColor Yellow ([Environment]::NewLine)"Begin stuff..."
}

process {

    Write-Host -ForegroundColor Yellow ([Environment]::NewLine)"Process stuff..."

    #Iterate through desired list of domain computers.
    Get-ADComputer -Filter { OperatingSystem -Like '*Windows Server*' } | Select Name | 
    ForEach-Object{

        #Option 1: output each machine's list of services to screen.
        #Get-WmiObject Win32_Service -ComputerName $_.Name | SELECT PSComputerName, Name, DisplayName, StartMode, StartName, State | Format-Table -AutoSize

        #Option 2: output each machine's list of services to a csv file.
        $path = [System.IO.Path]::Combine($PSScriptRoot, $_.Name) + ".csv"
        Get-WmiObject Win32_Service -ComputerName $_.Name | SELECT PSComputerName, Name, DisplayName, StartMode, StartName, State | Export-Csv -path $path -NoTypeInformation
	}
}


end {

    Write-Host -ForegroundColor Yellow ([Environment]::NewLine)"End stuff..."
}
