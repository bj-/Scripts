D:\ffmpeg\ffmpeg -i rtsp://192.168.1.10:554/user=admin_password=Password_channel=1_stream=0.sdp?real_stream -reset_timestamps 1 -vcodec copy -acodec copy -y  -f segment -segment_time 60   -segment_format mp4 "d:\Xeoma\video\vid-%%05d.mp4"