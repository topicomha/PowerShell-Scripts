$branches = git branch -r --sort=-committerdate --format="|refname: %(refname)|objecttype: %(objecttype)|objectsize: %(objectsize)|objectname: %(objectname)|tree: %(tree)|parent: %(parent)|numparent: %(numparent)|object: %(object)|type: %(type)|tag: %(tag)|author: %(author)|authorname: %(authorname)|authoremail: %(authoremail)|authordate: %(authordate)|committer: %(committer)|committername: %(committername)|committeremail: %(committeremail)|committerdate: %(committerdate)|committerdate: %(committerdate:relative)|tagger: %(tagger)|taggername: %(taggername)|taggeremail: %(taggeremail)|taggerdate: %(taggerdate)|creator: %(creator)|creatordate: %(creatordate)|subject: %(subject)|body: %(body)|contents: %(contents)|contents-subject: %(contents:subject)|contents-body: %(contents:body)|contents-signature: %(contents:signature)|upstream: %(upstream)|symref: %(symref)|flag: %(flag)|HEAD: %(HEAD) "| ForEach-Object -Process {$_ -replace ",",""}

$branches = $branches | ForEach-Object -Process {$_ -replace ",",""}


$branches | ForEach-Object -Process {$_ -replace "\|",","} | Out-File -FilePath branches.csv

$branches