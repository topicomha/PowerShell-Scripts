$RssUrl = "http://feeds.hanselman.com/scotthanselman"#"https://www.usda.gov/rss/home.xml"

$SaveRSSXML = "testRssFeed.xml"

$SaveRSSXML

Invoke-WebRequest -Uri $RssUrl -OutFile $SaveRSSXML

[xml]$Content = Get-Content $SaveRSSXML

$rss = $Content.rss
$rss 

$Feed = $rss.channel

ForEach ($msg in $Feed.Item) {

	[PSCustomObject]@{
		'LastUpdated' = [datetime]$msg.pubDate
		'Description' = $msg.description
		'Title'      = $msg.title
		'Link'        = $msg.link
	}#EndPSCustomObject

}#EndForEach