#!/bin/bash

function isXvfbRunning {
    if pgrep -f "Xvfb :1" > /dev/null; then
        true
    else
        false
    fi
}

function isSonsServerRunning {
    if pgrep -f "SonsOfTheForestDS.exe" > /dev/null; then
        true
    else
        false
    fi
}

function startXvfb {
    if ! isXvfbRunning; then
        rm -f /tmp/.X1-lock
        echo "Starting Xvfb"
        Xvfb :1 -screen 0 1024x768x24 -nolisten unix &
        echo "Sleeping for a few seconds"
        sleep 10
        echo "Rebooting wine"
        wineboot -r
    else
        echo "Xvfb :1 is already running"
    fi
}

function startSonsServer {
    if ! isSonsServerRunning; then
        cd /app/sonsoftheforest
        echo "Starting the game server"
        exec wine64 SonsOfTheForestDS.exe -userdatapath userdata
    else
        echo "The game server is already running"
    fi
}

function main {
    rm -rf /app/wine
    echo "Initializing wine"
    wineboot --init
    startXvfb
    startSonsServer
}

main
