rem -an - без звука
ffmpeg.exe -ss 00:00:01.200 -i "%1" -vf "scale=1536:1152:flags=neighbor, crop=1536:1080:0:36" %1.mp4