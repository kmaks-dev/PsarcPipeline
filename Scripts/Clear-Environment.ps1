# Description: This script clears the build output and source directories for Stage1 and Stage2.

# Import helper functions
. $PSScriptRoot\Helpers\Get-Paths.ps1

# Define paths to clear
$ClearPaths = @(
    'Output'
    'SourceStage1'
    'SourceStage2'
)

# Clear specified directories
Write-Host -Object "🧹 Clearing build environment"
foreach ($ClearPath in $ClearPaths) {
    # Clear the directory contents
    if (Test-Path -Path $FullPaths[$ClearPath]) {
        Write-Host -Object "`t✅ Clearing contents of: $($RelativePaths[$ClearPath])"
        # Write-Host -Object "🧹 Clearing contents of: $($RelativePaths[$ClearPath])"
        Get-ChildItem -Path $FullPaths[$ClearPath] | Remove-Item -Recurse -Force
    } else {
        Write-Host -Object "`t❌ Path does not exist: $($RelativePaths[$ClearPath])"
        return
    }
}