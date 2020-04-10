
<#
    .SYNOPSIS
    Splits a longer mp4 video into a few random short clips, for Zoom video backgrounds

    .DESCRIPTION
    Suitable for use with "Slow Television" videos, it will take a long video (in MP4 format), and cut random short clips together to make a single video.
    It can also reverse or horizontally mirror the video.  By default the video will be 10 minutes long with 15 second clips, but this can be modified.

    .PARAMETER videoPath
    Path to the source video

    .PARAMETER outputPath
    Path and filename to output file

    .PARAMETER reverse
    If specified will reverse playback of the video

    .PARAMETER mirror
    If specified will mirror the video horizontally

    .PARAMETER length
    How many minutes long the output video should be. This is used along with time to determine how many clips to cut

    .PARAMETER time
    How long each clip should be. This is used along with length to determine how many clips to cut

    .PARAMETER ffmpegPath
    Optional, path to ffmpeg, defaults to simply ffmpeg, so only needed if ffmpeg is not in your path

    .PARAMETER ffprobePath
    Optional, path to ffprobe, defaults to simply ffprobe, so only needed if ffprobe is not in your path

    .EXAMPLE
    .\Split-VideoForZoom.ps1 -videoPath train.mp4 -outputPath zoom.mp4 -reverse -mirror -length 2 -time 15
    This will split the file train.mp4 (https://www.youtube.com/watch?v=3rDjPLvOShM downloaded using youtubedl and renamed) into a 2 minute
    long video made up of 15 second clips (8 clips total), reverse (when it wasn't reversed my coworkers thought it looked weird playing forwards,
    so I reversed it), and mirrors it horizontally (Zoom can mirror your image but this will mirror any text in the video, so mirroring the video
    means when zoom mirrors it, it will appear as normal)

    #>
param (
    [Parameter(Mandatory = $true)][String]$videoPath,
    [Parameter(Mandatory = $true)][String]$outputPath,
    [Switch]$reverse,
    [Switch]$mirror,
    [Int]$length = 10,
    [Int]$time = 15,
    [String]$ffmpegPath = 'ffmpeg',
    [String]$ffprobePath = 'ffprobe'
)

$ErrorActionPreference = 'Stop'

try {
    $videoPath = Resolve-Path $videoPath
    if (Split-Path -Parent $outputPath) {
        $outputpath = join-path (Resolve-Path (Split-Path -Parent $outputPath)) (Split-Path -Leaf $outputPath)
    }

    $videoInfo = (&$ffprobePath -v quiet -print_format json -show_format $videoPath ) | ConvertFrom-Json
    [int]$seconds = $videoInfo.format[0].duration
    [int]$intervals = ($length * 60) / $time

    $dirname = Get-Date -Format FileDateTimeUniversal
    New-Item -Name $dirname -ItemType Directory

    foreach ($i in (1..$intervals)) {
        $randomtotal = Get-Random -Maximum ($seconds - $time) -Minimum 0
        $filename = Join-Path $dirname "clip$i.mp4"
        Write-Verbose "Starting Clip $i at $randomtotal"
        &$ffmpegPath -hide_banner -ss $randomtotal -i $videoPath -t $time $filename
        "file '$(Resolve-Path $filename)'" | Out-File -Append (Join-Path $dirname mylist.txt) -Encoding ascii
        Write-Verbose "Finished Clip $i at $randomtotal"
    }
    if ($reverse -or $mirror) {
        $vfflags = @()
        if ($reverse) {
            $vfflags += 'reverse'
        }
        if ($mirror) {
            $vfflags += 'hflip'
        }
        $vfflags =  "-vf", ($vfflags -join ',')
    } else {
        $vfflags = "-c", "copy"
    }
    $param = "-hide_banner", "-f", "concat", "-safe", "0", "-i", "$(Join-Path $dirname mylist.txt)" + $vfflags + "$outputpath"
    &$ffmpegPath $param
} finally {
    Remove-Item -Recurse $dirname
}
