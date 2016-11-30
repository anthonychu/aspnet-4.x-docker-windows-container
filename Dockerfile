FROM microsoft/iis

# Install Chocolatey
RUN @powershell -NoProfile -ExecutionPolicy Bypass -Command "$env:ChocolateyUseWindowsCompression='false'; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

# Install build tools
RUN powershell add-windowsfeature web-asp-net45 \
    && choco install microsoft-build-tools -y --allow-empty-checksums -version 14.0.23107.10 \
    && choco install dotnet4.6-targetpack --allow-empty-checksums -y \
    && choco install nuget.commandline --allow-empty-checksums -y \
    && nuget install MSBuild.Microsoft.VisualStudio.Web.targets -Version 14.0.0.3 \
    && nuget install WebConfigTransformRunner -Version 1.0.0.1

RUN powershell remove-item C:\inetpub\wwwroot\iisstart.*

# Copy files
RUN md c:\build
WORKDIR c:/build
COPY . c:/build

# Restore packages, build, copy
RUN nuget restore \
    && "c:\Program Files (x86)\MSBuild\14.0\Bin\MSBuild.exe" /p:Platform="Any CPU" /p:VisualStudioVersion=12.0 /p:VSToolsPath=c:\MSBuild.Microsoft.VisualStudio.Web.targets.14.0.0.3\tools\VSToolsPath DockerDemo.sln \
    && xcopy c:\build\DockerDemo\* c:\inetpub\wwwroot /s

ENTRYPOINT powershell .\InitializeContainer
