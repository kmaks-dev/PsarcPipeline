# Description: This script defines and exports key project paths for use in other scripts.

# Determine the root path of the project
$RootPath = Join-Path -Path $PSScriptRoot -ChildPath "..\.." -Resolve

# Define relative paths
$RelativePaths = @{
    Input        = 'Input'
    Output       = 'Output'
    Scripts      = 'Scripts'
    Source       = 'Source'
    SourceStage1 = 'Source\Stage1'
    SourceStage2 = 'Source\Stage2'
    Tools        = 'Tools'
}

# Create directories if they do not exist
foreach ($Key in $RelativePaths.Keys) {
    $DirPath = Join-Path -Path $RootPath -ChildPath $RelativePaths.$Key
    New-Item -ItemType 'Directory' -Path $DirPath -ErrorAction SilentlyContinue
}

# Define tool paths
$RelativePaths.ToolsPacker  = 'Tools\RocksmithToolkit\RocksmithToolkit\packer.exe'
$RelativePaths.Tools7Zip = 'Tools\7zip\7zr.exe'

# Construct full paths
$FullPaths = @{}
foreach ($Key in $RelativePaths.Keys) {
    $FullPaths.$Key = Join-Path -Path $RootPath -ChildPath $RelativePaths.$Key
}

# Check if exactly one .psarc file exists in the Input directory
$InputFile = Get-ChildItem -Path $FullPaths.Input -Filter '*.psarc'
if ($InputFile.Count -ne 1) {
    throw "Error: Expected exactly one .psarc file in the Input directory, found $($InputFile.Count)."
}

$OutputFile = Join-Path -Path $FullPaths.Output -ChildPath $InputFile.Name