. $PSScriptRoot\Enviroment.ps1
. $PSScriptRoot\Utilities.ps1
. $PSScriptRoot\Settings.ps1 

function Request-AirAPIAuthenticate {
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 1)]
        [string]$EnvironmentName
    )
    
    begin {
        Write-Host "Starting"
        $RequestTemplate = "<Envelope
    xmlns=`"http://schemas.xmlsoap.org/soap/envelope/`"
    xmlns:tem=`"http://tempuri.org/`">
    <Header/>
    <Body>
        <tem:UserAuthentication>
            <tem:request xmlns=`"http://www.zapways.com/AirAPI/V1.04/{{SchemaVersion}}`">
                <APIClientID>{{APIClientID}}</APIClientID>
                <APIClientKey>{{APIClientKey}}</APIClientKey>
                <EchoToken>test</EchoToken>
                <Target>Test</Target>
                <TimeStamp />
                <Version>1.04</Version>
                <!--<UserKey>{{UserKey}}</UserKey>-->
                <AgentID>{{UserID}}</AgentID>
                <ClientAddress />
                <EndUserAddress />
                <AgentPassword>{{UserPassword}}</AgentPassword>
                <UserType>TravelAgent</UserType>
            </tem:request>
        </tem:UserAuthentication>
    </Body>
</Envelope>"

        Write-Verbose $RequestTemplate
    }
    
    process {
        $currentAirAPIEnvironment = Get-AirAPIEnvironment $EnvironmentName

        #region Build Request Headers
        $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $headers.Add("SOAPAction", "http://tempuri.org/IAirAPI/UserAuthentication")
        $headers.Add("Content-Type", "text/xml")

        #$headers.Add("Cookie", "__cflb=02DiuHcEzXPtvXUAUH5zSsGYaGmYTe2zwSTEiAFN3H21X")
        Write-Verbose "Finished Building HTML Headers"
        #endregion

        #region Build Request
        $maskedAPIClientID = $currentAirAPIEnvironment.APIClientID | Hide-Text 2
        $maskedAPIClientKey = $currentAirAPIEnvironment.APIClientKey | Hide-Text 15
        $maskedUserKey = $currentAirAPIEnvironment.UserKey | Hide-Text 15
        $maskedUserPassword = $currentAirAPIEnvironment.Password | Hide-Text 5

        $request = $RequestTemplate -replace "{{SchemaVersion}}", $currentAirAPIEnvironment.SchemaVersion
        $request = $request -replace "{{APIClientID}}", $currentAirAPIEnvironment.APIClientID
        $request = $request -replace "{{APIClientKey}}", $currentAirAPIEnvironment.APIClientKey
        $request = $request -replace "{{UserID}}", $currentAirAPIEnvironment.Username
        $request = $request -replace "{{UserPassword}}", $currentAirAPIEnvironment.Password
        #$request = $request -replace "{{UserKey}}", $currentAirAPIEnvironment.UserKey

        Write-Verbose "Finished Building Request from Template.
    SchemaVersion: $($currentAirAPIEnvironment.SchemaVersion)
    APIClientID: $maskedAPIClientID
    APIClientKey: $maskedAPIClientKey
    UserID: $($currentAirAPIEnvironment.Username)
    UserPassword: $maskedUserPassword
    UserKey: $maskedUserKey (from settings, not used)"
        
    
    Write-Host "Sending Request to $($currentAirAPIEnvironment.URL)" -ForegroundColor Yellow
    Write-Host $request  -ForegroundColor Yellow
    
    #region Get Reponse
	
        Write-Verbose "Getting Response"
        try {
            if ($currentAirAPIEnvironment.ClientCertificate) {
                $cert = Get-ChildItem -Path "cert:\CurrentUser\My\$($currentAirAPIEnvironment.ClientCertificate)"
                [xml]$response = Invoke-WebRequest $currentAirAPIEnvironment.URL -Method 'POST' -Headers $headers -Body $request -Certificate $cert	
            }
            else {
                [xml]$response = Invoke-WebRequest $currentAirAPIEnvironment.URL -Method 'POST' -Headers $headers -Body $request
            }
            
            $response 

            Write-Host "Returned Response"  -ForegroundColor Green
            Write-Host $($response.Envelope.Body.UserAuthenticationResponse.UserAuthenticationResult) -ForegroundColor Green
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
    }
    
    end {
        Write-Verbose "Finished"
    }
}
