#!/usr/bin/env python3
from __future__ import unicode_literals
import youtube_dl


class MyLogger(object):
    def debug(self, msg):
        pass

    def warning(self, msg):
        pass

    def error(self, msg):
        print(msg)


def my_hook(d):
    if d["status"] == "downloading":
        # print('Downloading ... ')
        print(d["filename"], d["_percent_str"], d["_eta_str"])
    if d["status"] == "finished":
        print("Done downloading, now converting ... ")


ydl_opts = {
    "format": "bestvideo[height=720]/bestvideo[height=1080]/best",
    "outtmpl": "files/%(title)s-%(id)s.%(ext)s",
    "postprocessors": [
        #{
        #    "key": "FFmpegExtractAudio",
        #    "preferredcodec": "mp3",
        #    "preferredquality": "192",
        #},
        {
        'key': 'FFmpegVideoConvertor',
        'preferedformat': 'mp4',  # one of avi, flv, mkv, mp4, ogg, webm
        }
    ],
    "logger": MyLogger(),
    "progress_hooks": [my_hook],
}
nd = ["https://www.youtube.com/" + input("Hash video from youtube: ")]

with youtube_dl.YoutubeDL(ydl_opts) as ydl:
    ydl.download(nd)

print("Done. ")
