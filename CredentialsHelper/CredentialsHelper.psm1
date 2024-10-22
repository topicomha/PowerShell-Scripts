Import-Module EncryptionHelper -Verbose

# Define the path to the secure credentials file
$credentialFilePath = Join-Path -Path $PSScriptRoot -ChildPath "SecureCredentials.pwsh"

# Initialize the hashtable to store credentials
$credentialsTable = @{}

# Function to save the credentials table to the file (private)
function Save-CredentialsTable {
    [CmdletBinding()]
    param (
        [string]$username
    )
    Write-Verbose "Saving credentials table to file: $credentialFilePath"
    $jsonContent = $credentialsTable | ConvertTo-Json
    if ($jsonContent) {
        Write-Verbose "JSON content generated successfully."
        Write-Verbose "JSON content: $jsonContent"
        $secureString = ConvertTo-SecureString -String $jsonContent -AsPlainText -Force
        $encryptedContent = ConvertFrom-SecureString -SecureString $secureString
        $encryptedContent | Set-Content -Path $credentialFilePath
        Write-Verbose "Credentials table saved successfully."
    } else {
        Write-Verbose "JSON content is null or empty."
    }
}
# Function to save a credential (public)
function Save-Credentials {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param (
		[Parameter(Position = 0)]
        [string]$Name,
        [Alias("f")]
        [switch]$Force
    )

    if (-Not $Name) {
        $username = Read-Host "Enter your full username (including domain) for $Name"
    } else {
        $username = $Name
    }

    Write-Verbose "Saving credential for: $Name"
    
    if ($credentialsTable.ContainsKey($username) -and -not $Force) {
        $overwrite = Read-Host "Credential for $username already exists. Do you want to overwrite it? (y/N)"
        if ($overwrite -ne 'y') {
            Write-Verbose "Credential for $username not overwritten."
            return
        }
    }

    $password = Read-Host "Enter your password for $Name" -AsSecureString
    $credentialsTable[$username] = $password
    Save-CredentialsTable -username $username
    Write-Verbose "Credential for $username saved successfully."
}


# Function to load the credentials table from the file (private)
function Load-CredentialsTable {
    [CmdletBinding()]
    param ()
    Write-Verbose "Loading credentials table from file: $credentialFilePath"
    if (Test-Path -Path $credentialFilePath) {
        Write-Verbose "Credentials file found. Reading content."
        $encryptedContent = Get-Content -Path $credentialFilePath -Raw
        Write-Verbose "Encrypted content: $encryptedContent"
        if ($encryptedContent) {
            Write-Verbose "Encrypted content read successfully."
            try {
                $secureString = ConvertTo-SecureString -String $encryptedContent -Force
                Write-Verbose "SecureString content: $secureString"
                $jsonContent = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureString))
                if ($jsonContent) {
                    Write-Verbose "Decrypted content converted to JSON successfully."
                    Write-Verbose "Decrypted content: $jsonContent"
                    $credentialsTable = ConvertFrom-Json -InputObject $jsonContent
                    Write-Verbose "Credentials table loaded successfully. $credentialsTable"
                } else {
                    Write-Verbose "Decrypted content is null or empty."
                }
            } catch {
                Write-Error "Failed to decrypt and convert content to JSON: $_"
            }
        } else {
            Write-Verbose "Encrypted content is null or empty."
        }
    } else {
        Write-Verbose "Credentials file not found. Initializing empty credentials table."
        $credentialsTable = @{}
    }
}
# Function to load a credential (private)
function Load-Credentials {
    [CmdletBinding()]
    param (
        [string]$username
    )
    Write-Verbose "Loading credential for user: $username"
    if ($credentialsTable.ContainsKey($username)) {
        $password = $credentialsTable[$username]
        Write-Verbose "Credential for $username loaded successfully."
        return New-Object -TypeName PSCredential -ArgumentList $username, $password
    } else {
        Write-Error "Credential for $username not found."
        return $null
    }
}


# Function to get a credential, prompting the user if it doesn't exist (public)
function Get-Credentials {
    [CmdletBinding()]
    param (
		[Parameter(Position = 0)]
        [string]$username
    )
    Write-Verbose "Getting credential for user: $username"
    if (-Not $credentialsTable.ContainsKey($username)) {
        Write-Verbose "Credential for $username not found. Prompting user to save it."
        Save-Credentials -Name $username
    }
    return Load-Credentials -username $username
}


# Load the credentials table when the module is imported (private)
Write-Verbose "Importing CredentialsHelper module."
Load-CredentialsTable

# Export only the public functions
Export-ModuleMember -Function Save-Credentials, Get-Credentials, Save-CredentialsTable, Save-Credentials, Load-CredentialsTable, Load-Credentials, Save-EncryptedJson, Read-EncryptedJson
Write-Verbose "CredentialsHelper module imported successfully."