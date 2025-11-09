# Description: Deploys the built Psarc file to the Rocksmith 2014 Guitarcade folder, backing up any existing file.

# Import helper functions
. $PSScriptRoot\Helpers\Get-Paths.ps1

# Deploy path
$GuitarcadePath = 'C:\Program Files (x86)\Steam\steamapps\common\Rocksmith2014\guitarcade'

# Test for file to deploy
if (-not (Test-Path -Path $OutputFile)) {
    Write-Host -Object "❌ No output file to deploy"
    return
}

# Backup existing file and copy new file
try {
    $TargetItem = Join-Path -Path $GuitarcadePath -ChildPath $InputFile.Name -Resolve | Get-Item
    $Timestamp = [datetime]::Now.ToString('yyyyMMdd_HHmmss')
    $TargetItemBackupName = $TargetItem.BaseName + ".$Timestamp" + $TargetItem.Extension + ".bak"
    Write-Host -Object "🚀 Backing up existing file to $TargetItemBackupName"
    Rename-Item -Path $TargetItem -NewName $TargetItemBackupName -ErrorAction Stop
} catch {
    Write-Host -Object "❌ Failed to back up existing file: $_"
    return
}

# Copy new Psarc file to target location
try {
    $DeployItemPath = Join-Path -Path $GuitarcadePath -ChildPath $InputFile.Name
    Write-Host -Object "🚀 Deploying new Psarc file to $GuitarcadePath"
    Copy-Item -Path $OutputFile -Destination $DeployItemPath -ErrorAction Stop
} catch {
    Write-Host -Object "❌ Failed to deploy new Psarc file: $_"
    return
}
