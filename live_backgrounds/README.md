

## Why limit yourself non-moving Zoom backgrounds?
_requires Zoom 4.6.4_

Did you know you can add video backgrounds with Zoom? This quick tutorial will show you how to visit the 1980s on every video call.

![big-boat](big-boat.png)

First, we need some tools.

`brew install youtube-dl` or the equivalent for your OS.

If you want to use the video from the screenshot above:

`youtube-dl -F 'https://www.youtube.com/watch?v=GsN_9a257rM'`

and then choose the appropriate stream, ie `youtube-dl -f 18 'https://www.youtube.com/watch?v=GsN_9a257rM'`

_Zoom requires a minimum resolution of 640x360 for virtual backgrounds_

Next, go to Zoom preferences and add the video you just downloaded.
![zoom-pref](zoom-pref.png)

Proceed to enjoy the 1980s

## More fun with moving backgrounds and Slow TV

[Slow TV](https://en.wikipedia.org/wiki/Slow_television) can make for some fun live backgrounds, but your coworkers will get bored seeing
the same 30 minutes from the beginning of a long video over and over (and the beginning may not have any action).
[I wanted to split a large video](https://twitter.com/fishmanpet/status/1242585079446192129),
and after deciding that doing it by hand would be very time consuming I looked into using ffmpeg and PowerShell,
my scripting language of choice.

I wrote this script that randomly select clips from a larger video and assemble them into a video suitable for use as a Zoom background.

To use `Split-VideoForZoom.ps1` you'll need ffmpeg and PowerShell (will run on Windows PowerShell or PowerShell Core on any platform).

On a Mac:

`brew cask install powershell`

`brew install ffmpeg`

Once those are installed, you can split up a video that you've downloaded with `youtube-dl` as above.

```
cd awesome-zoom-backgrounds/live_backgrounds
youtube-dl -f 134 'https://www.youtube.com/watch?v=3rDjPLvOShM' -o 'train.mp4'
./Split-VideoForZoom.ps1 -VideoPath train.mp4 -OutputPath split.mp4
```

This will, by default, split the video into enough 15 second chunks to make a 10 minute video.
The length of clips and the total length of video can also be specified.

```
./Split-VideoForZoom.ps1 -VideoPath train.mp4 -OutputPath split.mp4 -VideoLength 5 -ClipTime 30
```
This will split the same video into enough 30 second clips to make a 5 minute video (so 10 clips total)
