#!/bin/bash --

# Read everything at the top of this script before proceeding

# Information:
# This script installs osu! (the circle-clicking music game) in an isolated 32-bit Wine Prefix on Linux
# The initial package install (sudo passwd) and the "Initializing the Wine Prefix for osu!" (gecko/mono) steps should be the only things requiring user-input
# https://osu.ppy.sh
# https://osu.ppy.sh/forum/t/14614

# How to execute this script:
# Choose one out of the three lines below (the lines starting with wget, bash, and curl) and run it in Terminal
# Use the first line (wget) if at all unsure
# Remove the '# ' (number sign and space) from the beginning of the line

# wget 'https://gitlab.com/Espionage724/Linux/raw/master/Scripts/osu.sh' -O ~/'osu.sh' && chmod +x ~/'osu.sh' && ~/'osu.sh'
# bash <(curl -s https://gitlab.com/Espionage724/Linux/raw/master/Scripts/osu.sh)
# curl -L https://gitlab.com/Espionage724/Linux/raw/master/Scripts/osu.sh | bash

# Other Notes:
# Script was originally for Ubuntu but I have modified it to work for Arch.
# Main package requirements are wine (normal or staging; accessible via PATH) and aria2
# All credit goes to Espionage724 for originally creating this script.

echo ""
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%"
echo "%%%%% This script will install osu! for the user '$USER'"
echo "%%%%%"
echo "%%%%% If your distro is not Arch-based, please review the script"
echo "%%%%%"
echo "%%%%% Please take careful note of the console output"
echo "%%%%%"
echo "%%%%% If you experience any issues with this script, please report them"
echo "%%%%%"
echo "%%%%% Script will begin in 10 seconds"
echo "%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo ""

sleep 10

echo ""
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%"
echo "%%%%% Downloading Wine-Staging and other Prerequisites..."
echo "%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo ""

sleep 2
sudo pacman -S wine-staging winetricks wine-mono wine_gecko lib32-alsa-lib lib32-alsa-plugins lib32-libxml2 lib32-mpg123 lib32-giflib lib32-gnutls aria2 krb5 samba

echo ""
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%"
echo "%%%%% Downloading Winetricks script..."
echo "%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo ""

sleep 2
aria2c 'https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks' -d '/home/'$USER -o 'winetricks' --allow-overwrite=true
chmod +x ~/'winetricks'

echo ""
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%"
echo "%%%%% Downloading Global Assembly Cache Tool..."
echo "%%%%% (this is for .NET Framework 4.0 later on)"
echo "%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo ""

sleep 3
mkdir -p ~/'.cache/winetricks/dotnet40'
aria2c 'https://gitlab.com/Espionage724/Linux/raw/master/Wine/Files/gacutil-net40.tar.bz2' 'https://github.com/Espionage724/Linux-Stuff/raw/master/Wine/Files/gacutil-net40.tar.bz2' -d '/home/'$USER/'.cache/winetricks/dotnet40' -o 'gacutil-net40.tar.bz2' --allow-overwrite=true

echo ""
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%"
echo "%%%%% Initializing the Wine Prefix for osu!..."
echo "%%%%% (confirm download of mono and/or gecko if prompted)"
echo "%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo ""

sleep 3
mkdir -p ~/'Wine Prefixes'
WINEPREFIX=~/'Wine Prefixes/osu!' WINEARCH=win32 wineboot
sync

echo ""
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%"
echo "%%%%% Downloading osu!'s installer..."
echo "%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo ""

sleep 2
aria2c 'https://m1.ppy.sh/r/osu!install.exe' 'https://m2.ppy.sh/r/osu!install.exe' -d '/home/'$USER/'Wine Prefixes/osu!/drive_c/users/'$USER/'Temp' -o 'osu!install.exe' --check-certificate=false --allow-overwrite=true

echo ""
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%"
echo "%%%%% Sandboxing the Wine Prefix..."
echo "%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo ""

