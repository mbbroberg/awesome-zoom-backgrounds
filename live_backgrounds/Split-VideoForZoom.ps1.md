---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Split-VideoForZoom.ps1

## SYNOPSIS
Splits a longer mp4 video into a few random short clips, for Zoom video backgrounds

## SYNTAX

```
Split-VideoForZoom.ps1 [-VideoPath] <String> [-OutputPath] <String> [[-VideoLength] <Int32>]
 [[-ClipTime] <Int32>] [-Reverse] [-Mirror] [[-ffmpegPath] <String>] [[-ffprobePath] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Suitable for use with "Slow Television" videos, it will take a long video (in MP4 format), and cut random short clips together to make a single video.
It can also reverse or horizontally mirror the video.
By default the video will be 10 minutes long with 15 second clips, but this can be modified.

## EXAMPLES

### EXAMPLE 1
```
.\Split-VideoForZoom.ps1 -videoPath train.mp4 -outputPath zoom.mp4 -reverse -VideoLength 2 -ClipTime 15
```

This will split the file train.mp4 (https://www.youtube.com/watch?v=3rDjPLvOShM downloaded using youtubedl and renamed) into a 2 minute
long video made up of 15 second clips (8 clips total), in reverse (when it wasn't reversed my coworkers thought it looked weird playing forwards,
so I reversed it).

## PARAMETERS

### -VideoPath
Path to the source video

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputPath
Path and filename to output file

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -VideoLength
How many minutes long the output video should be.
This is used along with ClipTime to determine how many clips to cut

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: length

Required: False
Position: 3
Default value: 10
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClipTime
How long each clip should be, in seconds.
This is used along with VideoLength to determine how many clips to cut

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: time

Required: False
Position: 4
Default value: 15
Accept pipeline input: False
Accept wildcard characters: False
```

### -Reverse
If specified will reverse playback of the video

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Mirror
If specified will mirror the video horizontally.
By default Zoom will mirror how it shows your feed to you, but viewers will see an unmirroed version.
Normally you shouldn't need this for normal Zoom settings.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ffmpegPath
Optional, path to ffmpeg, defaults to simply ffmpeg, so only needed if ffmpeg is not in your path

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: Ffmpeg
Accept pipeline input: False
Accept wildcard characters: False
```

### -ffprobePath
Optional, path to ffprobe, defaults to simply ffprobe, so only needed if ffprobe is not in your path

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: Ffprobe
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
