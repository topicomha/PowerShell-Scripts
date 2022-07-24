#$RssUrl = ""

$SaveRSSXML = "youtube.xml"

#$SaveRSSXML

#Invoke-WebRequest -Uri $RssUrl -OutFile $SaveRSSXML

[xml]$Content = Get-Content $SaveRSSXML

$Feed = $Content.feed
$Channel = $Feed.channelId + "(" + $Feed.title + ")"

#$Feed
$Channel

[System.Collections.ArrayList]$Videos  = @{}
ForEach ($msg in $Feed.entry) {

	#$msg.group
	$video = [PSCustomObject]@{
		'Title'      	= $msg.title
		'Published' 	= [datetime]$msg.published
		'LastUpdated' 	= [datetime]$msg.updated
		'Description' 	= $msg.group.description
		'StarRating'    = $msg.group.community.starRating.average + "/" + $msg.group.community.starRating.count
		'Views'    		= $msg.group.community.statistics.views
		'Link'        	= $msg.link.href
		'Content' 		= $msg.group.content.url
		'Thumbnail' 	= $msg.group.thumbnail.url
	}#EndPSCustomObject
	$video
	$Videos.Add($video)

}#EndForEach

$Videos | Export-Csv -Path "$Channel.csv"
