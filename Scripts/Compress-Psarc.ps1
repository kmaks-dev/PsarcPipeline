# Description: Compresses the contents of the Source/Stage1 and Source/Stage2 directories into a PSARC file.

# Import helper functions
. $PSScriptRoot\Helpers\Get-Paths.ps1

Write-Host -Object "📦 Packing PSARC file: $($InputFile.Name)"

# Pack Stage 2
$XBlock = Join-Path -Path $FullPaths.SourceStage1 -ChildPath '*\gamexblocks\guitarcade\*.xblock.7z' -Resolve | Get-Item
$StageTwoFiles = Get-ChildItem -Path $FullPaths.SourceStage2 -Recurse -File
$StageTwoRelativePaths = $StageTwoFiles.FullName -Replace "^.*\\Stage2\\", ''
Push-Location -Path $FullPaths.SourceStage2
& $FullPaths.Tools7Zip 'u' $XBlock.FullName $StageTwoRelativePaths *>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host -Object "`t❌ Failed to pack Stage 2 into XBLOCK"
    return
}
Pop-Location
Write-Host -Object "`t✅ Packing Stage 2 completed successfully"

# Pack Stage 1
$Stage1InputPath = Join-Path -Path $FullPaths.SourceStage1 -ChildPath '*' -Resolve
& $FullPaths.ToolsPacker '--pack' "--input=$Stage1InputPath" "--output=$OutputFile" '--version=RS2014' '--platform=Pc' *>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host -Object "`t❌ Failed to pack Stage 1 into PSARC"
    return
}
Write-Host -Object "`t✅ Packing Stage 1 completed successfully"
