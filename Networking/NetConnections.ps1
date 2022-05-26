$InterestedService = "SITAMessageService"

function Prompt-Choices {     
	Param(
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[System.String[]]$Choices
	)          
	$i = 1        
	$Choices | ForEach-Object {  
		Write-Host $i $_   
		$i = $i + 1    
	}
	
	$Selection = Read-Host -Prompt "Type the number of the option you would like"
	
	$SelectionNumber = $Selection -as [int]
	
	while ($null -eq $SelectionNumber -or $SelectionNumber -le 0 -or $SelectionNumber -gt $choices.Count) {
		$Selection = Read-Host -Prompt "SelectionNumber $Selection is invalid. Type the number of the option you would like"
		$SelectionNumber = $Selection -as [int]
	}
	return $Choices[$SelectionNumber-1]
}

$NetConnections = Get-NetTCPConnection 

$NetConnectionsWithService = $NetConnections | `
Select-Object -Property *, @{'Name' = 'ProcessName';'Expression'={(Get-Process -Id $_.OwningProcess).Name}} 



$AllServices = $NetConnectionsWithService | `
Select-Object -ExpandProperty ProcessName -Unique

$InterestedService = Prompt-Choices $AllServices 

#Write-Output Prompt-Choice -Title "Select a Service" -Message "Choose from the services with a connection" -Choices $AllServices -DefaultChoice 0

$FoundConnections = $NetConnectionsWithService | `
Where-Object {$_.ProcessName -eq $InterestedService} 

Write-Output "Looking for $InterestedService"
$FoundConnections | `
Format-Table `
	-AutoSize `
	-Property State, OffloadState, LocalAddress, LocalPort, RemoteAddress, RemotePort, OwningProcess, ProcessName

	
<#
Get-NetTCPConnection | `
Select-Object -Property *, @{'Name' = 'ProcessName';'Expression'={(Get-Process -Id $_.OwningProcess).Name}} | `
Format-Table `
	-AutoSize `
	-Property State, OffloadState, LocalAddress, LocalPort, RemoteAddress, RemotePort, OwningProcess, ProcessName
#>

