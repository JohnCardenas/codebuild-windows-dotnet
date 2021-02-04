# escape=`

FROM mcr.microsoft.com/windows/servercore:ltsc2019
SHELL ["powershell.exe", "-NoLogo", "-ExecutionPolicy Bypass"]

# Install Chocolatey & .NET Framework 3.5 for WiX
RUN [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')); `
    Set-Service -Name wuauserv -StartupType Manual; `
    Install-WindowsFeature -Name NET-Framework-Features -Verbose; `
    Stop-Service wuauserv; `
    Set-Service -Name wuauserv -StartupType Disabled

# Copy packages.config and install via Chocolatey
COPY packages.config C:\Windows\Temp\packages.config
RUN choco.exe install C:\Windows\Temp\packages.config -y

# Set PATH
RUN setx /M PATH $(${Env:PATH} `
    + \";${Env:ProgramData}\chocolatey\bin\" `
    + \";${Env:ProgramFiles(x86)}\WiX Toolset v3.11\bin\" `
    + \";${Env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\TestAgent\Common7\IDE\CommonExtensions\Microsoft\TestWindow\" `
    + \";${Env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\BuildTools\MSBuild\Current\Bin\")
