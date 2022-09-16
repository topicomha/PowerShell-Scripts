class VideoDownload {
    [string]$ID
    [string]$Name
    [string]$Source
    [string]$SourceURL
    [string]$DownloadURL
    [string]$Series
	[bool]$Sponsored
    [DateTimeOffset]$DownloadedDate
    [Nullable[DateTimeOffset]]$PublishedDate
	[string]$Result

	[string] hidden $seriesRegexPattern = "\/series\/(?<Name>.*?)\/"

	VideoDownload([string]$link)
	{
		$linkparts = $link -Split "/";
		$linkPartsCount = $linkparts.Count;
		$linkfile = $linkparts | Select-Object -Last 1 
		$seriersMatch = [RegEx]::Matches($link,$this.seriesRegexPattern)[0];
		
		$this.ID = $linkfile -Split "\." | Select-Object -First 1 ;
		$this.Name = $linkparts[$linkPartsCount-2].replace("-", " ");
		$this.DownloadURL = $link;
		$this.DownloadedDate = Get-Date -AsUTC;
		$this.Sponsored = $link -like "*sponsored*"
		if($seriersMatch){
			$this.Series = $seriersMatch[0].groups["Name"].Value.replace("-", " ") 
		}

	} 
}

cd I:\videos\news

$DownloadedVideoListPath = "DownloadedVideos.csv"
$sourceURL = "https://abcnews.go.com/Video"


$foundLinks = Invoke-WebRequest $sourceURL | `
Select-Object -ExpandProperty Links | `
Where-Object -Property href -like "/live/video*" | `
Select-Object -ExpandProperty href 


$DownloadedVideos = [System.Collections.ArrayList]::new()

if(Test-Path $DownloadedVideoListPath)
{
	$VideoInLists = Import-Csv $DownloadedVideoListPath
}


$vidLinksDone = $VideoInLists | Select-Object -ExpandProperty DownloadURL
$pattern = (($vidLinksDone | ForEach-Object {[regex]::Escape($_)}) –join "|")

if($vidLinksDone.Count -gt 0)
{
	$newlinks = $foundLinks | Where-Object { $_ -NotMatch $pattern }
}
else {
	$newlinks = $foundLinks
}

foreach ($link in $newlinks) {	
	[VideoDownload]$video = [VideoDownload]::new($link); 
	$video.SourceURL = $sourceURL; 
	$video.Result = youtube-dl $link;
	$video;
	$DownloadedVideos.Add($video);
}
<#
$foundLinks | ForEach-Object
{  
	[VideoDownload]$video = [VideoDownload]::new($_); 
	$video.SourceURL = $sourceURL; 
	$video.Result = youtube-dl $_;
	$video;
	$DownloadedVideos.Add($video);
}

#>
$DownloadedVideos | Export-Csv -Path $DownloadedVideoListPath -Append

#$test | foreach { $_ -Split "/" | Select-Object -Last 1 }

#$test | foreach {  [VideoDownload]$video = [VideoDownload]::new($_); $video.SourceURL = $sourceURL; $video }

<#
Invoke-WebRequest $sourceURL | Select-Object -ExpandProperty Links | Select-Object -ExpandProperty href | foreach { if($_ -like "https://www.wsj.com/video/*") { youtube-dl $_  }}

$test = Invoke-WebRequest $sourceURL | `
Select-Object -ExpandProperty Links | `
Where-Object -Property href -like "$sourceURL*" |
Select-Object -ExpandProperty href

#>