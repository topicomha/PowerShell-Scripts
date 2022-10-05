$QueueConfig = Get-ChildItem C:\Users\david.boyd.ZAPWAYS\Downloads\SITATest-Queues.csv | Get-Content | ConvertFrom-Csv | where { $_.mq -eq 1 } | select -Property QueueManager, Queue, IP, Port -Unique 
$count = 2
foreach ($quecon in $QueueConfig) {
	"queues.Add(new QueueConfig
	{
		OptionNumber = $count,
		QueueManagerName = `"$($quecon.QueueManager)`",
		QueueName = `"$($quecon.Queue)`",
		//HostName = `"127.0.0.1`",
		Port = `"$($quecon.Port)`",
		ChannelName = `"$($quecon.QueueManager)`",
		//Working = true,
		Username = `"`",
		Password = `"`"
	});"
	$count++
}