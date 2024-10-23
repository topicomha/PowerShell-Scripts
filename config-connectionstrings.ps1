
# Function to get connection strings from a config file
function Get-ConnectionStringsFromConfig {
    param (
        [string]$configFile
    )

    if (Test-Path $configFile) {
        # Load the XML from the config file
        [xml]$configXml = Get-Content $configFile
        
        # Check if the configuration section contains a connectionStrings node
        if ($configXml.configuration.connectionStrings) {
            foreach ($conn in $configXml.configuration.connectionStrings.add) {
                [pscustomobject]@{
                    'FilePath' = $configFile
                    'Name' = $conn.name
                    'ConnectionString' = $conn.connectionString
                    'ProviderName' = $conn.providerName
                }
            }
        }
    }
}

# Function to search for all machine.config and web.config files
function Find-ConfigFiles {
    param (
        [string]$directory
    )

    # Find machine.config and web.config files
    Get-ChildItem -Path $directory -Recurse -Filter "*.config" |
    Where-Object { $_.Name -match '^(machine|web)\.config$' }
}

# Main script
$configFiles = @()

# Add machine.config files from .NET Framework installations
$frameworkRoot = "C:\Windows\Microsoft.NET"
$machineConfigPaths = @(
    "$frameworkRoot\Framework\v2.0.50727\CONFIG\machine.config",
    "$frameworkRoot\Framework\v4.0.30319\CONFIG\machine.config",
    "$frameworkRoot\Framework64\v2.0.50727\CONFIG\machine.config",
    "$frameworkRoot\Framework64\v4.0.30319\CONFIG\machine.config"
)
$configFiles += $machineConfigPaths | Where-Object { Test-Path $_ }

# Add web.config files from the IIS root (or any other custom path)
$iisRoot = "C:\inetpub\wwwroot"
$configFiles += Find-ConfigFiles -directory $iisRoot

# Loop through each config file and extract connection strings
$allConnectionStrings = @()
foreach ($configFile in $configFiles) {
    $allConnectionStrings += Get-ConnectionStringsFromConfig -configFile $configFile
}

# Output all connection strings
$allConnectionStrings 
