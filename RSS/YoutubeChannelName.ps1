$ChannelName = "MrBallen"

$html = Invoke-WebRequest "https://www.youtube.com/c/$ChannelName" | Select-Object -ExpandProperty content

$htmlDom = ConvertFrom-Html $html

$channelLinks = $htmlDom.SelectNodes("//link[@href]") | Select-Object -ExpandProperty Attributes | Where-Object -Property Value -Like "*/www.youtube.com/channel/*" | Select-Object -p Value

$channelLinks | Select-Object -First 1 -ExpandProperty Value

$firstLink = $channelLinks | Select-Object -First 1 -ExpandProperty Value

$channelID = $firstLink.Split("/") | Select-Object -Last 1
