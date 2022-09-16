$PiStockFilePath = "$env:USERPROFILE\Downloads\PS-Config\pistock.csv"
$timeChecked = Get-Date -AsUTC
$newProducts = new-object collections.generic.list[object]

$foundProducts = new-object collections.generic.list[object]
if(Test-Path $PiStockFilePath)
{
	$foundProducts = Import-Csv $PiStockFilePath 
}

#"https://www.microcenter.com/search/search_results.aspx?Ntt=raspberry&Ntx=mode+MatchPartial&Ntk=all&sortby=match&N=4294818256&myStore=true"
$currentPiItems = Invoke-WebRequest "https://www.microcenter.com/search/search_results.aspx?N=4294818256&NTK=all&sortby=match&rpp=96" | select -ExpandProperty links | where { $_.href -like "/product/*" } | select -Property tagname, href -Unique


foreach ($productlink in $currentPiItems) {
	
	$existingProduct = $foundProducts | where { $_.link -eq $productlink.href }

	if($existingProduct -eq $null)
	{
	$Product = [PSCustomObject]@{
		ID = $productlink.href.Split("/")[2]
		Manufacturer = "Raspberry Pi"
		Title = $productlink.href.Split("/")[3].Replace("raspberry-pi", " ").Replace("-", " ").Trim()
		Link = $productlink.href
		Instock = 1
		LastChecked = $timeChecked
		FirstFound = $timeChecked
	}
	$foundProducts += $Product
	$newProducts += $Product
}
else {
	$existingProduct.LastChecked = $timeChecked 
}
	#$Product

}


$foundProducts | Export-Csv -Path $PiStockFilePath 

$foundProducts = Import-Csv $PiStockFilePath
"Currently Returned Items"
$currentPiItems | Format-Table

"================================================================================================================"
"New In Stock Items"
"================================================================================================================"
$newProducts | select -ExcludeProperty link | Format-Table

"
================================================================================================================"
"Out of Stock Items"
"================================================================================================================"
$foundProducts | where { (Get-Date -Date $_.LastChecked) -lt $timeChecked.AddMinutes(-1) } | select -ExcludeProperty link | Format-Table

"Time Checked: $timeChecked"