#!/bin/sh

XDG_RUNTIME_DIR=~/.run dbus-launch seatd-launch sway

sudo pkill -u $USER
