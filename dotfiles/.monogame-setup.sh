#!/bin/bash
# MonoGame Wine setup with gum dynamic spinner

gum style --bold --foreground 212 "No MonoGame environment detected. ⚠️"

if ! gum confirm "Do you want to download and install MonoGame Wine tools now?"; then
    gum style --foreground 196 "Okay, nothing was changed. Exiting."
    exit 0
fi

WINEEXECUTABLE="wine64"
TEMP_DIR="${TMPDIR:-/tmp}"
SCRIPT_DIR="$TEMP_DIR/winemg2"
mkdir -p "$SCRIPT_DIR"

spinner() {
    local message=$1
    gum spin --spinner line --title "$message" -- sleep 0.1
}

gum spin --spinner line --title "🚧 Initializing Wine environment... 🚧" -- bash -c "
    export WINEARCH=win64
    export WINEPREFIX=$HOME/.winemonogame
    $WINEEXECUTABLE wineboot >/dev/null
"
gum style --foreground 10 "Wine initialized successfully."

gum spin --spinner line --title "Disabling Wine crash dialog..." -- bash -c "
    cat > $SCRIPT_DIR/crashdialog.reg <<_EOF_
REGEDIT4
[HKEY_CURRENT_USER\\\\Software\\\\Wine\\\\WineDbg]
\"ShowCrashDialog\"=dword:00000000
_EOF_
    pushd $SCRIPT_DIR >/dev/null
    $WINEEXECUTABLE regedit crashdialog.reg >/dev/null
    popd >/dev/null
"
gum style --foreground 10 "Crash dialog disabled."

# Determine highest enabled .NET
if [ "$NIX_ENABLE_DOTNET_10" = "1" ]; then
    DOTNET_URL="https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.101/dotnet-sdk-10.0.101-win-x64.zip"
elif [ "$NIX_ENABLE_DOTNET_9" = "1" ]; then
    DOTNET_URL="https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.308/dotnet-sdk-9.0.308-win-x64.zip"
elif [ "$NIX_ENABLE_DOTNET_8" = "1" ]; then
    DOTNET_URL="https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.416/dotnet-sdk-8.0.416-win-x64.zip"
elif [ "$NIX_ENABLE_DOTNET_7" = "1" ]; then
    DOTNET_URL="https://builds.dotnet.microsoft.com/dotnet/Sdk/7.0.410/dotnet-sdk-7.0.410-win-x64.zip"
else
    gum style --foreground 196 "No .NET version enabled." >&2
    exit 1
fi

gum spin --spinner line --title "Downloading .NET SDK..." -- curl -L "$DOTNET_URL" --output "$SCRIPT_DIR/dotnet-sdk.zip"
gum spin --spinner line --title "Extracting .NET SDK..." -- 7z x "$SCRIPT_DIR/dotnet-sdk.zip" -o"$WINEPREFIX/drive_c/windows/system32/" -y
gum style --foreground 10 ".NET SDK installed successfully."

gum spin --spinner line --title "Downloading Firefox for d3dcompiler_47.dll..." -- curl -L "https://download-installer.cdn.mozilla.net/pub/firefox/releases/62.0.3/win64/ach/Firefox%20Setup%2062.0.3.exe" --output "$SCRIPT_DIR/firefox.exe"
gum spin --spinner line --title "Extracting d3dcompiler_47.dll..." -- 7z e "$SCRIPT_DIR/firefox.exe" "core/d3dcompiler_47.dll" -o"$WINEPREFIX/drive_c/windows/system32/" -aoa
gum style --foreground 10 "d3dcompiler_47.dll installed successfully."

gum spin --spinner line --title "Downloading FXCCS..." -- curl -L "https://monogame.net/downloads/fxccs.zip" --output "$WINEPREFIX/drive_c/fxccs.zip"
gum spin --spinner line --title "Extracting FXCCS..." -- 7z x "$WINEPREFIX/drive_c/fxccs.zip" -o"$WINEPREFIX/drive_c/" -y
gum style --foreground 10 "FXCCS installed successfully."

gum style --foreground 14 --bold "MonoGame Wine setup complete! 🚀"
