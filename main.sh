#!/bin/bash

function isXorgRunning {
    if pgrep -f "Xorg :1" > /dev/null; then
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

function startXorg {
    if ! isXorgRunning; then
        echo "Starting Xorg"
        rm -f /tmp/.X1-lock # File should not exist if Xorg is not running
        mkdir -p /app/log
        Xorg :1 -noreset -logfile /app/log/xorg-dummy.log -nolisten unix &
        sleep 5
    else
        echo "Cannot start Xorg. It is already running."
    fi
}

function startSonsServer {
    if ! isSonsServerRunning; then
        echo "Starting the game server"
        cd /app/sonsoftheforest
        exec wine64 SonsOfTheForestDS.exe -userdatapath userdata
    else
        echo "Cannot start the game server. It is already running."
    fi
}

function main {
    echo "Initializing wine"
    rm -rf /app/wine
    wineboot --init
    startXorg
    echo "Rebooting wine"
    wineboot -r
    startSonsServer
}

main
