
function Parse-YoutubeFeed {
	param (
		$FeedURL,
		$ChannelID,
		$FilePath
	)

	$isValid = $true
	if (!$PSBoundParameters.ContainsKey('FeedURL') -and !$PSBoundParameters.ContainsKey('ChannelID') -and !$PSBoundParameters.ContainsKey('FilePath')) {
		Write-Error "A Url, ChannelID, or a FilePath is required"
		$isValid = $false
	}
	else {
		if ($PSBoundParameters.ContainsKey('FilePath')) {
			if (Test-Path -Path $FilePath -PathType Leaf) {
				$SaveRSSXML = $FilePath
			}
			else {
				Write-Error "$FilePath cannot be found"<# Action when all if and elseif conditions are false #>
				$isValid = $false
			}
		}
		else {
			if (!$PSBoundParameters.ContainsKey('FeedURL') -and $PSBoundParameters.ContainsKey('ChannelID')) {
				$Url = "https://www.youtube.com/feeds/videos.xml?channel_id=$ChannelID"
			}
			else {
				$Url = $FeedURL
				$split = $Url.Split("=")
				$ChannelID = $split | Select-Object -l 1
			}
			$SaveRSSXML = "youtube$ChannelID.xml"
		}
		#$SaveRSSXML 
		#$Url
		#$ChannelID
	}
	
	if ($isValid) {
		
		if ($Url) {
			Invoke-WebRequest -Uri $Url -OutFile $SaveRSSXML
		}
		[xml]$Content = Get-Content $SaveRSSXML
		
		$Feed = $Content.feed
		$Channel = $Feed.channelId + "(" + $Feed.title + ")"
		
		#$Feed
		#$Channel
		
		[System.Collections.ArrayList]$Videos = @{}
		ForEach ($msg in $Feed.entry) {
			#$msg.group
			$video = [PSCustomObject]@{
				'Title'       = $msg.title
				'Published'   = [datetime]$msg.published
				'LastUpdated' = [datetime]$msg.updated
				'Description' = $msg.group.description
				'StarRating'  = $msg.group.community.starRating.average + "/" + $msg.group.community.starRating.count
				'Views'       = $msg.group.community.statistics.views
				'Link'        = $msg.link.href
				'Content'     = $msg.group.content.url
				'Thumbnail'   = $msg.group.thumbnail.url
			}#EndPSCustomObject
			#$video
			$currentIndex = $Videos.Add($video)
		}#EndForEach
	}
	Write-Output $Videos
	
}

#Export-ModuleMember -Function Parse-YoutubeFeed

function Find-YoutubeChannelID {
	param(
		$ChannelName
	)
	
	$html = Invoke-WebRequest "https://www.youtube.com/c/$ChannelName" | Select-Object -ExpandProperty content
	
	$htmlDom = ConvertFrom-Html $html
	
	$channelLinks = $htmlDom.SelectNodes("//link[@href]") | Select-Object -ExpandProperty Attributes | Where-Object -Property Value -Like "*/www.youtube.com/channel/*" | Select-Object -p Value
	
	$channelLinks | Select-Object -First 1 -ExpandProperty Value
	
	$firstLink = $channelLinks | Select-Object -First 1 -ExpandProperty Value
	
	$channelID = $firstLink.Split("/") | Select-Object -Last 1
		
	$channelID
}
	
#Export-ModuleMember -Function Find-YoutubeChannelID
	