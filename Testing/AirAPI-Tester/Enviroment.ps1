

function Get-AirAPIEnvironment {
	
	param 
	(
		[Parameter(Position = 1, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[string]$EnvironmentName,
		[string]$EnvironmentsPath
	)
		
	begin {		
		if (!($EnvironmentsPath)) {
			$EnvironmentsPath = "$PSScriptRoot\environments.csv"
			Write-Verbose "Unable to find Environment File Path. Trying to use $EnvironmentsPath"
		}
		if (!(Test-Path $environmentsPath)) {
			Write-Error "Unable to find Environment File"
		}
	}
		
	process {
		$foundEnv = Get-Content $EnvironmentsPath | ConvertFrom-Csv | Where-Object -Property Name -eq $EnvironmentName

		if ($foundEnv) {
			$airapienv = [AirAPIEnvironment]@{
				Name              = $EnvironmentName
				AirlineCode       = $foundEnv.AirlineCode
				URL               = $foundEnv.URL
				APIClientID       = $foundEnv.APIClientID
				APIClientKey      = $foundEnv.APIClientKey
				Username          = $foundEnv.Username
				Password          = $foundEnv.Password
				UserKey           = $foundEnv.UserKey
				SchemaVersion     = $foundEnv.SchemaVersion
				UTCOffset         = $foundEnv.UTCOffset
				DefaultCityPair   = $foundEnv.DefaultCityPair
				ClientCertificate = $foundEnv.ClientCertificate
			}
			$airapienv
		}
		else {
			Write-Error "Unable to find $EnvironmentName in $EnvironmentsPath CSV file"
		}
	}	
	end {
		Write-Verbose "Finished!"
	}
}

class AirAPIEnvironment {
	[string]$Name
	[string]$AirlineCode
	[string]$URL
	[string]$APIClientID
	[string]$APIClientKey
	[string]$Username
	[string]$Password
	[string]$UserKey
	[string]$SchemaVersion
	[string]$UTCOffset
	[string]$DefaultCityPair
	[string]$ClientCertificate
	
}