sleep 2
WINEPREFIX=~/'Wine Prefixes/osu!' ~/'winetricks' 'sandbox'

echo ""
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%"
echo "%%%%% Improving Cursor Handling for osu!..."
echo "%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo ""

sleep 2
WINEPREFIX=~/'Wine Prefixes/osu!' ~/'winetricks' 'grabfullscreen=y'

echo ""
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%"
echo "%%%%% Downloading and Installing .NET Framework 4.0..."
echo "%%%%% (you will see a lot of harmless text output)"
echo "%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo ""

sleep 3
WINEPREFIX=~/'Wine Prefixes/osu!' ~/'winetricks' --unattended 'dotnet40'

echo ""
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%"
echo "%%%%% Downloading and Installing Asian Font Support..."
echo "%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo ""

sleep 2
WINEPREFIX=~/'Wine Prefixes/osu!' ~/'winetricks' --unattended 'cjkfonts'

echo ""
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%"
echo "%%%%% Creating a menu launcher entry for osu!..."
echo "%%%%% (you may need to reload your desktop environment)"
echo "%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo ""

sleep 3
mkdir -p ~/'.local/share/applications/wine/Programs/osu!'

cat <<EOT >> ~/'.local/share/applications/wine/Programs/osu!/osu!.desktop'
[Desktop Entry]
Name=osu!
Comment=Rhythm is just a *click* away! Actually free, online, with four gameplay modes as well as a built-in editor.
Categories=Game;
Exec=env WINEDEBUG=-all WINEPREFIX='/home/$USER/Wine Prefixes/osu!' wine '/home/$USER/Wine Prefixes/osu!/drive_c/users/$USER/Local Settings/Application Data/osu!/osu!.exe'
Type=Application
StartupNotify=true
Path=/home/$USER/Wine Prefixes/osu!/drive_c/users/$USER/Local Settings/Application Data/osu!
Icon=A7AA_osu!.0
EOT

echo ""
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%"
echo "%%%%% osu! will begin installing in 20 seconds"
echo "%%%%%"
echo "%%%%% Let osu! install without interference for best results"
echo "%%%%% (let it use the default install location)"
echo "%%%%%"
echo "%%%%% It will auto-start when installation is completed"
echo "%%%%%"
echo "%%%%% To launch osu! after installation,"
echo "%%%%% use the newly-created shortcut placed in your app launcher"
echo "%%%%% (you may have to re-log or reload the desktop launcher)"
echo "%%%%%"
echo "%%%%% The launcher icon for osu! will be created after the second start"
echo "%%%%%"
echo "%%%%% To access the osu! folder for Songs and Skins handling,"
echo "%%%%% go to '/home/$USER/Wine Prefixes/osu!/drive_c/users/$USER/Local Settings/Application Data/osu!'"
echo "%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo ""

sync
sleep 20

echo ""
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%"
echo "%%%%% Starting osu!'s Installer..."
echo "%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo ""

WINEPREFIX=~/'Wine Prefixes/osu!' wine ~/'Wine Prefixes/osu!/drive_c/users/'$USER/'Temp/osu!install.exe'

echo ""
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%"
echo "%%%%% Cleaning up files and finalizing..."
echo "%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo ""

# Don't worry if this executes while osu! is installing; Linux locks files that are in-use (osu!installer.exe)

echo "..."
rm ~/'winetricks' ~/'osu!install.exe'
rm -R ~/'.cache/winetricks'
sync
echo "All done! You may use this command to start osu! cd ~/'Wine Prefixes/osu!/drive_c/users/'$USER/'Local Settings/Application Data/osu!' && WINEPREFIX=~/'Wine Prefixes/osu!' wine ~/'Wine Prefixes/osu!/drive_c/users/'$USER/'Local Settings/Application Data/osu!/osu!.exe'"

####################################################################################################
####################################################################################################
#####
##### End
#####
####################################################################################################
####################################################################################################
