# Android Pixel 3 - Arch Linux (UserLAnd)

## UserLAnd is installed and Arch is loaded

Update Packages

```
sudo pacman -Syu
```

Install wget and libuv

```
sudo pacman -S wget libuv 
```

Make a folder for PowerShell and download the PowerShell 7 preview 3 to it

```
mkdir powershell
cd powershell
```

If your android device has an arm64 CPU download the arm64 package by running the below line
```
wget https://github.com/PowerShell/PowerShell/releases/download/v7.0.0-preview.3/powershell-7.0.0-preview.3-linux-arm64.tar.gz
```

If your android device has an arm32 CPU download the arm32 package by running the below line
```
https://github.com/PowerShell/PowerShell/releases/download/v7.0.0-preview.3/powershell-7.0.0-preview.3-linux-arm32.tar.gz
```
Extract powershell tar.gz 
```
tar xzvf powershell*.tar.gz
```

Run it
```
 ./pwsh
 ```
 