#!/bin/bash
set -e

function isSonsServerRunning {
    if pgrep -f "SonsOfTheForestDS.exe" > /dev/null; then
        true
    else
        false
    fi
}

function isWineInitialized {
    if [ ! -d $WINEPREFIX ] || [ -z "$(ls -A $WINEPREFIX)" ]; then
        false
    else
        true
    fi
}

function startSonsServer {
    if ! isSonsServerRunning; then
        echo "Starting the game server"
        cd /app/sonsoftheforest
        echo "The user is $USER"
        exec wine64 SonsOfTheForestDS.exe -userdatapath userdata -batchmode -nographics
    else
        echo "Cannot start the game server. It is already running."
    fi
}

function initializeWine {
    if ! isWineInitialized; then
        echo "Initializing wine at $WINEPREFIX"
        wine64 wineboot --init
    else
        echo "Wine is initialized at $WINEPREFIX"
    fi
}

function main {
    initializeWine
    echo "Rebooting wine"
    wine64 wineboot -r
    /app/steamcmd/steamcmd.sh +@sSteamCmdForcePlatformType windows +force_install_dir /app/sonsoftheforest +login anonymous +app_update 2465200 validate +quit
    startSonsServer
}

main
