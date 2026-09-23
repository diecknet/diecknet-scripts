<#
.SYNOPSIS
    Converts audio from MP4 video files to FLAC format using ffmpeg.

.DESCRIPTION
    This script searches for MP4 files in a specified directory and extracts their audio 
    tracks, converting them to FLAC format. The resulting FLAC files are saved in the 
    destination directory with the same filename but with a .flac extension. When the
    -Video switch is specified, the video is copied and the audio is converted to FLAC
    in an .mp4 output file instead.
    
    The script uses ffmpeg to perform the conversion with the following parameters:
    - Extracts audio only (no video) using -vn
    - Uses FLAC codec for lossless compression
    
    Requires ffmpeg to be installed and available in the system PATH.

.PARAMETER Path
    The directory path to search for MP4 files. Defaults to the current directory (".").

.PARAMETER Filter
    The file filter pattern to use when searching for files. Defaults to "*.mp4".

.PARAMETER Video
    Copies the source video while converting its audio track to FLAC. Without this
    switch, the output contains audio only.

.PARAMETER Destination
    The directory where converted files are saved. Defaults to "converted" (in the current directory).
    Note that the destination directory will be created if it does not already exist.

.EXAMPLE
    .\Convert-MP4AudioToFLAC.ps1
    
    Converts all MP4 files in the current directory to FLAC format.

.EXAMPLE
    .\Convert-MP4AudioToFLAC.ps1 -Path "C:\Videos"
    
    Converts all MP4 files in the C:\Videos directory to FLAC format.

.EXAMPLE
    .\Convert-MP4AudioToFLAC.ps1 -Path "/home/user/videos" -Filter "*.mov"
    
    Converts all MOV files in the specified directory to FLAC format and saves the
    results in the converted directory.

.EXAMPLE
    .\Convert-MP4AudioToFLAC.ps1 -Path "C:\Videos" -Destination "C:\Audio"

    Converts all MP4 files in C:\Videos and saves the audio-only FLAC files in
    C:\Audio.

.EXAMPLE
    .\Convert-MP4AudioToFLAC.ps1 -Path "C:\Videos" -Video

    Copies the video from each MP4 file while replacing its audio with FLAC audio,
    saving the resulting MP4 files in the converted directory.

.LINK
    https://github.com/diecknet/diecknet-scripts/
#>

param(
    $Path = ".",
    $Filter = "*.mp4",
    [switch]$Video,
    $Destination = "converted"
    )
$Items = Get-ChildItem -Path $Path -Filter $Filter

if(-not (Test-Path -Path $Destination)) {
    $null = New-Item -ItemType Directory -Path $Destination -ErrorAction Stop
}

foreach($Item in $Items) {
    $TargetFileBaseName = (Join-Path -Path $Destination -ChildPath $Item.BaseName)
    if ($Video) {
        & ffmpeg -i $($Item.FullName) -vcodec copy -acodec flac "$TargetFileBaseName.mp4"
    } else {
        & ffmpeg -i $($Item.FullName) -vn -acodec flac "$TargetFileBaseName.flac"
    }
}