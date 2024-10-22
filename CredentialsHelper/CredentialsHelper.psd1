@{
    # Script module or binary module file associated with this manifest.
    RootModule = 'CredentialsHelper.psm1'

    # Version number of this module.
    ModuleVersion = '1.0.0'

    # Supported PSEditions
    CompatiblePSEditions = @('Desktop', 'Core')

    # ID used to uniquely identify this module
    GUID = '12345678-1234-1234-1234-123456789012'

    # Author of this module
    Author = 'topicomha'

    # Company or vendor of this module
    CompanyName = 'Your Company'

    # Copyright statement for this module
    Copyright = '(c) 2024 topicomha. All rights reserved.'

    # Description of the functionality provided by this module
    Description = 'A module to manage credentials securely.'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.1'

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules = @(EncryptionHelper)

    # Assemblies that must be loaded prior to importing this module
    RequiredAssemblies = @()

    # Functions to export from this module
    FunctionsToExport = @('Save-Credentials', 'Get-Credentials')

    # Cmdlets to export from this module
    CmdletsToExport = @()

    # Variables to export from this module
    VariablesToExport = @()

    # Aliases to export from this module
    AliasesToExport = @()

    # DSC resources to export from this module
    DscResourcesToExport = @()

    # List of all modules packaged with this module
    NestedModules = @()

    # Whether this module requires explicit user acceptance for installation
    PrivateData = @{}

    # HelpInfo URI of this module
    HelpInfoURI = ''

    # Default parameter values for this module
    DefaultCommandPrefix = ''
}