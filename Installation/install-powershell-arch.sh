#!/bin/sh

sudo pacman -Syu

sudo pacman -S wget libuv 
`
mkdir powershell
cd powershell

wget https://github.com/PowerShell/PowerShell/releases/download/v7.0.0-preview.3/powershell-7.0.0-preview.3-linux-arm64.tar.gz

tar xzvf powershell*.tar.gz

 ./pwsh