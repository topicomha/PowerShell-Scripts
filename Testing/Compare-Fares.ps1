function Read-LowFareSearchResponse {
	param (
		[Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		$reponse
	)
	process {
		[xml]$rs = $reponse
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
		$OptionsResults = [PSCustomObject]@{
			Environment = 
			Options = 
		} $Options
	}
}
#$result = Get-Content "C:\Users\david.boyd.ZAPWAYS\LFSResponse\1-PA-David-20220823T015135.xml" | Read-LowFareSearchResponse


function Compare-Options {
	param (
		[Parameter(Mandatory)]
		$Options1,
		[Parameter(Mandatory)]
		$Options2
	)

	process {
		"test"
		$Options
	}	
}

$one = gc "C:\Users\david.boyd.ZAPWAYS\LFSResponse\1-PA-David-20220823T015135.xml"
$two = gc "C:\Users\david.boyd.ZAPWAYS\LFSResponse\1-PA-Mobile-20220823T015133.xml"
$three = gc "C:\Users\david.boyd.ZAPWAYS\LFSResponse\1-PA-Test-20220823T015131.xml"

$one, $two, $three | Read-LowFareSearchResponse | Compare-Options


class Segment {
	[string]$AircraftType
	[string]$DaysBack
	[string]$DaysForward
	[string]$DepartureDateTime
	[string]$DepartureUTCOffset
	[string]$DestinationCode
	[string]$FlightNumber
	[string]$OriginCode
	[string]$SSRAvailableList
	[string]$SegmentBlock
	[string]$ArrivalDateTime
	[string]$ArrivalUTCOffset
	[string]$DepartureDateTimeScheduled
	[string]$FlightStatusCode
	[string]$MarketingCarrier
	[string]$NumberOfStops
	[string]$OperatingBookingCode
	[string]$OperatingCarrier
	[string]$OperatingCarrierFullName
	[string]$OperatingFlightNumber
}








class AirAPIEnvironment {
	[string]$Name
	[string]$AirlineCode
	[string]$URL
	[string]$APIClientID
	[string]$APIClientKey
	[string]$APIUserKey
	[string]$SchemaVersion
	[string]$UTCOffset
	[string]$DefaultCityPair


	AirAPIEnvironment([string]$envName)	{
		$this.Name = $envName
		switch ($envName) {
			"UB-Local" {
				$this.AirlineCode = "UB"
				$this.URL = "http://localhost:45500/AirAPI/AirAPI.svc"
				$this.SchemaVersion = "191.0"
				$this.APIClientID = "1901"
				$this.APIClientKey = "CF2953C797C1F64B01633ADC29013A080A"
				$this.APIUserKey = "C9w/Q/K8kR6BU9Z7qR7d6Sn6ZCD47Uaw"
				$this.DefaultCityPair = "RGN-BKK"
				$this.UTCOffset = "-07"
			}
			"UB-David" {
				$this.AirlineCode = "UB"
				$this.URL = "http://mobile.zap/v1.04.190/AirAPI.svc"
				$this.SchemaVersion = "191.0"
				$this.APIClientID = "1901"
				$this.APIClientKey = "CF2953C797C1F64B01633ADC29013A080A"
				$this.APIUserKey = "C9w/Q/K8kR6BU9Z7qR7d6Sn6ZCD47Uaw"
				$this.DefaultCityPair = "RGN-BKK"
				$this.UTCOffset = "-07"
			}
			"UB-Mobile" {
				$this.AirlineCode = "UB"
				$this.URL = "https://mobileapptest.zapways.com/v1.04.191.3/AirAPI.svc"
				$this.SchemaVersion = "191.0"
				$this.APIClientID = "1901"
				$this.APIClientKey = "CF2953C797C1F64B01633ADC29013A080A"
				$this.APIUserKey = "C9w/Q/K8kR6BU9Z7qR7d6Sn6ZCD47Uaw"
				$this.DefaultCityPair = "RGN-BKK"
				$this.UTCOffset = ""
			}
			"UB-Test" {
				$this.AirlineCode = "UB"
				$this.URL = "https://ubtest.zapways.com/airapi/v1.04/AirAPI.svc"
				$this.SchemaVersion = "191.0"
				$this.APIClientID = "1901"
				$this.APIClientKey = "CF2953C797C1F64B01633ADC29013A080A"
				$this.APIUserKey = "C9w/Q/K8kR6BU9Z7qR7d6Sn6ZCD47Uaw"
				$this.DefaultCityPair = "RGN-BKK"
				$this.UTCOffset = ""
			}
			Default {
				$this.URL = ""
				$this.SchemaVersion = "191.0"
				$this.UTCOffset = ""
			}
		}
	}
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
		[string]$saveFolder = ".",
		[switch]$overrideSaveFile
	)
	process {

		#region Set Base Date
		if ($baseDate -eq $null) {
			$now = Get-date 
			Write-Host "Parameter BaseDate is empty. Using $now as the BaseDate"
			$baseDate = $now 
		}
		else {
			Write-Host "Paramater BaseDate was passed in as $baseDate"
		}
		#endregion

		#region Load Environment
		$currentAirAPIEnvironment = [AirAPIEnvironment]::new($environment)
		
		if (-not ($currentAirAPIEnvironment.URL)) {
			Write-Error "Error while trying to create the Environment. Could not find URL for Environment: $($currentAirAPIEnvironment.Name)"
			return
		}
		else {
			Write-Host "Using Environment:`n`t$($currentAirAPIEnvironment.Name)`n`tUrl: $($currentAirAPIEnvironment.URL)"
		}
		#endregion

		#region Build Request Headers
		$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
		$headers.Add("SOAPAction", "http://tempuri.org/IAirAPI/LowFareSearch")
		$headers.Add("Content-Type", "text/xml")
		#$headers.Add("Cookie", "__cflb=02DiuHcEzXPtvXUAUH5zSsGYaGmYTe2zwSTEiAFN3H21X")

		Write-Host "Finished Building HTML Headers"
		#endregion

		#region Build Request
		$maskedAPIClientID = $currentAirAPIEnvironment.APIClientID | Hide-Text 2
		$maskedAPIClientKey = $currentAirAPIEnvironment.APIClientKey | Hide-Text 15
		$maskedAPIUserKey = $currentAirAPIEnvironment.APIUserKey | Hide-Text 15
	
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
		$request = $request -replace "{{APIUserKey}}", $currentAirAPIEnvironment.APIUserKey
		$request = $request -replace "{{OriginCode}}", $originCode
		$request = $request -replace "{{DestinationCode}}", $destinationCode

		Write-Host "Finished Building Request from Template.
		`tSchemaVersion: $($currentAirAPIEnvironment.SchemaVersion)
		`tAPIClientID: $maskedAPIClientID
		`tAPIClientKey: $maskedAPIClientKey
		`tAPIUserKey: $maskedAPIUserKey
		`tOriginDate: $originDate
		`tReturnDate: $returnDate
		`tOriginCode: $originCode
		`tDestinationCode: $destinationCode"
		Write-Debug $request
		#endregion

		#region Get Reponse
	
		Write-Host "Getting Response"
		try {
			$reponse = Invoke-RestMethod $currentAirAPIEnvironment.URL -Method 'POST' -Headers $headers -Body $request
			$ResponseResults = [PSCustomObject]@{
				Environment = $currentAirAPIEnvironment
				Response = $reponse
			}
		}
		catch {
			Write-Error "StatusCode:" $_.Exception.Response.StatusCode.value__ 
			Write-Error "StatusDescription:" $_.Exception.Response.StatusDescription
			return 
		}
		#endregion
	
		#region Save Response
		if ($saveResponse) {
			$saveFilePath = Join-Path -Path $saveFolder -ChildPath "$($currentAirAPIEnvironment.Name)-$(get-date -f yyyyMMddThhmmss).xml"
			$ResponseResults | Add-Member -NotePropertyName FilePath -NotePropertyValue $saveFilePath

			if (-not (Test-Path saveFilePath) -or $overrideSaveFile) {
				Write-Host "Saving file: $saveFilePath"
				$reponse.Save($saveFilePath)
			}
			else {			
				Write-Warning "Saving file would override the current file: $savePath. use -OverrideSaveFile if this is ok"
			}
		}
		#endregion}

		Write-Host "Finished Getting Response."
		
		Write-Output $ResponseResults
	}
}
function test-xmlinput {
	param (
		[Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[System.Xml.XmlElement]$originDestinationOptionsXML
	)
	$originDestinationOptionsXML
	$originDestinationOptionsXML.FlightSegmentSets.FlightSegmentSet.PricedFlightSegmentGroups.PricedFlightSegmentsGroup.FlightSegments.FlightSegment 
}
function Read-LowFareSearchResponse {
	param (
		[Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		$reponse
	)
	process {
		[xml]$rs = $reponse
		$Options = @()
		foreach ($opt in $rs.Envelope.Body.LowFareSearchResponse.LowFareSearchResult.OriginDestinationOptions.OriginDestinationOptions) {
			$flights = $opt.FlightSegmentSets.FlightSegmentSet.PricedFlightSegmentGroups.PricedFlightSegmentsGroup.FlightSegments.FlightSegment
			
			$faresXML = $opt.FlightSegmentSets.FlightSegmentSet.PricedFlightSegmentGroups.PricedFlightSegmentsGroup.FaresAvailable.FareDetails
			
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
		$Options
	}
}

#gc "C:\Users\david.boyd.ZAPWAYS\LFSResponse\9-UB-Test-20220823T044313.xml" | Read-LowFareSearchResponse
<#
function Read-LowFareSearchResponse {
	param(
		[XML]$reponse
		)
		$PricedFlights = $reponse.Envelope.Body.LowFareSearchResponse.LowFareSearchResult.OriginDestinationOptions.OriginDestinationOptions.FlightSegmentSets.FlightSegmentSet.PricedFlightSegmentGroups.PricedFlightSegmentsGroup 
		
		
	$Flights = [System.Collections.ArrayList]::new()

	foreach ($pFlight in $PricedFlights) {
		$pSegments = $pFlight.FlightSegments.FlightSegment
		#$pSegments

		$flight = [PSCustomObject]@{
			AircraftType               = $pSegments.AircraftType
			DaysBack                   = $pSegments.DaysBack
			DaysForward                = $pSegments.DaysForward
			DepartureDateTime          = $pSegments.DepartureDateTime
			DepartureUTCOffset         = $pSegments.DepartureUTCOffset
			DestinationCode            = $pSegments.DestinationCode
			FlightNumber               = $pSegments.FlightNumber
			OriginCode                 = $pSegments.OriginCode
			SSRAvailableList           = $pSegments.SSRAvailableList
			SegmentBlock               = $pSegments.SegmentBlock
			ArrivalDateTime            = $pSegments.ArrivalDateTime
			ArrivalUTCOffset           = $pSegments.ArrivalUTCOffset
			DepartureDateTimeScheduled = $pSegments.DepartureDateTimeScheduled
			FlightStatusCode           = $pSegments.FlightStatusCode
			MarketingCarrier           = $pSegments.MarketingCarrier
			NumberOfStops              = $pSegments.NumberOfStops
			OperatingBookingCode       = $pSegments.OperatingBookingCode
			OperatingCarrier           = $pSegments.OperatingCarrier
			OperatingCarrierFullName   = $pSegments.OperatingCarrierFullName
			OperatingFlightNumber      = $pSegments.OperatingFlightNumber
		}
		#$flight

		$pricedFares = $pFlight.FaresAvailable.FareDetails
		$fares = [System.Collections.ArrayList]::new()

		foreach ($pFare in $pricedFares) {
			#$pFare
			$fare = [PSCustomObject]@{
				BookingCode           = $pFare.BookingCode
				CabinClass            = $pFare.CabinClass
				FamilyCode            = $pFare.FamilyCode
				FamilyName            = $pFare.FamilyName
				ReservationStatusCode = $pFare.ReservationStatusCode
				SeatsAvailable        = $pFare.SeatsAvailable
				TotalFare             = $pFare.TotalFare
				ValidityPeriod        = $pFare.ValidityPeriod
				ADTRuleCodes          = $pFare.PaxTypeFares.PaxTypeFare | Where-Object { $_.PassengerCode -eq "ADT" } | Select-Object -Property @{ N = "ADTFareBasisCode"; E = { $_.FareBasisCode + "-" + $_.FareRuleCode } } | Select-Object -ExpandProperty ADTFareBasisCode | Join-String -Separator ", " 
			}
			#$fare
			$fares += $fare		
		}
		$flight | Add-Member -NotePropertyName "Fares" -NotePropertyValue $fares
		$Flights += $flight
	}
	#$Flights 
	foreach ($flt in $Flights) {
		$flt | select -Property FlightNumber, OriginCode, DestinationCode , DepartureDateTime | Format-Table
		
		$flt | select -ExpandProperty Fares | select -Property  BookingCode, FamilyCode, ReservationStatusCode, TotalFare, ADTRuleCodes | Format-Table
		
		#$flt | select -ExpandProperty Fares | select -ExpandProperty  ADTRuleCodes | Format-Table

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
#region Request
$RequestTemplate = "<Envelope
	`n    xmlns=`"http://schemas.xmlsoap.org/soap/envelope/`"
	`n    xmlns:tem=`"http://tempuri.org/`"    >
	`n    <Header/>
	`n    <Body>
	`n        <tem:LowFareSearch>
	`n            <tem:request xmlns=`"http://www.zapways.com/AirAPI/V1.04/{{SchemaVersion}}`">
	`n                <APIClientID>{{APIClientID}}</APIClientID>
	`n                <APIClientKey>{{APIClientKey}}</APIClientKey>
	`n                <EchoToken>test</EchoToken>
	`n                <Target>Test</Target>
	`n                <TimeStamp />
	`n                <Version>1.04</Version>
	`n                <APIUserKey>{{APIUserKey}}</APIUserKey>
	`n                <AgentID>test</AgentID>
	`n                <ClientAddress />
	`n                <EndUserAddress />
	`n                <OriginDestinationInformation>
	`n                    <FlightSearchOriginDestinationInformation>
	`n                        <DaysBack>0</DaysBack>
	`n                        <DaysForward>0</DaysForward>
	`n                        <DepartureDateTime>{{OriginDate}}</DepartureDateTime>
	`n                        <DestinationCode>{{DestinationCode}}</DestinationCode>
	`n                        <OriginCode>{{OriginCode}}</OriginCode>
	`n                    </FlightSearchOriginDestinationInformation>
	`n                    <!--<FlightSearchOriginDestinationInformation>
	`n                        <DaysBack>0</DaysBack>
	`n                        <DaysForward>0</DaysForward>
	`n                        <DepartureDateTime>{{ReturnDate}}</DepartureDateTime>
	`n                        <DestinationCode>{{OriginCode}}</DestinationCode>
	`n                        <OriginCode>{{DestinationCode}}</OriginCode>
	`n                    </FlightSearchOriginDestinationInformation>-->
	`n                </OriginDestinationInformation>
	`n                <DaysBack>0</DaysBack>
	`n                <DaysForward>4</DaysForward>
	`n                <PaxTypes>
	`n                    <PaxTypeCount>
	`n                        <PaxCode>ADT</PaxCode>
	`n                        <PaxCount>1</PaxCount>
	`n                    </PaxTypeCount>
	`n                    <PaxTypeCount>
	`n                        <PaxCode>CHD</PaxCode>
	`n                        <PaxCount>0</PaxCount>
	`n                    </PaxTypeCount>
	`n                    <PaxTypeCount>
	`n                        <PaxCode>INF</PaxCode>
	`n                        <PaxCount>0</PaxCount>
	`n                    </PaxTypeCount>
	`n                </PaxTypes>
	`n            </tem:request>
	`n        </tem:LowFareSearch>
	`n    </Body>
	`n</Envelope>"
#endregion

#$localReponse = Get-LowFareSearchResponse -environment "UB-David" -saveResponse

#$mobileReponse = Get-LowFareSearchResponse -environment "UB-Mobile"

#testReponse = Get-LowFareSearchResponse -environment "UB-Test"

#"UB-David" | Get-LowFareSearchResponse -saveResponse

#Read-LowFareSearchResponse $localReponse

#Read-LowFareSearchResponse $mobileReponse

#Read-LowFareSearchResponse $testReponse
	
class Fare {
	[string]$BookingCode
	[string]$CabinClass 
	[string]$FamilyCode 
	[string]$FamilyName 
	[string]$ReservationStatusCode
	[string]$SeatsAvailable
	[string]$TotalFare
	[string]$ValidityPeriod
	[string]$ADTRuleCodes

	Fare([System.Xml.XmlElement]$fareXML) {
		$this.BookingCode = $fareXML.BookingCode
		$this.CabinClass = $fareXML.CabinClass
		$this.FamilyCode = $fareXML.FamilyCode
		$this.FamilyName = $fareXML.FamilyName
		$this.ReservationStatusCode = $fareXML.ReservationStatusCode
		$this.SeatsAvailable = $fareXML.SeatsAvailable
		$this.TotalFare = $fareXML.TotalFare
		$this.ValidityPeriod = $fareXML.ValidityPeriod
		$this.ADTRuleCodes = $fareXML.PaxTypeFares.PaxTypeFare | Where-Object { $_.PassengerCode -eq "ADT" } | Select-Object -Property @{ N = "ADTFareBasisCode"; E = { $_.FareBasisCode + "-" + $_.FareRuleCode } } | Select-Object -ExpandProperty ADTFareBasisCode | Join-String -Separator "," 
	}
}