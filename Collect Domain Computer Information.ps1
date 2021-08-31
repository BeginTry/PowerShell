<#
    MIT License

    Copyright (c) 2021 Dave Mason

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
#>

<#
    .SYNOPSIS
        Collect Domain Computer Information

    .DESCRIPTION
        Collect Domain Computer Information and write the results out to display.

    .INPUTS
        None 

    .OUTPUTS
        Computer name, operating system, nubmer of processors, total bytes of memory.

    .NOTES
        Version:        1.0
        Author:         DMason 
        Creation Date:  2021/08/31
        
        History:
		YYYY/MM/DD	    Author
			Notes...
#>

# "Computer" class with properties we are interested in collecting/displaying.
class DomainComputer {
    [string]$Name
    [string]$OperatingSystem
    [Int32]$NumProcs
    [Int64]$MemBytes
}

$computerList = New-Object Collections.Generic.List[DomainComputer]

#Filter as desired. Here we are only looking for "Server" OSes.
#$ServerList = Get-ADComputer -Filter 'Name -like "*HV*"' -Property * 
$ServerList = Get-ADComputer -Filter 'OperatingSystem -like "*Server*"' -Property * 

foreach ($Server in $ServerList) 
{
    Write-Host $Server.Name  #Optional visual feedback.

    #Create a new DomainComputer class and populate its properties.
    $foundComputer = [DomainComputer]::new()
    $foundComputer.Name = $Server.Name
    $foundComputer.OperatingSystem = $Server.OperatingSystem

    try
    {
        #This fails sometimes.
        $CompSys = Get-CimInstance -ClassName Win32_ComputerSystem -ComputerName $Server.Name | Select-Object -Property *

        $foundComputer.NumProcs = $CompSys.NumberOfLogicalProcessors
        $foundComputer.MemBytes = $CompSys.TotalPhysicalMemory
    }
    catch
    {
    }
    finally
    {
        $computerList.Add($foundComputer)
    }
}

#Output to display.
foreach($pc in $computerList)
{
    Write-Host $pc.Name, $pc.OperatingSystem, $pc.NumProcs, $pc.MemBytes | Format-Table -Wrap –Auto
}
