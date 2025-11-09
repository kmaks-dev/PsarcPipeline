# Description: Initializes required tools by downloading the latest releases from GitHub.

# Import helper functions
. $PSScriptRoot\Helpers\Get-Paths.ps1

# Function to get the latest release from GitHub
function Get-GithubLatestRelease {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $UserName,
        
        [Parameter(Mandatory)]
        [string]
        $Repository
    )
    $Uri = "https://api.github.com/repos/$UserName/$Repository/releases/latest"
    $Response = Invoke-RestMethod -Uri $Uri
    return $Response
}

# Function to update RocksmithToolkit
function Update-RocksmithToolkit {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Path
    )
    
    # Get latest release Uri
    $GithubUser = 'rscustom'
    $GithubRepo = 'rocksmith-custom-song-toolkit'
    Write-Host -Object "📦 Querying GitHub repository: $GithubUser/$GithubRepo"
    $Latest = Get-GithubLatestRelease -UserName $GithubUser -Repository $GithubRepo
    Write-Host -Object "`t• Latest version: $($Latest.tag_name)"
    $LatestWindowsBuildUri = [string] $Latest.assets.browser_download_url.where{ $_ -match 'rstoolkit-.*-win.zip$'}

    # Clear destination path
    if (Test-Path -Path $Path) {
        Write-Host "`t• Clearing existing RocksmithToolkit"
        Remove-Item -LiteralPath $Path -Recurse
    }
    $Destination = New-Item -ItemType 'Directory' -Path $Path
    
    # Download latest release
    $LatestBuildName = $LatestWindowsBuildUri | Split-Path -Leaf
    $OutFile = Join-Path -Path $Destination -ChildPath $LatestBuildName
    $WebRequestConfig = @{
        Uri = [string] $LatestWindowsBuildUri
        OutFile = $OutFile
    }
    Write-Host "`t• Downloading latest Windows build: $LatestBuildName"
    Invoke-WebRequest @WebRequestConfig
    
    # Unpack latest release
    Write-Host -Object "`t• Unpacking to: $Path"
    $ExpandResult = Expand-Archive -LiteralPath $OutFile -DestinationPath $Destination -PassThru

    # Remove unneeded files
    Write-Host "`t• Removing archive: $LatestBuildName"
    Remove-Item -LiteralPath $OutFile
}

# Function to update 7zip
function Update-7zip {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $Path
    )
    
    # Get latest release Uri
    $GithubUser = 'ip7z'
    $GithubRepo = '7zip'
    Write-Host -Object "📦 Querying GitHub repository: $GithubUser/$GithubRepo"
    $Latest = Get-GithubLatestRelease -UserName 'ip7z' -Repository '7zip'
    Write-Host -Object "`t• Latest version: $($Latest.tag_name)"
    $LatestWindowsBuildUri = [string] $Latest.assets.browser_download_url.where{ $_ -match '7zr.exe$'}

    # Clear destination path
    if (Test-Path -Path $Path) {
        Write-Host "`t• Clearing existing 7zip"
        Remove-Item -LiteralPath $Path -Recurse
    }
    $Destination = New-Item -ItemType 'Directory' -Path $Path

    # Download latest release
    $BaseName = $LatestWindowsBuildUri | Split-Path -Leaf
    $OutFile = Join-Path -Path $Destination -ChildPath $BaseName
    
    Write-Host "`t• Downloading latest Windows build: $BaseName"
    Invoke-WebRequest -Uri $LatestWindowsBuildUri -OutFile $OutFile
}

# Update RocksmithToolkit
$RocksmithToolkitPath = Join-Path -Path $FullPaths.Tools -ChildPath 'RocksmithToolkit'
Update-RocksmithToolkit -Path $RocksmithToolkitPath

# Update 7zip
$SevenZipPath = Join-Path -Path $FullPaths.Tools -ChildPath '7zip'
Update-7zip -Path $SevenZipPath
