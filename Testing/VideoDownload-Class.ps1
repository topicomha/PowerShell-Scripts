class VideoDownload {
	[DateTimeOffset]$DownloadedDate
	
	[string]$ID
	[string]$id
	
	[string]$display_id
	[string]$fulltitle
	[string]$Name
	
	[string]$Source
	[string]$SourceURL
	[string]$playlist
	[string]$playlist_index
	
	[string]$thumbnail
	[string]$categories
    [string]$Series
	[string]$thumbnails
	[string]$title
	[string]$creator
	[string]$uploader_id
	[string]$upload_date
	[Nullable[DateTimeOffset]]$PublishedDate
	[string]$webpage_url
	[string]$webpage_url_basename
	[string]$DownloadURL
	[string]$url
	[bool]$Sponsored #*
	
	[string]$extractor_key
	[string]$extractor
	[string]$manifest_url
	
	[string]$_filename
	[string]$ext
	
	[string]$duration
	[string]$width
	[string]$height
	
	#Media Settings
	[string]$protocol
	[string]$formats
	[string]$vcodec
	[string]$acodec
	[string]$fps
	[string]$preference
	[string]$format
	[string]$format_id
	
	[string]$requested_subtitles
	[string]$tbr
	
	[string]$Result
	
	[string] hidden $seriesRegexPattern = "\/series\/(?<Name>.*?)\/"

	VideoDownload([string]$link)
	{
	}
}