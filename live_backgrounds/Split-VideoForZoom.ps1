#!/usr/bin/env pwsh


<#
    .SYNOPSIS
    Splits a longer mp4 video into a few random short clips, for Zoom video backgrounds

    .DESCRIPTION
    Suitable for use with "Slow Television" videos, it will take a long video (in MP4 format), and cut random short clips together to make a single video.
    It can also reverse or horizontally mirror the video. By default the video will be 10 minutes long with 15 second clips, but this can be modified.

    .PARAMETER VideoPath
    Path to the source video

    .PARAMETER OutputPath
    Path and filename to output file

    .PARAMETER VideoLength
    How many minutes long the output video should be. This is used along with ClipTime to determine how many clips to cut

    .PARAMETER ClipTime
    How long each clip should be, in seconds. This is used along with VideoLength to determine how many clips to cut

    .PARAMETER Reverse
    If specified will reverse playback of the video

    .PARAMETER Mirror
    If specified will mirror the video horizontally.
    By default Zoom will mirror how it shows your feed to you, but viewers will see an unmirroed version.
    Normally you shouldn't need this for normal Zoom settings.

    .PARAMETER ffmpegPath
    Optional, path to ffmpeg, defaults to simply ffmpeg, so only needed if ffmpeg is not in your path

    .PARAMETER ffprobePath
    Optional, path to ffprobe, defaults to simply ffprobe, so only needed if ffprobe is not in your path

    .EXAMPLE
    .\Split-VideoForZoom.ps1 -videoPath train.mp4 -outputPath zoom.mp4 -reverse -VideoLength 2 -ClipTime 15
    This will split the file train.mp4 (https://www.youtube.com/watch?v=3rDjPLvOShM downloaded using youtubedl and renamed) into a 2 minute
    long video made up of 15 second clips (8 clips total), in reverse (when it wasn't reversed my coworkers thought it looked weird playing forwards,
    so I reversed it).

    #>
param (
    [Parameter(Mandatory = $true)][String]$VideoPath,
    [Parameter(Mandatory = $true)][String]$OutputPath,
    [Alias("length")][Int]$VideoLength = 10,
    [Alias("time")][Int]$ClipTime = 15,
    [Switch]$Reverse,
    [Switch]$Mirror,
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
    [int]$intervals = ($VideoLength * 60) / $ClipTime

    $dirname = Get-Date -Format FileDateTimeUniversal
    New-Item -Name $dirname -ItemType Directory

    foreach ($i in (1..$intervals)) {
        $randomtotal = Get-Random -Maximum ($seconds - $ClipTime) -Minimum 0
        $filename = Join-Path $dirname "clip$i.mp4"
        Write-Verbose "Starting Clip $i at $randomtotal"
        &$ffmpegPath -hide_banner -ss $randomtotal -i $videoPath -t $ClipTime $filename
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
