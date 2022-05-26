
Import-Module "D:\Zapways\Dev\Mobile Apps\Airline App\AnyAirlineApp\AnyAirlineApp\bin\UB-Test\netstandard2.1\AnyAirlineApp.dll"

Add-Type -Path "D:\Zapways\Dev\Mobile Apps\Airline App\AnyAirlineApp\AnyAirlineApp\bin\UB-Test\netstandard2.1\AnyAirlineApp.dll"

Get-ChildItem -recurse "D:\Zapways\Dev\Mobile Apps\Airline App\AnyAirlineApp\AnyAirlineApp\bin\UB-Test\netstandard2.1" |
    Where-Object {($_.Extension -EQ ".dll") -or ($_.Extension -eq ".exe")} | 
    ForEach-Object { $AssemblyName=$_.FullName; Try {[Reflection.Assembly]::LoadFile($AssemblyName)} Catch{ "***ERROR*** Not .NET assembly: " + $AssemblyName}}

[reflection.assembly]::LoadFile("D:\Zapways\Dev\Mobile Apps\Airline App\AnyAirlineApp\AnyAirlineApp\bin\UB-Test\netstandard2.1\AnyAirlineApp.dll") | Get-Member


[reflection.assembly]::LoadFile("D:\Zapways\Dev\Mobile Apps\Airline App\AnyAirlineApp\AnyAirlineApp\bin\UB-Test\netstandard2.1\AnyAirlineApp.dll").GetExportedTypes()

clear