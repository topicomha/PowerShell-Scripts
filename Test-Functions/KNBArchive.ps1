[Datetime]$startdate = '11-01-2006'
[DateTime]$enddate = '12-31-2006'

[DateTime]$currentdate = $startdate
$wc = New-Object System.Net.WebClient

while ($currentdate -le $enddate) {
	[string]$monthname = (Get-Culture).DateTimeFormat.GetMonthName($currentdate.Month)
	[string]$month = $currentdate.Month
	[string]$date = ([string]$currentdate.Date.Day).PadLeft(2, "0")
	[string]$year = $currentdate.Year



	$url = "http://www.kevinandbeanarchive.com/" + $monthname + "_" + $date + "_" + $year + "_no_songs_no_commercials.MP3"
	$output = "$PSScriptRoot\KevinAndBean-$year-$month-$date.MP3"
	$start_time = Get-Date


	Write-Output "Downloading $url"

	$wc.DownloadFile($url, $output)
	#OR
	#(New-Object System.Net.WebClient).DownloadFile($url, $output)

	Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"

	
	$currentdate = $currentdate.AddDays(1)
}

<#[Datetime]$startdate = '11-01-2006'
[DateTime]$enddate = '12-31-2006'

[DateTime]$currentdate = $startdate

while ($currentdate -le $enddate) {
	[string]$monthname = (Get-Culture).DateTimeFormat.GetMonthName($currentdate.Month)
	[string]$month = $currentdate.Month
	[string]$date = ([string]$currentdate.Date.Day).PadLeft(2, "0")
	[string]$year = $currentdate.Year

	#$monthname+"_"+$year+"_"+$month+"_"+$date
	
	
	"http://www.kevinandbeanarchive.com/"+$monthname+"_"+$date+"_"+$year+"_no_songs_no_commercials.MP3"
	$link = "http://www.kevinandbeanarchive.com/"+$monthname+"_"+$date+"_"+$year+"_no_songs_no_commercials.MP3"
	#invoke-WebRequest "$link" | Select-Object -ExpandProperty Content | Out-File "KevinAndBean-$year-$month-$date.MP3"

	$currentdate = $currentdate.AddDays(1)
}


$baseURL = "http://www.kevinandbeanarchive.com"

$folderslinks = Invoke-WebRequest "$baseURL/audio.php" | Select-Object -ExpandProperty links | Where-Object -Property outerHTML -Like "*?dir=audio/*"

$folders = @()

$folderslinks | ForEach-Object -Process { $matched = $_ -match "<a href='(.*)?'"; if($matched) {$folders += $Matches[1]} }
$mp3Links = @()

#>

<#
$folders | ForEach-Object -Process {  
	$mp3Link = Invoke-WebRequest "$baseURL/$_" | Select-Object -ExpandProperty links | Where-Object -Property outerHTML -Like "*>Play All Here<*" | Select-Object -ExpandProperty outerHTML;
	Write-Host $mp3Link 
}
#>

<#
foreach ($group in $folders) {
	"$baseURL/$group"
	$link = Invoke-WebRequest "$baseURL/$group" | 
	Select-Object -ExpandProperty links | 
	Where-Object -Property outerHTML -Like "*>Play All Here<*" | 
	Select-Object -ExpandProperty outerHTML;
	$link
	
	$playalllink = Invoke-WebRequest "$baseURL/$link";
	#$playalllink
}

$mp3s = @()


$(New-Object net.webclient).DownloadFile($(gcb),$env:temp+'\'+$((gcb).split('*/')[-1]+'.mp3'))
#>

<#
$folderslinks
$folders
$mp3s
#>
