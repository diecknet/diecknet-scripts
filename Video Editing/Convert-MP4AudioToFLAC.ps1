<#
.SYNOPSIS
    Converts audio from MP4 video files to FLAC format using ffmpeg.

.DESCRIPTION
    This script searches for MP4 files in a specified directory and extracts their audio 
    tracks, converting them to FLAC format. The resulting FLAC files are saved in the 
    same directory as the source files with the same base name but with a .flac extension.
    
    The script uses ffmpeg to perform the conversion with the following parameters:
    - Extracts audio only (no video) using -vn
    - Uses FLAC codec for lossless compression
    
    Requires ffmpeg to be installed and available in the system PATH.

.PARAMETER Path
    The directory path to search for MP4 files. Defaults to the current directory (".").

.PARAMETER Filter
    The file filter pattern to use when searching for files. Defaults to "*.mp4".

.EXAMPLE
    .\Convert-MP4AudioToFLAC.ps1
    
    Converts all MP4 files in the current directory to FLAC format.

.EXAMPLE
    .\Convert-MP4AudioToFLAC.ps1 -Path "C:\Videos"
    
    Converts all MP4 files in the C:\Videos directory to FLAC format.

.EXAMPLE
    .\Convert-MP4AudioToFLAC.ps1 -Path "/home/user/videos" -Filter "*.mov"
    
    Converts all MOV files in the specified directory to FLAC format.

.LINK
    https://github.com/diecknet/diecknet-scripts/
#>

param(
    $Path = ".",
    $Filter = "*.mp4" 
    )
$Items = Get-ChildItem -Path $Path -Filter $Filter
foreach($Item in $Items) {
    $TargetPath = (Join-Path -Path $Item.Directory -ChildPath $Item.BaseName) + ".flac"
    & ffmpeg -i $($Item.FullName) -vn -acodec flac $TargetPath
}