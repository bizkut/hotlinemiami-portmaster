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
else
    GMLOADER="gmloadernext.armhf"
fi

# Setup permissions
$ESUDO chmod +xwr "$GAMEDIR/$GMLOADER"

# Exports
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
