#!/bin/bash

XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

if [ -d "/opt/system/Tools/PortMaster/" ]; then
  controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
  controlfolder="/opt/tools/PortMaster"
elif [ -d "$XDG_DATA_HOME/PortMaster/" ]; then
  controlfolder="$XDG_DATA_HOME/PortMaster"
else
  controlfolder="/roms/ports/PortMaster"
fi

source $controlfolder/control.txt
[ -f "${controlfolder}/mod_${CFW_NAME}.txt" ] && source "${controlfolder}/mod_${CFW_NAME}.txt"
get_controls

# Variables
GAMEDIR="/$directory/ports/hotlinemiami"

# CD and set logging
cd $GAMEDIR
> "$GAMEDIR/log.txt" && exec > >(tee "$GAMEDIR/log.txt") 2>&1

# Determine architecture and set gmloader binary
if [ "$DEVICE_ARCH" == "aarch64" ]; then
    GMLOADER="gmloadernext.aarch64"
    LIBDIR="lib/arm64-v8a"
    SYSLIB="/usr/lib"
else
    GMLOADER="gmloadernext.armhf"
    LIBDIR="lib/armeabi-v7a"
    SYSLIB="/usr/lib32"
fi

# Setup permissions
$ESUDO chmod +xwr "$GAMEDIR/$GMLOADER"

# Create symlinks for system libraries if they don't exist
if [ ! -f "$GAMEDIR/$LIBDIR/libm.so" ]; then
    $ESUDO ln -sf "$SYSLIB/libm.so" "$GAMEDIR/$LIBDIR/libm.so"
fi
if [ ! -f "$GAMEDIR/$LIBDIR/libc.so" ]; then
    $ESUDO ln -sf "$SYSLIB/libc.so" "$GAMEDIR/$LIBDIR/libc.so"
fi
if [ ! -f "$GAMEDIR/$LIBDIR/libdl.so" ]; then
    $ESUDO ln -sf "$SYSLIB/libdl.so" "$GAMEDIR/$LIBDIR/libdl.so"
fi
if [ ! -f "$GAMEDIR/$LIBDIR/libpthread.so" ]; then
    $ESUDO ln -sf "$SYSLIB/libpthread.so" "$GAMEDIR/$LIBDIR/libpthread.so"
fi
if [ ! -f "$GAMEDIR/$LIBDIR/liblog.so" ] && [ -f "$SYSLIB/liblog.so" ]; then
    $ESUDO ln -sf "$SYSLIB/liblog.so" "$GAMEDIR/$LIBDIR/liblog.so"
fi

# Exports
export LD_LIBRARY_PATH="$GAMEDIR/$LIBDIR:$SYSLIB:$LD_LIBRARY_PATH"
export SDL_GAMECONTROLLERCONFIG="$sdl_controllerconfig"

# Display loading splash
if [ -f "$GAMEDIR/splash.png" ]; then
    $ESUDO chmod +xr "$GAMEDIR/tools/splash" 2>/dev/null
    [ "$CFW_NAME" == "muOS" ] && $ESUDO "$GAMEDIR/tools/splash" "$GAMEDIR/splash.png" 1 2>/dev/null
    $ESUDO "$GAMEDIR/tools/splash" "$GAMEDIR/splash.png" 2000 2>/dev/null &
fi

# Assign gptokeyb and load the game
$GPTOKEYB "$GMLOADER" -c "hotlinemiami.gptk" &
pm_platform_helper "$GAMEDIR/$GMLOADER" >/dev/null
./$GMLOADER -c gmloader.json

# Cleanup
pm_finish
