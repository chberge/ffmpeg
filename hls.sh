#!/bin/bash

# Input video file
INPUT="input.mp4"

# Output directory
OUTPUT_DIR="hls_output"
mkdir -p $OUTPUT_DIR

# 1920x1080 3Mbps
ffmpeg -i /var/www/work/"$filename" -vf "scale=w=1920:h=1080:force_original_aspect_ratio=decrease" -c:a aac -ar 48000 -c:v h264 -profile:v main -crf 20 -sc_threshold 0 -g 48 -keyint_min 48 -b:v 3000k -maxrate 3000k -bufsize 6000k -hls_time 4 -hls_segment_filename "/var/www/work/hls/1080p_%03d.ts" -hls_playlist_type vod -f hls "/var/www/work/hls/1080p.m3u8"

# 1280x720 2Mbps
ffmpeg -i /var/www/work/"$filename" -vf "scale=w=1280:h=720:force_original_aspect_ratio=decrease" -c:a aac -ar 48000 -c:v h264 -profile:v main -crf 20 -sc_threshold 0 -g 48 -keyint_min 48 -b:v 2000k -maxrate 2000k -bufsize 4000k -hls_time 4 -hls_segment_filename "/var/www/work/hls/720p_%03d.ts" -hls_playlist_type vod -f hls "/var/www/work/hls/720p.m3u8"

# 640x480 1Mbps
ffmpeg -i /var/www/work/"$filename" -vf "scale=w=640:h=480:force_original_aspect_ratio=decrease" -c:a aac -ar 48000 -c:v h264 -profile:v main -crf 20 -sc_threshold 0 -g 48 -keyint_min 48 -b:v 1000k -maxrate 1000k -bufsize 2000k -hls_time 4 -hls_segment_filename "/var/www/work/hls/640p_%03d.ts" -hls_playlist_type vod -f hls "/var/www/work/hls/640p.m3u8"

# Create master playlist
echo "#EXTM3U" > /var/www/work/hls/master.m3u8
echo "#EXT-X-VERSION:3" >> /var/www/work/hls/master.m3u8

echo "#EXT-X-STREAM-INF:BANDWIDTH=3000000,RESOLUTION=1920x1080" >> /var/www/work/hls/master.m3u8
echo "1080p.m3u8" >> /var/www/work/hls/master.m3u8

echo "#EXT-X-STREAM-INF:BANDWIDTH=2000000,RESOLUTION=1280x720" >> /var/www/work/hls/master.m3u8
echo "720p.m3u8" >> /var/www/work/hls/master.m3u8

echo "#EXT-X-STREAM-INF:BANDWIDTH=1000000,RESOLUTION=640x480" >> $OUTPUT_DIR/master.m3u8
echo "480p.m3u8" >> /var/www/work/hls/master.m3u8
