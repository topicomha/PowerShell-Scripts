
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
        
		$FeedURL = ""
		$ChannelID = ""
		$isValid = $true
	
		#if  ( $FeedURL -eq "" -and $ChannelID -eq "" 0 ) {
		# $HasFeedURL = $PSBoundParameters.ContainsKey('FeedURL')
		# $HasChannelID = $PSBoundParameters.ContainsKey('ChannelID')
		# $HasFilePath = $PSBoundParameters.ContainsKey('FilePath')
		
		# $HasAll = $HasFilePath -and $HasChannelID -and $HasFilePath
		# $HasNone = !$HasFilePath -and !$HasChannelID -and !$HasFilePath
		# $HasAny = !$HasFilePath -or !$HasChannelID -or !$HasFilePath

		# $HasFeedURL
		# $HasChannelID
		# $HasFilePath
		# $HasAll
		# $HasNone
		# $HasAny


		# $FeedURL
		# $ChannelID
		# $FilePath


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
				$SaveRSSXML = "youtube$ChannelID.xml"
				if ($PSBoundParameters.ContainsKey('FeedURL') -and !$PSBoundParameters.ContainsKey('ChannelID')) {
					$Url = "https://youtube.com/feed/chanelid=$ChannelID"
				}
				$Url = $FeedURL
		
			}
			$SaveRSSXML 
			#$Url
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
			$Channel
		
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
				$video
				$Videos.Add($video)

			}#EndForEach
		}

	}

	END { 

	}
}



#region Execution examples
Parse-YoutubeFeed -FilePath youtube9.xml
Parse-YoutubeFeed -ChannelID test  
Parse-YoutubeFeed -FeedURL test  
#endregion
