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

	AirAPIEnvironment([string]$envName, [string]$envPath) {
		$foundEnv = Get-Content $envPath | ConvertFrom-Csv | Where-Object -Property Name -eq $envName

		if ($foundEnv) {
			$this.Name = $envName
			$this.AirlineCode = $foundEnv.AirlineCode
			$this.URL = $foundEnv.URL
			$this.APIClientID = $foundEnv.APIClientID
			$this.APIClientKey = $foundEnv.APIClientKey
			$this.Username = $foundEnv.Username
			$this.Password = $foundEnv.Password
			$this.UserKey = $foundEnv.UserKey
			$this.SchemaVersion = $foundEnv.SchemaVersion
			$this.UTCOffset = $foundEnv.UTCOffset
			$this.DefaultCityPair = $foundEnv.DefaultCityPair
			$this.ClientCertificate = $foundEnv.ClientCertificate
		}
	}
	<#
	AirAPIEnvironment([string]$envName)	{
		$this.Name = $envName
		switch ($envName) {
			"UB-Local" {
				$this.AirlineCode = "UB"
				$this.URL = "http://localhost:45500/AirAPI/AirAPI.svc"
				$this.SchemaVersion = "191.0"
				$this.APIClientID = "1901"
				$this.APIClientKey = "CF2953C797C1F64B01633ADC29013A080A"
				$this.UserKey = "C9w/Q/K8kR6BU9Z7qR7d6Sn6ZCD47Uaw"
				$this.DefaultCityPair = "RGN-BKK"
				$this.UTCOffset = "-07:00"
			}
			"UB-David" {
				$this.AirlineCode = "UB"
				$this.URL = "http://mobile.zap/v1.04.190/AirAPI.svc"
				$this.SchemaVersion = "191.0"
				$this.APIClientID = "1901"
				$this.APIClientKey = "CF2953C797C1F64B01633ADC29013A080A"
				$this.UserKey = "C9w/Q/K8kR6BU9Z7qR7d6Sn6ZCD47Uaw"
				$this.DefaultCityPair = "RGN-BKK"
				$this.UTCOffset = "-07:00"
			}
			"UB-Mobile" {
				$this.AirlineCode = "UB"
				$this.URL = "https://mobileapptest.zapways.com/v1.04.191.3/AirAPI.svc"
				$this.SchemaVersion = "191.0"
				$this.APIClientID = "1901"
				$this.APIClientKey = "CF2953C797C1F64B01633ADC29013A080A"
				$this.UserKey = "C9w/Q/K8kR6BU9Z7qR7d6Sn6ZCD47Uaw"
				$this.DefaultCityPair = "RGN-BKK"
				$this.UTCOffset = "+06:30"
			}
			"UB-OTA" {
				$this.AirlineCode = "UB"
				$this.URL = "https://otatest.zapways.com/v1.04.191.3/AirAPI.svc"
				$this.SchemaVersion = "191.0"
				$this.APIClientID = "1912"
				$this.APIClientKey = "8D717A9B5808A36B0CEA4B774FB523861A"
				$this.UserKey = "C9w/Q/K8kR6BU9Z7qR7d6Sn6ZCD47Uaw"
				$this.DefaultCityPair = "RGN-BKK"
				$this.UTCOffset = "+06:30"
			}
			"UB-Test" {
				$this.AirlineCode = "UB"
				$this.URL = "https://ubtest.zapways.com/airapi/v1.04/AirAPI.svc"
				$this.SchemaVersion = "191.0"
				$this.APIClientID = "1901"
				$this.APIClientKey = "CF2953C797C1F64B01633ADC29013A080A"
				$this.UserKey = "C9w/Q/K8kR6BU9Z7qR7d6Sn6ZCD47Uaw"
				$this.DefaultCityPair = "RGN-BKK"
				$this.UTCOffset = "+06:30"
			}
			"VQ-David" {
				$this.AirlineCode = "VQ"
				$this.URL = "http://mobile.zap/v1.04.190/AirAPI.svc"
				$this.SchemaVersion = "191.0"
				$this.APIClientID = "1912"
				$this.APIClientKey = "B3A0010F08086D112EFB98460FB10DA11D"
				$this.UserKey = "iR17ei5YtDrEqbF+AQLZzO7pMj4GtIhVWMZOSASFTgs="
				$this.DefaultCityPair = "CGP-DAC"
				$this.UTCOffset = "-07:00"
			}
			"VQ-Mobile" {
				$this.AirlineCode = "VQ"
				$this.URL = "https://mobileapptest.zapways.com/v1.04.191.3/AirAPI.svc"
				$this.SchemaVersion = "191.0"
				$this.APIClientID = "1912"
				$this.APIClientKey = "B3A0010F08086D112EFB98460FB10DA11D"
				$this.UserKey = "iR17ei5YtDrEqbF+AQLZzO7pMj4GtIhVWMZOSASFTgs="
				$this.DefaultCityPair = "CGP-DAC"
				$this.UTCOffset = "+06:30"
			}
			"VQ-Test" {
				$this.AirlineCode = "VQ"
				$this.URL = "https://vqtest.zapways.com/airapi/v1.04/AirAPI.svc"
				$this.SchemaVersion = "191.0"
				$this.APIClientID = "1912"
				$this.APIClientKey = "B3A0010F08086D112EFB98460FB10DA11D"
				$this.UserKey = "iR17ei5YtDrEqbF+AQLZzO7pMj4GtIhVWMZOSASFTgs="
				$this.DefaultCityPair = "CGP-DAC"
				$this.UTCOffset = "+1"
			}
			"VQ-OTA" {
				$this.AirlineCode = "VQ"
				$this.URL = "https://otatest.zapways.com/airapi/v1.04/AirAPI.svc"
				$this.SchemaVersion = "191.0"
				$this.APIClientID = "1912"
				$this.APIClientKey = "B3A0010F08086D112EFB98460FB10DA11D"
				$this.UserKey = "iR17ei5YtDrEqbF+AQLZzO7pMj4GtIhVWMZOSASFTgs="
				$this.DefaultCityPair = "CGP-DAC"
				$this.UTCOffset = "+1"
			}
			"PA-David" {
				$this.AirlineCode = "PA"
				$this.URL = "http://mobile.zap/v1.04.190/AirAPI.svc"
				$this.SchemaVersion = "191.0"
				$this.APIClientID = "1000"
				$this.APIClientKey = "C6470B128F1935CB7B80994E9B7C3EF113"
				$this.UserKey = "IV6aLtd9G8yZSJD1QGB72RwC+28Bq+aD"
				$this.DefaultCityPair = "ISB-KHI"
				$this.UTCOffset = "-07:00"
			}
			"PA-Mobile" {
				$this.AirlineCode = "PA"
				$this.URL = "https://mobileapptest.zapways.com/v1.04.191.3/AirAPI.svc"
				$this.SchemaVersion = "191.0"
				$this.APIClientID = "1000"
				$this.APIClientKey = "C6470B128F1935CB7B80994E9B7C3EF113"
				$this.UserKey = "IV6aLtd9G8yZSJD1QGB72RwC+28Bq+aD"
				$this.DefaultCityPair = "ISB-KHI"
				$this.UTCOffset = "+06:30"
			}
			"PA-Test" {
				$this.AirlineCode = "PA"
				$this.URL = "https://patest.zapways.com/airapi/v1.04/AirAPI.svc"
				$this.SchemaVersion = "191.0"
				$this.APIClientID = "1000"
				$this.APIClientKey = "C6470B128F1935CB7B80994E9B7C3EF113"
				$this.UserKey = "IV6aLtd9G8yZSJD1QGB72RwC+28Bq+aD"
				$this.DefaultCityPair = "ISB-KHI"
				$this.UTCOffset = "+5"
			}
			"PA-Test" {
				$this.AirlineCode = "PA"
				$this.URL = "https://otatest.zapways.com/airapi/v1.04/AirAPI.svc"
				$this.SchemaVersion = "191.0"
				$this.APIClientID = "1000"
				$this.APIClientKey = "C6470B128F1935CB7B80994E9B7C3EF113"
				$this.UserKey = "IV6aLtd9G8yZSJD1QGB72RwC+28Bq+aD"
				$this.DefaultCityPair = "ISB-KHI"
				$this.UTCOffset = "+5"
			}
			Default {
				$this.URL = ""
				$this.SchemaVersion = "191.0"
				$this.UTCOffset = ""
			}
		}
	}
	#>
}

