#!/bin/bash
Xwayland -geometry 1920x1080 -fullscreen :10 &
echo $! > ~/linux-config/scripts/lutris/xwayland-game.pid
sleep 0.5  # Give Xwayland time to start