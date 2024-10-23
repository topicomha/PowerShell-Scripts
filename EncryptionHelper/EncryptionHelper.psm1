function Get-DefaultKey {
    [CmdletBinding()]
    param ()

    Write-Verbose "Generating default key based on machine and user information."

    # Get the machine's MAC address
    $macAddress = (Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }).MacAddress -join ''
    Write-Verbose "MAC Address retrieved."

    # Get the user's SID
    $userSid = (Get-WmiObject -Class Win32_UserAccount -Filter "Name='$env:USERNAME'").SID
    Write-Verbose "User SID retrieved."

    # Combine the MAC address and user SID to create a unique key
    $combinedString = $macAddress + $userSid
    Write-Verbose "Combined string generated."

    # Hash the combined string using SHA-256 to produce a 256-bit key
    $sha256 = [System.Security.Cryptography.SHA256]::Create()
    $keyBytes = $sha256.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($combinedString))
    Write-Verbose "Hashed combined string to produce a 256-bit key."

    # Convert the byte array to a SecureString
    $keyString = [Convert]::ToBase64String($keyBytes)
    $secureKey = ConvertTo-SecureString -String $keyString -AsPlainText -Force
    Write-Verbose "Generated SecureString key."

    return $secureKey
}

function Save-EncryptedJson {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$FilePath,

        [Parameter(Mandatory = $true)]
        $Data,

        [Parameter(Mandatory = $false)]
        [SecureString]$Key
    )

    Write-Verbose "Saving encrypted JSON to file: $FilePath"

    # Use the default key if not provided
    if (-not $Key) {
        Write-Verbose "No key provided. Generating default key."
        $Key = Get-DefaultKey
    }

    # Convert the SecureString key to a byte array
    $keyString = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Key))
    $keyBytes = [System.Convert]::FromBase64String($keyString)
    Write-Verbose "Converted SecureString key to byte array."

    # Convert the data to JSON
    $json = $Data | ConvertTo-Json
    Write-Verbose "Converted data to JSON."

    # Convert JSON to bytes
    $jsonBytes = [System.Text.Encoding]::UTF8.GetBytes($json)
    Write-Verbose "Converted JSON to byte array."

    # Encrypt the JSON
    $aes = New-Object System.Security.Cryptography.AesManaged
    $aes.Key = $keyBytes
    $aes.GenerateIV()
    Write-Verbose "Generated AES key and IV."

    $encryptor = $aes.CreateEncryptor()
    $encryptedBytes = $encryptor.TransformFinalBlock($jsonBytes, 0, $jsonBytes.Length)
    Write-Verbose "Encrypted JSON data."

    # Write the encrypted data to file
    $encryptedData = [Convert]::ToBase64String($encryptedBytes)
    $iv = [Convert]::ToBase64String($aes.IV)
    Write-Verbose "Converted encrypted data and IV to Base64 strings."

    # Save the encrypted data and IV in a hashtable and convert it to JSON
    $output = @{
        IV = $iv
        Data = $encryptedData
    }

    # Write the encrypted data and IV to the file
    $output | ConvertTo-Json | Set-Content -Path $FilePath
    Write-Verbose "Saved encrypted data and IV to file."
}

function Read-EncryptedJson {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$FilePath,

        [Parameter(Mandatory = $false)]
        [SecureString]$Key
    )

    Write-Verbose "Reading encrypted JSON from file: $FilePath"

    # Use the default key if not provided
    if (-not $Key) {
        Write-Verbose "No key provided. Generating default key."
        $Key = Get-DefaultKey
    }

    # Read the encrypted JSON from the file
    $encryptedJson = Get-Content -Path $FilePath -Raw | ConvertFrom-Json
    Write-Verbose "Read encrypted JSON from file."

    # Extract IV and encrypted data
    $iv = [Convert]::FromBase64String($encryptedJson.IV)
    $encryptedBytes = [Convert]::FromBase64String($encryptedJson.Data)
    Write-Verbose "Extracted IV and encrypted data from JSON."

    # Convert the SecureString key to a byte array
    $keyString = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Key))
    $keyBytes = [System.Convert]::FromBase64String($keyString)
    Write-Verbose "Converted SecureString key to byte array."

    # Decrypt the JSON
    $aes = New-Object System.Security.Cryptography.AesManaged
    $aes.Key = $keyBytes
    $aes.IV = $iv
    Write-Verbose "Set AES key and IV."

    $decryptor = $aes.CreateDecryptor()
    $decryptedBytes = $decryptor.TransformFinalBlock($encryptedBytes, 0, $encryptedBytes.Length)
    Write-Verbose "Decrypted JSON data."

    # Convert the decrypted bytes back to JSON
    $json = [System.Text.Encoding]::UTF8.GetString($decryptedBytes)
    Write-Verbose "Converted decrypted byte array to JSON string."

    # Convert the JSON back to an object
    $Data = $json | ConvertFrom-Json
    Write-Verbose "Converted JSON string back to object."

    return $Data
}

# Export only the public functions
Export-ModuleMember -Function Save-EncryptedJson, Read-EncryptedJson