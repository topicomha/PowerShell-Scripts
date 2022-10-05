$key = "78595a446a21105c7d4c65c3032ca275d6f5c45f"
<#
$response = Invoke-RestMethod 'http://redmine.zapways.com/projects/16/versions.json?key=78595a446a21105c7d4c65c3032ca275d6f5c45f' -Method 'GET' -Headers $headers
$response | ConvertTo-Json
$key = 78595a446a21105c7d4c65c3032ca275d6f5c45f
$key = "78595a446a21105c7d4c65c3032ca275d6f5c45f"
$response = Invoke-RestMethod "http://redmine.zapways.com/projects/16/versions.json?key=$key" -Method 'GET' -Headers $headers
$response | ConvertTo-Json | select -p id, name, status
$response | ConvertTo-Json 
$versions = $response | ConvertTo-Json 
$versions = $response | ConvertTo-Json -Depth 3
$versions
$versions | Format-List
$response = Invoke-RestMethod "http://redmine.zapways.com/projects/16/versions.json?key=$key" -Method 'GET' -Headers $headers
$response | ConvertTo-Json 
$versions = $response | ConvertTo-Json -Depth 3
$versions
$versions | Format-List
$versions | Format-Table
$response | ConvertTo-Json -Depth 3
$response | ConvertTo-Json -Depth 5
$response | ConvertTo-Json -Depth 5 | select -ExpandProperty versions
$response | ConvertTo-Json -Depth 5 | select -ExpandProperty version
$response | ConvertTo-Json -Depth 5 | select -ExpandProperty versions
$response | ConvertTo-Json -Depth 5 | gm
$response | ConvertFrom-Json
ConvertFrom-Json $response
ConvertFrom-Json $response | ConvertTo-Json -Depth 5 
$response
$response = Invoke-RestMethod "http://redmine.zapways.com/projects/16/versions.json?key=$key" -Method 'GET' -Headers $headers
$response
ConvertFrom-Json $response | ConvertTo-Json -Depth 5 
$response | ConvertTo-Json -Depth 5 | Format-List
$response | ConvertTo-Json -Depth 5 | gm
$response | ConvertFrom-Json
$response | ConvertTo-Json -Depth 5 | ConvertFrom-Json
$response | ConvertTo-Json -Depth 5 | ConvertFrom-Json | select -ExpandProperty versions
$response | ConvertTo-Json -Depth 5 | ConvertFrom-Json | select -ExpandProperty versions | ft
$response | ConvertTo-Json -Depth 5 | ConvertFrom-Json | select -ExpandProperty versions | where -Property name -like "*Release"
$response | ConvertTo-Json -Depth 5 | ConvertFrom-Json | select -ExpandProperty versions | where -Property name -like "*Release" | ft
$response | ConvertTo-Json -Depth 5 | ConvertFrom-Json | select -ExpandProperty versions | where -Property status -q locked | ft
$response | ConvertTo-Json -Depth 5 | ConvertFrom-Json | select -ExpandProperty versions | where -Property status -eq locked | ft
$response | ConvertTo-Json -Depth 5 | ConvertFrom-Json | select -ExpandProperty versions | where -Property status -eq locked | sort -name desc | ft
$response | ConvertTo-Json -Depth 5 | ConvertFrom-Json | select -ExpandProperty versions | where -Property status -eq locked | sort -Property name -Descending | ft
$response | ConvertTo-Json -Depth 5 | ConvertFrom-Json | select -ExpandProperty versions | where -Property status -eq locked | select -Property id, {[Version]::$_.name.Replace("[^\d|.]", "")} |  sort -Property name -Descending | ft
$response | ConvertTo-Json -Depth 5 | ConvertFrom-Json | select -ExpandProperty versions | where -Property status -eq locked | select -Property id, {$_.name.Replace("[^\d|.]", "")} |  sort -Property name -Descending | ft
$response | ConvertTo-Json -Depth 5 | ConvertFrom-Json | select -ExpandProperty versions | where -Property status -eq locked | select -First 4 -Property id, {$_.name.Replace("[^\d|.]", "")} |  sort -Property name -Descending | ft
$response | ConvertTo-Json -Depth 5 | ConvertFrom-Json | select -ExpandProperty versions | where -Property status -eq locked | select -first 4 -Property id, {[Version]::$_.name.Replace("[^\d|.]", "")} |  sort -Property name -Descending | ft
$response | ConvertTo-Json -Depth 5 | ConvertFrom-Json | select -ExpandProperty versions | where -Property status -eq locked | select -first 4 -Property id, {$($_.name).Replace("[^\d|.]", "")} |  sort -Property name -Descending | ft
$response | ConvertTo-Json -Depth 5 | ConvertFrom-Json | select -ExpandProperty versions | where -Property status -eq locked | select -Property id, {$($_.name).Replace("[^\d|.]", "")} |  sort -Property name -Descending | ft
$response | ConvertTo-Json -Depth 5 | ConvertFrom-Json | select -ExpandProperty versions | where -Property status -eq locked | select -Property id, {$($_.name).Replace("[^\d|.]", "")}, {$($_.name).Replace("[\d|.]", "")} | sort -Property name -Descending | ft
$response | ConvertTo-Json -Depth 5 | ConvertFrom-Json | select -ExpandProperty versions | where -Property status -eq locked | select -Property id, {$($_.name).Replace("[^\d|.]", "")}, {$($_.name) -Replace "[\d|.]" "")} | sort -Property name -Descending | ft
$response | ConvertTo-Json -Depth 5 | ConvertFrom-Json | select -ExpandProperty versions | where -Property status -eq locked | select -Property id, {$($_.name).Replace("[^\d|.]", "")}, {$($_.name) -Replace '[\d|.]' '')} | sort -Property name -Descending | ft
$response | ConvertTo-Json -Depth 5 | ConvertFrom-Json | select -ExpandProperty versions | where -Property status -eq locked | select -Property id, {$($_.name).Replace("[^\d|.]", "")}, {$($_.name -Replace '[\d|.]' '')} | sort -Property name -Descending | ft
$response | ConvertTo-Json -Depth 5 | ConvertFrom-Json | select -ExpandProperty versions | where -Property status -eq locked | select -Property id, {$($_.name).Replace("[^\d|.]", "")}, {$($_.name -Replace '[\d|.]', '')} | sort -Property name -Descending | ft
$response | ConvertTo-Json -Depth 5 | ConvertFrom-Json | select -ExpandProperty versions | where -Property status -eq locked | select -Property id, {$($_.name -Replace "[^\d|.]", "")}, {$($_.name -Replace '[\d|.]', '')} | sort -Property name -Descending | ft
$response | ConvertTo-Json -Depth 5 | ConvertFrom-Json | select -ExpandProperty versions | where -Property status -eq locked | select -Property id, {Version::$($_.name -Replace "[^\d|.]", "")}, {$($_.name -Replace '[\d|.]', '')} | sort -Property name -Descending | ft
$response | ConvertTo-Json -Depth 5 | ConvertFrom-Json | select -ExpandProperty versions | where -Property status -eq locked | select -Property id, Version::{$($_.name -Replace "[^\d|.]", "")}, {$($_.name -Replace '[\d|.]', '')} | sort -Property name -Descending | ft
$response | ConvertTo-Json -Depth 5 | ConvertFrom-Json | select -ExpandProperty versions | where -Property status -eq locked | select -Property id, {$(Version::$_.name -Replace "[^\d|.]", "")}, {$($_.name -Replace '[\d|.]', '')} | sort -Property name -Descending | ft
$response | ConvertTo-Json -Depth 5 | ConvertFrom-Json | select -ExpandProperty versions | where -Property status -eq locked | select -Property id, {$([Version]::$_.name -Replace "[^\d|.]", "")}, {$($_.name -Replace '[\d|.]', '')} | sort -Property name -Descending | ft
$response | ConvertTo-Json -Depth 5 | ConvertFrom-Json | select -ExpandProperty versions | where -Property status -eq locked | select -Property id, {$([Version]::$_.name -Replace "[^\d|.]", "" -split ".")}, {$($_.name -Replace '[\d|.]', '')} | sort -Property name -Descending | ft
$response | ConvertTo-Json -Depth 5 | ConvertFrom-Json | select -ExpandProperty versions | where -Property status -eq locked | select -Property id, {$($_.name -Replace "[^\d|.]", "" -split ".")}, {$($_.name -Replace '[\d|.]', '')} | sort -Property name -Descending | ft
$response | ConvertTo-Json -Depth 5 | ConvertFrom-Json | select -ExpandProperty versions | where -Property status -eq locked | select -Property id, {$([Version]::new($_.name -Replace "[^\d|.]", "" -split "."))}, {$($_.name -Replace '[\d|.]', '')} | sort -Property name -Descending | ft
$response | ConvertTo-Json -Depth 5 | ConvertFrom-Json | select -ExpandProperty versions | where -Property status -eq locked | select -Property id, {$($_.name -Replace "[^\d|.]", "" -split ".")}, {$($_.name -Replace '[\d|.]', '')} | sort -Property name -Descending | ft
$response | ConvertTo-Json -Depth 5 | ConvertFrom-Json | select -ExpandProperty versions | where -Property status -eq locked | select -Property id, {$($_.name -Replace "[^\d|.]", "" -split ".")}, {$($_.name -Replace '[\d|.]', '')} | sort -Property name -Descending | gm
$response | ConvertTo-Json -Depth 5 | ConvertFrom-Json | select -ExpandProperty versions | where -Property status -eq locked | select -Property id, {$($_.name -Replace "[^\d|.]", "" -split "."), version}, {$($_.name -Replace '[\d|.]', '')} | sort -Property name -Descending | gm
$response | ConvertTo-Json -Depth 5 | ConvertFrom-Json | select -ExpandProperty versions | where -Property status -eq locked | select -Property id, version={$($_.name -Replace "[^\d|.]", "" -split ".")}, {$($_.name -Replace '[\d|.]', '')} | sort -Property name -Descending | gm

#>

$response = Invoke-RestMethod "http://redmine.zapways.com/projects/16/versions.json?key=$key" -Method 'GET' -Headers $headers | ConvertTo-Json -Depth 3 | ConvertFrom-Json 
#$response
$versions = $response | select -ExpandProperty versions 
#$versions
$version = @{l="Version";e={$_.name -Replace "[^\d|.]", "" }}
$buildversions = $versions | select -Property *,@{l="VersionNumber";e={$ver = $_.name -Replace '[^\d|.]', ''; $verlist = $ver -split {$_ -eq "."}; [Version]::new($verlist[0],$verlist[1],$verlist[2])}}, @{l="IsRelease";e={$_.name -like "*Release"}} | sort -Property VersionNumber -Descending

$versions | where -Property status -eq locked | select -Property id, $version, {$($_.name -Replace '[\d|.]', '')} 

| sort -Property name -Descending 

$buildversions | select -Property @{l="VersionNumber";e={$verlist = $_.version -split {$_ -eq "."}; [Version]::new($verlist[0],$verlist[1],$verlist[2])}}

$buildversions