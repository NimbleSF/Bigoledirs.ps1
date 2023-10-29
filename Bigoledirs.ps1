# Set the paths to the Program Files and Program Files (x86) directories
$programFilesPath = [Environment]::GetFolderPath("ProgramFiles")
$programFilesX86Path = [Environment]::GetFolderPath("ProgramFilesX86")

# Get a list of all subdirectories in both directories
$programFilesDirs = Get-ChildItem $programFilesPath -Directory
$programFilesX86Dirs = Get-ChildItem $programFilesX86Path -Directory

# Combine and sort all directories by size
$allDirs = $programFilesDirs + $programFilesX86Dirs
$sortedDirs = $allDirs | Sort-Object -Property { $_.GetFiles() | Measure-Object -Property Length -Sum }

# Select the top 20 largest directories
$top20Dirs = $sortedDirs | Select-Object -Last 20

# Output the list of the 20 largest directories with their size and name
$top20Dirs | ForEach-Object {
    [PSCustomObject]@{
        DirectoryName = $_.Name
        DirectorySize = ($_.GetFiles() | Measure-Object -Property Length -Sum).Sum
    }
} | Format-Table -AutoSize
