<#
  Test Function Description
 #>

 $script:TestVar="ValueX"
 
 function Show-Test
 {
	 Param(
	 [Parameter(Mandatory=$true, Position=0)]
	 [string]
	 $TextToAdd,
	 [Parameter()]
	 [Switch]
	 $ETS,
	 [Parameter()]
	 [ValidateSet("one", "two", "three", "four")]
	 $NumberOpt
	 )
 
	 Process
	 {
		 Write-Host "$script:TestVar and $TextToAdd and number $NumberOpt"
	 }
 }
 