function Get-LowFareSearchResponse {
	param (
		# Airline Environment to use when building the Request
		[Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[string]$environment,
		[DateTimeOffset]$baseDate,
		[int]$dateOffset = 0,
		[int]$dateIncrement = 1,
		[string]$cityPair,
		[switch]$saveResponse,
		[string]$saveFolder = $pwd,
		[switch]$overrideSaveFile
	)
	begin {
		$runCountFilePath = "$PSScriptRoot\runcount.txt"
		$environmentsPath = "$PSScriptRoot\environments.csv"

		[int]$runcount = 1
		if (Test-Path $runCountFilePath) {
			$runcount = Get-Content -Path $runCountFilePath
			$runcount ++
		}
		$runcount | Out-File $runCountFilePath -Force
	}

	process {
		#region Set Base Date
		if ($baseDate -eq $null) {
			$now = Get-date 
			Write-Verbose "Parameter BaseDate is empty. Using $now as the BaseDate"
			$baseDate = $now 
		}
		else {
			Write-Verbose "Paramater BaseDate was passed in as $baseDate"
		}
		#endregion

		#region Load Environment
		$currentAirAPIEnvironment = [AirAPIEnvironment]::new($environment, $environmentsPath)
		
		if (-not ($currentAirAPIEnvironment.URL)) {
			Write-Error "Error while trying to create the Environment. Could not find URL for Environment: $($currentAirAPIEnvironment.Name)"
			return
		}
		else {
			Write-Verbose "Using Environment:`n`t$($currentAirAPIEnvironment.Name)`n`tUrl: $($currentAirAPIEnvironment.URL)"
		}
		#endregion

		#region Build Request Headers
		$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
		$headers.Add("SOAPAction", "http://tempuri.org/IAirAPI/LowFareSearch")
		$headers.Add("Content-Type", "text/xml")
		#$headers.Add("Cookie", "__cflb=02DiuHcEzXPtvXUAUH5zSsGYaGmYTe2zwSTEiAFN3H21X")

		Write-Verbose "Finished Building HTML Headers"
		#endregion

		#region Build Request
		$maskedAPIClientID = $currentAirAPIEnvironment.APIClientID | Hide-Text 2
		$maskedAPIClientKey = $currentAirAPIEnvironment.APIClientKey | Hide-Text 15
		$maskedUserKey = $currentAirAPIEnvironment.UserKey | Hide-Text 15
	
		$originDate = $baseDate.Date.AddDays($dateOffset).ToString("s")
		$returnDate = $baseDate.AddDays($dateOffset).AddDays($dateIncrement).Date.ToString("s")
	
		if (-not ($cityPair)) {	
			$originCode = $currentAirAPIEnvironment.DefaultCityPair -split "-" | Select-Object -First 1
			$destinationCode = $currentAirAPIEnvironment.DefaultCityPair -split "-" | Select-Object -Last 1
		}
		else {
			$originCode = $cityPair -split "-" | Select-Object -First 1
			$destinationCode = $cityPair -split "-" | Select-Object -Last 1
		}
		$request = $RequestTemplate -replace "{{SchemaVersion}}", $currentAirAPIEnvironment.SchemaVersion
		$request = $request -replace "{{OriginDate}}", $originDate
		$request = $request -replace "{{ReturnDate}}", $returnDate
		$request = $request -replace "{{APIClientID}}", $currentAirAPIEnvironment.APIClientID
		$request = $request -replace "{{APIClientKey}}", $currentAirAPIEnvironment.APIClientKey
		$request = $request -replace "{{UserKey}}", $currentAirAPIEnvironment.UserKey
		$request = $request -replace "{{OriginCode}}", $originCode
		$request = $request -replace "{{DestinationCode}}", $destinationCode

		Write-Verbose "Finished Building Request from Template.
		`tSchemaVersion: $($currentAirAPIEnvironment.SchemaVersion)
		`tAPIClientID: $maskedAPIClientID
		`tAPIClientKey: $maskedAPIClientKey
		`tUserKey: $maskedUserKey
		`tOriginDate: $originDate
		`tReturnDate: $returnDate
		`tOriginCode: $originCode
		`tDestinationCode: $destinationCode"
		Write-Debug $request
		#endregion

		#region Get Reponse
	
		Write-Verbose "Getting Response"
		try {
			if($currentAirAPIEnvironment.ClientCertificate)
			{
				$cert = Get-ChildItem -Path "cert:\CurrentUser\My\$($currentAirAPIEnvironment.ClientCertificate)"
				[xml]$response = Invoke-WebRequest $currentAirAPIEnvironment.URL -Method 'POST' -Headers $headers -Body $request -Certificate $cert	
			}
			else
			{
				[xml]$response = Invoke-WebRequest $currentAirAPIEnvironment.URL -Method 'POST' -Headers $headers -Body $request 	
			}
		}
		catch {
			Write-Error "Message:" $_.Exception.Message
			if ($_.Exception.StatusCode) {
				Write-Error "StatusCode:" $_.Exception.StatusCode.value__ 
			}
			if ($_.Exception.StatusDescription) {
				Write-Error "StatusDescription:" $_.Exception.Response.StatusDescription
			}
			return 
		}
		#endregion
	
		#region Save Response
		if ($saveResponse) {
			$saveFilePath = Join-Path -Path $saveFolder -ChildPath "$runcount-$($currentAirAPIEnvironment.Name)-$(get-date -f yyyyMMddThhmmss).xml"
			if (-not (Test-Path saveFilePath) -or $overrideSaveFile) {
				Write-Verbose "Saving file: $saveFilePath"
				$saved = $response.Save($saveFilePath)
			}
			else {			
				Write-Warning "Saving file would override the current file: $savePath. use -OverrideSaveFile if this is ok"
			}
		}
		#endregion

		Write-Verbose "Finished Getting Response."
		$LFSResponse = [PSCustomObject]@{
			OriginDate      = $originDate
			ReturnDate      = $returnDate
			OriginCode      = $originCode
			DestinationCode = $destinationCode
			Response        = $response
			SavedFilePath   = $saveFilePath
		}

		Write-Output $LFSResponse

	}
}

function Read-LowFareSearchResponse {
	param (
		[Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		$response
	)
	process {
		[xml]$rs = $response.response
		$Options = @()
		foreach ($opt in $rs.Envelope.Body.LowFareSearchResponse.LowFareSearchResult.OriginDestinationOptions.OriginDestinationOptions) {
			$flights = $opt.FlightSegmentSets.FlightSegmentSet.PricedFlightSegmentGroups.PricedFlightSegmentsGroup.FlightSegments.FlightSegment
			
			$faresXML = $opt.FlightSegmentSets.FlightSegmentSet.PricedFlightSegmentGroups.PricedFlightSegmentsGroup.FaresAvailable.FareDetails
			$fareList = @()
			foreach ($f in $faresXML) {
				$adtFareRule = $f.PaxTypeFares.PaxTypeFare  | Where-Object { $_.PassengerCode -eq "ADT" } | Select-Object -Property @{ N = "ADTFareBasisCode"; E = { $_.FareBasisCode + "-" + $_.FareRuleCode } } | Select-Object -ExpandProperty ADTFareBasisCode | Join-String -Separator ", " 
				$f | Add-Member -NotePropertyName ADTFareBasisCode -NotePropertyValue $adtFareRule
				$fareList += $f
			}
			
			$fares = $fareList | Select-Object -Property BookingCode, CabinClass, FamilyCode, ReservationStatusCode, SeatsAvailable, TotalFare, ADTFareBasisCode #, PaxTypeFares , ValidityPeriod

			$option = $opt | Select-Object -Property DaysBack, DaysForward, DepartureDateTime, DepartureUTCOffset, DestinationCode, OriginCode, DepartureDateFound 

			$option | Add-Member -NotePropertyName Flights -NotePropertyValue $flights
			$option | Add-Member -NotePropertyName Fares -NotePropertyValue $fares
			$Options += $option
		}
		
		$results = [PSCustomObject]@{
			Dates    = "$($response.OriginDate)-$($response.ReturnDate)"
			CityPair = "$($response.originCode)-$($response.destinationCode)"
			Options  = $Options
		}
		$results
	}
}
function Compare-LowFareSearchResponse {
	param (
		[Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		$response
	)
	begin {
		$result = @()
		$FirstSet
		$SecondSet
		$ProcessValid = $false
	}
	process {

		if ($FirstSet -and $SecondSet ) {
			Write-Host "Input needs to have just 2 objects"
			return 
		}
		$result += $response
		
		if (!($FirstSet)) {
			$FirstSet = $response
		}
		else {
			$SecondSet = $response
		}
		
		if ($FirstSet -and $SecondSet) {
			$ProcessValid = $true
		}
		<#
if (!($result)) {
	$result = $response
	$firstSet = $response
	foreach ($option in $result.Options) {
				$option | Add-Member -NotePropertyName Set -NotePropertyValue First
			}			
		}
		else {
			foreach ($option in $response.Options) {
				$foundoption = $firstSet | Select-Object -ExpandProperty Options | Where-Object -Property DepartureDateTime -eq $option.DepartureDateTime
				if ($foundoption) {
					#$hasFlights = $result | Compare-Object $foundoption $option
					#$hasFares = $result | Where-Object -Property fares -eq $option.fares
				
					$foundoption.Set = "both"
				}
				else {
					
					$option | Add-Member -NotePropertyName Set -NotePropertyValue Second
					$result.Options += $option
				}
			}
		}
		
		#>
	}
	end {
		if ($ProcessValid) {
			$SameSearch = Compare-Object ($FirstSet | Select-Object -ExcludeProperty Options) ($SecondSet | Select-Object -ExcludeProperty Options)
			if ($SameSearch) {
				Write-Host "Search doesnt match between objects"
				$ProcessValid = $false
				return
			}
		}
		if ($ProcessValid) {
			$SameSearch = Compare-Object ($FirstSet | Select-Object -ExcludeProperty Flights, Fares) ($SecondSet | Select-Object -ExcludeProperty Flights, Fares)
			if ($SameSearch) {
				Write-Host "Search doesnt match between objects"
				$ProcessValid = $false
				return
			}
		}
			
		if ($ProcessValid) {
			$FlightsOnlyFirst = $FirstSet.Flights | Where-Object { $SecondSet.Flights -notcontains $_ }
			$FlightsOnlySecond = $SecondSet.Flights | Where-Object { $FirstSet.Flights -notcontains $_ }
			$result
		}
	}		
}
<#
function Read-LowFareSearchResponse {
	param (
		[Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[xml]$response
	)
	process {
		$Options = @()
		foreach ($opt in $response.Envelope.Body.LowFareSearchResponse.LowFareSearchResult.OriginDestinationOptions.OriginDestinationOptions) {
			$flights = $opt.FlightSegmentSets.FlightSegmentSet.PricedFlightSegmentGroups.PricedFlightSegmentsGroup.FlightSegments.FlightSegment
			
			$faresXML = $opt.FlightSegmentSets.FlightSegmentSet.PricedFlightSegmentGroups.PricedFlightSegmentsGroup.FaresAvailable.FareDetails
			
			foreach ($f in $faresXML) {
				$fare = $f | Add-Member -NotePropertyName ADTFareBasisCode -NotePropertyValue $f.PaxTypeFare | Where-Object { $_.PassengerCode -eq "ADT" } | Select-Object -Property @{ N = "ADTFareBasisCode"; E = { $_.FareBasisCode + "-" + $_.FareRuleCode } } | Select-Object -ExpandProperty ADTFareBasisCode | Join-String -Separator ", " 
				$fare
				$fareList += $fare
			}
			
			$fares = $fareList | Select-Object -Property BookingCode, CabinClass, FamilyCode, ReservationStatusCode, SeatsAvailable, TotalFare, ADTFareBasisCode #, PaxTypeFares , ValidityPeriod
		

			
			$option = $opt | Select-Object -Property DaysBack, DaysForward, DepartureDateTime, DepartureUTCOffset, DestinationCode, OriginCode, DepartureDateFound 
			
			$option | Add-Member -NotePropertyName Flights -NotePropertyValue $flights
			$option | Add-Member -NotePropertyName Fares -NotePropertyValue $fares
			$Options += $option
		}
		$Options
	}
}
#>

function Hide-Text {
	param (
		[Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[string]$Text,
		[Parameter(Position = 1)]
		[int]$NumberOfCharacters = 5,
		[switch]$FromFront
	)
	process {
		$length = $Text.Length
		$textArray = $Text.ToCharArray()
		$newString = ""
		if ($length -lt $NumberOfCharacters) {
			$NumberOfCharacters = $length
		}
		for ($i = 0; $i -lt $textArray.Count; $i++) {
			#$Text[$i]
			if ($FromFront) {
				if ($i -lt $NumberOfCharacters) {
					$newString = $newString + "X"
				}
				else {
					$newString = $newString + $textArray[$i]
				}
			}
			else {
			
				if ($length - $i -le $NumberOfCharacters) {
					$newString = $newString + "X"
				}
				else {
					$newString = $newString + $textArray[$i]
				}
			}
		}
		$newString
	}
}

#region Request
$RequestTemplate = "<Envelope
    xmlns=`"http://schemas.xmlsoap.org/soap/envelope/`"
    xmlns:tem=`"http://tempuri.org/`"    >
    <Header/>
    <Body>
        <tem:LowFareSearch>
            <tem:request xmlns=`"http://www.zapways.com/AirAPI/V1.04/{{SchemaVersion}}`">
                <APIClientID>{{APIClientID}}</APIClientID>
                <APIClientKey>{{APIClientKey}}</APIClientKey>
                <EchoToken>test</EchoToken>
                <Target>Test</Target>
                <TimeStamp />
                <Version>1.04</Version>
                <UserKey>{{UserKey}}</UserKey>
                <AgentID>test</AgentID>
                <ClientAddress />
                <EndUserAddress />
                <OriginDestinationInformation>
                    <FlightSearchOriginDestinationInformation>
                        <DaysBack>0</DaysBack>
                        <DaysForward>0</DaysForward>
                        <DepartureDateTime>{{OriginDate}}</DepartureDateTime>
                        <DestinationCode>{{DestinationCode}}</DestinationCode>
                        <OriginCode>{{OriginCode}}</OriginCode>
                    </FlightSearchOriginDestinationInformation>
                    <!---->
                    <FlightSearchOriginDestinationInformation>
                        <DaysBack>0</DaysBack>
                        <DaysForward>0</DaysForward>
                        <DepartureDateTime>{{ReturnDate}}</DepartureDateTime>
                        <DestinationCode>{{OriginCode}}</DestinationCode>
                        <OriginCode>{{DestinationCode}}</OriginCode>
                    </FlightSearchOriginDestinationInformation>
                </OriginDestinationInformation>
                <DaysBack>0</DaysBack>
                <DaysForward>4</DaysForward>
                <PaxTypes>
                    <PaxTypeCount>
                        <PaxCode>ADT</PaxCode>
                        <PaxCount>1</PaxCount>
                    </PaxTypeCount>
                    <PaxTypeCount>
                        <PaxCode>CHD</PaxCode>
                        <PaxCount>0</PaxCount>
                    </PaxTypeCount>
                    <PaxTypeCount>
                        <PaxCode>INF</PaxCode>
                        <PaxCount>0</PaxCount>
                    </PaxTypeCount>
                </PaxTypes>
            </tem:request>
        </tem:LowFareSearch>
    </Body>
</Envelope>"
#endregion

Get-LowFareSearchResponse "vq-ota"

#"pa-david", "ub-mobile" | Get-LowFareSearchResponse | Read-LowFareSearchResponse | Compare-LowFareSearchResponse 