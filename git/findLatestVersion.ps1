$version = "2.10.1"

Write-Output("Cloning repo")
git clone http://dev.repo:8100/zw_mobile_airline_app.git test-app

Write-Output("Swiching directory")
cd test-app


Write-Output("Get list of branches")

#$branches = (git for-each-ref --format='%(refname:short)').Split(' ') 


$AllBranches = git branch -l -r
#Write-Output("All branches")
#Write-Output($AllBranches)
#Write-Output("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")

[string[]]$branches =  $AllBranches.Split("\n")
Write-Output($branches)

$TestReleaseBranches = $branches | Where-Object { $_ -match "origin\/_release_mobile.(\d+\.\d+\.?\d*\.?\d*)" }

Write-Output("Version branches")
Write-Output($TestReleaseBranches)


$FoundVersionBranches = $branches | Where-Object { $_ -match "origin\/_release(?:_LIVE)?_mobile.$version[^\.:\d](-.*)?" }

Write-Output("Found Version Branches")
Write-Output($FoundVersionBranches)

$ExactVersionBranch = $branches | Where-Object { $_ -match "origin\/_release(_LIVE)?_mobile.$version$" }

Write-Output("Exact Version Branches")
Write-Output($ExactVersionBranch)

if($ExactVersionBranch)
{
	Write-Output("Found Exact Version Branch - Checking out Branch: $ExactVersionBranch")
	git checkout $ExactVersionBranch.Trim()
}

#$Versions = $TestReleaseBranches | Select-Object Name @{ label='Branch'; expresion={$_} }, @{ l='Version'; e={$_} -match '^origin\/_release_mobile.(\d+\.\d+\.?\d*\.?\d*)' $Matches.groups[1].value }
#$Versions = TestReleaseBranches | Select-String -Pattern '^origin\/_release_mobile.(\d+\.\d+\.?\d*\.?\d*)'
#$Versions = $TestReleaseBranches | Select-Object *, @{Label="Version"; Expression={$_ }}

#Write-Output("Version List")
#Write-Output($TestReleaseBranches)

Write-Output("Swiching back to original directory")
cd ../