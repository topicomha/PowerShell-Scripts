

$lastfile = Get-ChildItem C:\Users\david.boyd.ZAPWAYS\Downloads\postmanresponse | sort LastWriteTime | select -Last 1

[xml]$XmlDocument = Get-Content $lastfile

$PricedFlights = $XmlDocument.Envelope.Body.LowFareSearchResponse.LowFareSearchResult.OriginDestinationOptions.OriginDestinationOptions.FlightSegmentSets.FlightSegmentSet.PricedFlightSegmentGroups.PricedFlightSegmentsGroup 


$Flights = [System.Collections.ArrayList]::new()

foreach ($pFlight in $PricedFlights) {
	$pSegments = $pFlight.FlightSegments.FlightSegment
	#$pSegments

	$flight = [PSCustomObject]@{
		AircraftType = $pSegments.AircraftType
		DaysBack = $pSegments.DaysBack
		DaysForward = $pSegments.DaysForward
		DepartureDateTime = $pSegments.DepartureDateTime
		DepartureUTCOffset = $pSegments.DepartureUTCOffset
		DestinationCode = $pSegments.DestinationCode
		FlightNumber = $pSegments.FlightNumber
		OriginCode = $pSegments.OriginCode
		SSRAvailableList = $pSegments.SSRAvailableList
		SegmentBlock = $pSegments.SegmentBlock
		ArrivalDateTime = $pSegments.ArrivalDateTime
		ArrivalUTCOffset = $pSegments.ArrivalUTCOffset
		DepartureDateTimeScheduled = $pSegments.DepartureDateTimeScheduled
		FlightStatusCode = $pSegments.FlightStatusCode
		MarketingCarrier = $pSegments.MarketingCarrier
		NumberOfStops = $pSegments.NumberOfStops
		OperatingBookingCode = $pSegments.OperatingBookingCode
		OperatingCarrier = $pSegments.OperatingCarrier
		OperatingCarrierFullName = $pSegments.OperatingCarrierFullName
		OperatingFlightNumber = $pSegments.OperatingFlightNumber
	}
	#$flight

	$pricedFares = $pFlight.FaresAvailable.FareDetails
	$fares = [System.Collections.ArrayList]::new()

	foreach ($pFare in $pricedFares) {
		#$pFare
		$fare = [PSCustomObject]@{
			BookingCode = $pFare.BookingCode
			CabinClass = $pFare.CabinClass
			FamilyCode = $pFare.FamilyCode
			FamilyName = $pFare.FamilyName
			ReservationStatusCode = $pFare.ReservationStatusCode
			SeatsAvailable = $pFare.SeatsAvailable
			TotalFare = $pFare.TotalFare
			ValidityPeriod = $pFare.ValidityPeriod
			ADTRuleCodes = $pFare.PaxTypeFares.PaxTypeFare | Where-Object { $_.PassengerCode -eq "ADT" } | Select-Object -Property @{ N="ADTFareBasisCode";E={$_.FareBasisCode+"-"+$_.FareRuleCode}} | Select-Object -ExpandProperty ADTFareBasisCode | Join-String -Separator "," 
		}
		#$fare
		$fares += $fare		
	}
	$flight | Add-Member -NotePropertyName "Fares" -NotePropertyValue $fares
	$Flights += $flight
}
$Flights 
foreach ($flt in $Flights) {
	$flt | select -Property FlightNumber, OriginCode, DestinationCode , DepartureDateTime | Format-Table
	
	$flt | select -ExpandProperty Fares | select -Property  BookingCode, FamilyCode, ReservationStatusCode, TotalFare, ADTRuleCodes | Format-Table
	
	#$flt | select -ExpandProperty Fares | select -ExpandProperty  ADTRuleCodes | Format-Table

}


$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("SOAPAction", "http://tempuri.org/IAirAPI/LowFareSearch")
$headers.Add("Content-Type", "text/xml")
$headers.Add("Cookie", "__cflb=02DiuHcEzXPtvXUAUH5zSsGYaGmYTe2zwSTEiAFN3H21X")

$body = "<Envelope
`n    xmlns=`"http://schemas.xmlsoap.org/soap/envelope/`"
`n    xmlns:tem=`"http://tempuri.org/`"    >
`n    <Header/>
`n    <Body>
`n        <tem:LowFareSearch>
`n            <tem:request xmlns=`"http://www.zapways.com/AirAPI/V1.04/191.0`">
`n                <APIClientID>1901</APIClientID>
`n                <APIClientKey>CF2953C797C1F64B01633ADC29013A080A</APIClientKey>
`n                <EchoToken>test</EchoToken>
`n                <Target>Test</Target>
`n                <TimeStamp />
`n                <Version>1.04</Version>
`n                <APIUserKey>C9w/Q/K8kR6BU9Z7qR7d6Sn6ZCD47Uaw</APIUserKey>
`n                <AgentID>AQZFI4XJ5ZTST</AgentID>
`n                <ClientAddress />
`n                <EndUserAddress />
`n                <OriginDestinationInformation>
`n                    <FlightSearchOriginDestinationInformation>
`n                        <DaysBack>0</DaysBack>
`n                        <DaysForward>0</DaysForward>
`n                        <DepartureDateTime>2022-08-23T00:00:00Z</DepartureDateTime><!-- Origin Trip -->
`n                        <DestinationCode>BKK</DestinationCode>
`n                        <OriginCode>RGN</OriginCode>
`n                    </FlightSearchOriginDestinationInformation>
`n                    <!--<FlightSearchOriginDestinationInformation>
`n                        <DaysBack>0</DaysBack>
`n                        <DaysForward>0</DaysForward>
`n                        <DepartureDateTime>2022-08-26T00:00:00Z</DepartureDateTime><!-- Return Trip -->
`n                        <DestinationCode>RGN</DestinationCode>
`n                        <OriginCode>BKK</OriginCode>
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

