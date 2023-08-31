#!/usr/bin/env bash

# For debug
#set -x

#----------------------------------------------------------------------------#
# Install
# Coreutils & Deps 
sudo apt update -y ; sudo apt install curl coreutils dos2unix gcc git jq libpcap-dev wget moreutils python3 -y
#Ansi2txt (For Logs)
pip install ansi2txt
#Apprise (For TG Bot)
pip install apprise
#Archey (For fetch)
pip install archey4
#-------------------------#
#eget (For Binaries)
sudo curl -qfsSL "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/eget" -o "/usr/local/bin/eget" && sudo chmod +xwr "/usr/local/bin/eget"
# 7z
sudo rm /usr/bin/7z 2>/dev/null ; sudo rm /usr/local/bin/7z 2>/dev/null
sudo eget "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/7z" --to "/usr/local/bin/7z"
#btop (For Observability & Stats)
sudo eget "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/btop" --to "/usr/local/bin/btop"
#massdns (For PureDNS|ShuffleDNS)
sudo eget "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/massdns" --to "/usr/local/bin/massdns"
#resDNS (Main, should auto install other lacking deps)
sudo eget "https://raw.githubusercontent.com/Azathothas/Arsenal/main/resdns/resdns.sh" --to "/usr/local/bin/resdns" ; sudo chmod +xwr "/usr/local/bin/resdns"
#shuffledns
sudo eget "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/shuffledns" --to "/usr/local/bin/shuffledns"
#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
# Download & Run 
# ENV:VARS are autoset from https://gitpod.io/user/variables
{fetch script + dos2unix + Run}
