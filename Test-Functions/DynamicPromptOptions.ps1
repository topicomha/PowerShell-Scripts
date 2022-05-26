function Prompt-Choices {     
	Param(
		#[System.String]$Title = [string]::Empty, 
		#[System.String]$Message, 
		
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[System.String[]]$Choices#, 
		
		#[System.Int32]$DefaultChoice = 1
		
	)          
	$i = 1        
	$Choices | ForEach-Object {  
		Write-Host $i $_   
		$i = $i + 1    
	}
	
	$Selection = Read-Host -Prompt "Type the number of the option you would like"
	
	$SelectionNumber = $Selection -as [int]
	#$SelectionNumber = [convert]::ToInt32($Selection)
	<#
	#>
	Write-Host "Selection $Selection"
	$SelectionType = $Selection.GetType()
	Write-Host "Selection Type $SelectionType"
		
	Write-Host "SelectionNumber $SelectionNumber"
	
	$isnull = $null -eq $SelectionNumber
	Write-Host "IsNull $isnull"
	
	$lessthan = $SelectionNumber -le 0
	Write-Host "Less Than 0 $lessthan"
	
	$greaterthan = $SelectionNumber -gt $choices.Count
	Write-Host "Greater Than Count $greaterthan"
	
	while ($null -eq $SelectionNumber -or $SelectionNumber -le 0 -or $SelectionNumber -gt $choices.Count) {
		$Selection = Read-Host -Prompt "SelectionNumber $Selection is invalid. Type the number of the option you would like"
		$SelectionNumber = $Selection -as [int]
	}
	return $Choices[$SelectionNumber-1]
}

$TestChoices = Get-Process | Select-Object -ExpandProperty ProcessName -Unique

$Answer = Prompt-Choices -Title "Select a Service" -Message "Choose from the services with a connection" -Choices $TestChoices -DefaultChoice 0

Write-Output "Answer"
Write-Output $Answer

<#
Not Working 
function Prompt-Choices {     
	Param(
		[System.String]$Message, 
		
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[System.String[]]$Choices, 
		
		[System.Int32]$DefaultChoice = 1, 
		
		[System.String]$Title = [string]::Empty 
	)        
	#[System.Management.Automation.Host.ChoiceDescription[]]$Poss = $Choices | ForEach-Object {            
	#	New-Object System.Management.Automation.Host.ChoiceDescription "&$Choices.IndexOf($_) $_)", "Sets $_ as an answer."       
	#}

	$Poss = New-Object System.Collections.ObjectModel.Collection[System.Management.Automation.Host.ChoiceDescription]
	for($i=0; $i -lt $Choices.length; $i++){
		$Poss.Add((New-Object System.Management.Automation.Host.ChoiceDescription "&$i. $Choices[$i]" ) ) }

	$Host.UI.PromptForChoice( $Title, $Message, $Poss, $DefaultChoice )     
}
#>