$response = Invoke-RestMethod 'https://ubtest.zapways.com/airapi/v1.04/AirAPI.svc' -Method 'POST' -Headers $headers -Body $body




<#
$XmlDocument.Envelope.Body.LowFareSearchResponse.LowFareSearchResult.OriginDestinationOptions.OriginDestinationOptions.FlightSegmentSets.FlightSegmentSet.PricedFlightSegmentGroups.PricedFlightSegmentsGroup.FlightSegments.FlightSegment | select -Property DepartureDateTime, DepartureUTCOffset, FlightNumber, OriginCode, DestinationCode, SegmentBlock, DaysBack, DaysForward | Format-Table

#$XmlDocument.Envelope.Body.LowFareSearchResponse.LowFareSearchResult.OriginDestinationOptions.OriginDestinationOptions.FlightSegmentSets.FlightSegmentSet.PricedFlightSegmentGroups.PricedFlightSegmentsGroup.FaresAvailable.FareDetails | select -Property CabinClass, FamilyCode, BookingCode, FamilyName, TotalFare, SeatsAvailable, ReservationStatusCode | Format-Table

#$XmlDocument.Envelope.Body.LowFareSearchResponse.LowFareSearchResult.OriginDestinationOptions.OriginDestinationOptions.FlightSegmentSets.FlightSegmentSet.PricedFlightSegmentGroups.PricedFlightSegmentsGroup.FaresAvailable.FareDetails.PaxTypeFares.PaxTypeFare | select -Property PassengerCode, FareBasisCode, FareRuleCode, BaseFare, TotalFare | Format-Table

function Get-Version {
	
	$PSVersionTable.PSVersion
	
}
function Show-LatestFileResults {
	param (
		[Parameter(Position = 0)]
		[bool]$ShowFlights, 
		[Parameter(Position = 1)]
		[bool]$ShowFares,
		[Parameter(Position = 2)]
		[bool]$ShowFareRules,
		[Parameter(Position = 3, ValueFromPipeline)]
		[string]$FilePath
		)
		$workingFolder =  $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath('.\')
		
		if (Test-Path $FilePath) {
		$lastfile = $FilePath
	}
	else {
		$lastfile = Get-ChildItem -Filter "*.xml" $PSScriptRoot | Sort-Object LastWriteTime | Select-Object -Last 1
	}
	
	Write-Host "Using $lastfile file to look up results"
	
	[xml]$XmlDocument = Get-Content $lastfile
	
	#Write-Host $ShowFlights
	if ($ShowFlights -eq 1) {
		$flightResults = $XmlDocument.Envelope.Body.LowFareSearchResponse.LowFareSearchResult.OriginDestinationOptions.OriginDestinationOptions.FlightSegmentSets.FlightSegmentSet.PricedFlightSegmentGroups.PricedFlightSegmentsGroup.FlightSegments.FlightSegment | Select-Object -Property DepartureDateTime, DepartureUTCOffset, FlightNumber, OriginCode, DestinationCode, SegmentBlock, DaysBack, DaysForward 
		$flightResults | Format-Table
	}
	
	#Write-Host $ShowFares
	if ($ShowFares -eq 1) {
		$fareResults = $XmlDocument.Envelope.Body.LowFareSearchResponse.LowFareSearchResult.OriginDestinationOptions.OriginDestinationOptions.FlightSegmentSets.FlightSegmentSet.PricedFlightSegmentGroups.PricedFlightSegmentsGroup.FaresAvailable.FareDetails | select -Property CabinClass, FamilyCode, BookingCode, FamilyName, TotalFare, SeatsAvailable, ReservationStatusCode 
		$fareResults | Format-Table
	}

	
	#Write-Host $ShowFareRules
	if ($ShowFareRules -eq 1) {
		$fareRuleResults = $XmlDocument.Envelope.Body.LowFareSearchResponse.LowFareSearchResult.OriginDestinationOptions.OriginDestinationOptions.FlightSegmentSets.FlightSegmentSet.PricedFlightSegmentGroups.PricedFlightSegmentsGroup.FaresAvailable.FareDetails.PaxTypeFares.PaxTypeFare | select -Property PassengerCode, FareBasisCode, FareRuleCode, BaseFare, TotalFare
		$fareRuleResults | Format-Table
	}
}

Show-LatestFileResults 1 1
#>