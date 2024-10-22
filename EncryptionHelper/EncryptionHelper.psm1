function Save-EncryptedJson {
    param (
        [Parameter(Mandatory = $true)]
        [string]$FilePath,

        [Parameter(Mandatory = $true)]
        $Data,

        [Parameter(Mandatory = $false)]
        [SecureString]$Key
    )

    # Generate a secure key if not provided
    if (-not $Key) {
        $keyBytes = New-Object byte[] 32
        [System.Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($keyBytes)
        $Key = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR((ConvertTo-SecureString -String ([System.Convert]::ToBase64String($keyBytes)) -AsPlainText -Force)))
    } else {
        # Convert the SecureString key to a byte array
        $keyBytes = [System.Text.Encoding]::UTF8.GetBytes([System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Key)))
    }

    # Convert the data to JSON
    $json = $Data | ConvertTo-Json

    # Convert JSON to bytes
    $jsonBytes = [System.Text.Encoding]::UTF8.GetBytes($json)

    # Encrypt the JSON
    $aes = New-Object System.Security.Cryptography.AesManaged
    $aes.Key = $keyBytes
    $aes.GenerateIV()

    $encryptor = $aes.CreateEncryptor()
    $encryptedBytes = $encryptor.TransformFinalBlock($jsonBytes, 0, $jsonBytes.Length)

    # Write the encrypted data to file
    $encryptedData = [Convert]::ToBase64String($encryptedBytes)
    $iv = [Convert]::ToBase64String($aes.IV)

    # Save the encrypted data and IV in a hashtable and convert it to JSON
    $output = @{
        IV = $iv
        Data = $encryptedData
    }

    # Write the encrypted data and IV to the file
    $output | ConvertTo-Json | Set-Content -Path $FilePath
}

function Read-EncryptedJson {
    param (
        [Parameter(Mandatory = $true)]
        [string]$FilePath,

        [Parameter(Mandatory = $false)]
        [SecureString]$Key
    )

    # Read the encrypted JSON from the file
    $encryptedJson = Get-Content -Path $FilePath -Raw | ConvertFrom-Json

    # Extract IV and encrypted data
    $iv = [Convert]::FromBase64String($encryptedJson.IV)
    $encryptedBytes = [Convert]::FromBase64String($encryptedJson.Data)

    # Generate a secure key if not provided
    if (-not $Key) {
        $keyBytes = New-Object byte[] 32
        [System.Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($keyBytes)
        $Key = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR((ConvertTo-SecureString -String ([System.Convert]::ToBase64String($keyBytes)) -AsPlainText -Force)))
    } else {
        # Convert the SecureString key to a byte array
        $keyBytes = [System.Text.Encoding]::UTF8.GetBytes([System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Key)))
    }

    # Decrypt the JSON
    $aes = New-Object System.Security.Cryptography.AesManaged
    $aes.Key = $keyBytes
    $aes.IV = $iv

    $decryptor = $aes.CreateDecryptor()
    $decryptedBytes = $decryptor.TransformFinalBlock($encryptedBytes, 0, $encryptedBytes.Length)

    # Convert the decrypted bytes back to JSON
    $json = [System.Text.Encoding]::UTF8.GetString($decryptedBytes)

    # Convert the JSON back to an object
    $Data = $json | ConvertFrom-Json
    return $Data
}