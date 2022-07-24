
#region help
<#
.SYNOPSIS
Parse a youtube RSS XML feed to a list of videos
.DESCRIPTION
Parse a youtube RSS XML feed to a list of videos

.PARAMETER FeedURL
The Url to the RSS feed

.PARAMETER ChannelID
Youtube channel ID that can be used to get the feed

.PARAMETER FilePath
XML file used to parse


.EXAMPLE
Parse-YoutubeFeed -FeedURL 
Parse-YoutubeFeed -ChannelID
Parse-YoutubeFeed -FilePath 

.EXAMPLE
Help Parse-YoutubeFeed -Full

.INPUTS
System.String

InputObject parameters are strings. 
.OUTPUTS
List of Youtube Videos
	Properties:
	'Title'
	'Published'   
	'LastUpdated' 
	'Description' 
	'StarRating'  
	'Views'       
	'Link'        
	'Content'     
	'Thumbnail' 

.NOTES
FunctionName : Parse-YoutubeFeed
Created by   : David Boyd
Date Coded   : 7/5/2022 
Email   	 : topicomha@hotmail.com

.LINK 
Videos
#>
#endregion


Function Parse-YoutubeFeed {
	[CmdletBinding()]

	param (

		[Parameter(Mandatory = $false,
			HelpMessage = "The link to the RSS feed")] 
		[string]$FeedURL,

		[Parameter(Mandatory = $false,
			HelpMessage = "Youtube channel ID that can be used to get the feed")] 
		[string]$ChannelID,
	
		[Parameter(Mandatory = $false,
			HelpMessage = "XML file used to parse")] 
		[string]$FilePath
	)

	BEGIN { 
        
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
	}

	PROCESS {

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

	END { 

	}
}



#region Execution examples
#$Videos1 = Parse-YoutubeFeed -FilePath youtube.xml
#$Videos2 = Parse-YoutubeFeed -FilePath youtubeUC3s0BtrBJpwNDaflRSoiieQ.xml 
#$Videos3 = Parse-YoutubeFeed -FilePath youtubeUCe1IA5kmY578O_Qo7Skr-TQ.xml 
#$Videos4 = Parse-YoutubeFeed -FilePath youtubeUCg4vDcovXPJTcTcYxQ9iCrw.xml
#$Videos5 = Parse-YoutubeFeed -FilePath youtubeUCR0VLWitB2xM4q7tjkoJUPw.xml
#$Videos6 = Parse-YoutubeFeed -FilePath youtubeUCtPrkXdtCM5DACLufB9jbsA.xml
#Parse-YoutubeFeed -FeedURL https://www.youtube.com/feeds/videos.xml?channel_id=UC3s0BtrBJpwNDaflRSoiieQ
#Parse-YoutubeFeed -ChannelID UC3s0BtrBJpwNDaflRSoiieQ
#| Select-Object -p Title, Published, LastUpdated, StarRating, Views, Link, Content, Thumbnail, Description
#endregion

#$Videos3 | Export-Csv -path .\test.csv

#$Videos1 | Export-Csv -path videos1.csv
#$Videos2 | Export-Csv -path videos2.csv