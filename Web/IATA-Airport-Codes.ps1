
$BaseURL = "https://www.world-airport-codes.com/alphabetical/airport-code"

$URL = "$BaseURL/a.html?page=1"

$wc = New-Object System.Net.WebClient
$res = $wc.DownloadString($URL)

$html = ConvertFrom-Html -Content $res

$table = $html.SelectNodes('//table') | Where-Object { $_.HasClass('stack2') }

$tablerows = $table.SelectNodes('//tr')

$tablerows | ForEach-Object {
	$rowdata = $_.SelectNodes('//td')
	$rowdata
}










#$htmlClassName = "mTable"

#Invoke-WebRequest -Uri $URL
#$request = Invoke-WebRequest -Uri $URL

#$html = New-Object -ComObject "HTMLFile"
#$html.write($request.RawContent)

#$html.all.tags

#$HTML = $request.ParsedHtml.getElementsByTagName('a')
#$HTML

#$links = $request.Links

#$links

<#
$request = Invoke-WebRequest -Uri $URL -UseBasicParsing
$HTML = New-Object -Com "HTMLFile"
[string]$htmlBody = $request.Content
$HTML.write([ref]$htmlBody)
$filter = $HTML.getElementsByClassName($htmlClassName)
#>