Get-ItemProperty -Path 'HKLM:SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'

Set-ItemProperty -Path "HKLM:SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" -Name "fDisableClip" -Value "0" && 
Set-ItemProperty -Path "HKLM:SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" -Name "fDisableCdm" -Value "0" && 
Set-ItemProperty -Path "HKLM:SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" -Name "MaxMonitors" -Value "4" && 
Set-ItemProperty -Path "HKLM:SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" -Name "MaxXResolution" -Value "33170" && 
Set-ItemProperty -Path "HKLM:SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" -Name "MaxYResolution" -Value "33170" 

Get-ItemProperty -Path 'HKLM:SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'