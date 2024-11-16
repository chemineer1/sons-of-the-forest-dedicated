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
        mkdir -p /app/log
        Xorg :1 -noreset +extension GLX +extension RANDR +extension RENDER -logfile /app/log/xorg-dummy.log -nolisten unix &
        sleep 5
    else
        echo "Xorg is already running"
    fi
}

function startSonsServer {
    if ! isSonsServerRunning; then
        cd /app/sonsoftheforest
        exec wine64 SonsOfTheForestDS.exe -userdatapath userdata
    else
        echo "The game server is already running"
    fi
}

function main {
    echo "Initializing wine"
    rm -rf /app/wine
    wineboot --init
    echo "Starting Xorg"
    startXorg
    echo "Rebooting wine"
    wineboot -r
    echo "Starting the game server"
    startSonsServer
}

main
