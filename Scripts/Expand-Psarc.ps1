# Description: This script unpacks a .psarc file into Stage 1 and Stage 2 directories.

# Import helper functions
. $PSScriptRoot\Helpers\Get-Paths.ps1

Write-Host -Object "📂 Unpacking PSARC file: $($InputFile.Name)"

# Unpack Stage 1
& $FullPaths.ToolsPacker '--unpack' "--input=$($InputFile.FullName)" "--output=$($FullPaths.SourceStage1)" '--version=RS2014' '--platform=Pc' *>$null
# BUG: packer.exe returns exit code 0 even on failure, so we cannot reliably check $LASTEXITCODE here.
if ($LASTEXITCODE -ne 0) {
    Write-Host -Object "`t❌ Failed to unpack Stage 1 from PSARC"
    return
}
Write-Host -Object "`t✅ Unpacking Stage 1 completed successfully"

# Unpack Stage 2
$XBlock = Join-Path -Path $FullPaths.SourceStage1 -ChildPath '*\gamexblocks\guitarcade\*.xblock.7z' -Resolve | Get-Item
& $FullPaths.Tools7Zip 'x' $xblock.FullName "-o$($FullPaths.SourceStage2)" -y *>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host -Object "`t❌ Failed to unpack Stage 2 from XBLOCK"
    return
}
Write-Host -Object "`t✅ Unpacking Stage 2 completed successfully"
