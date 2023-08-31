#!/usr/bin/env bash

# For debug
#set -x
#Usage
# Make sure to have a new tmux session running (This preserves accidental closing of panes & Terminals) 
# sudo apt install tmux -y ; tmux new-session -s "puredns"
# bash <(cat $GITPOD_REPO_ROOT/.github/scripts/puredns_setup_gitpod.sh)
# bash <(curl -qfsSL https://raw.githubusercontent.com/Azathothas/Inventory_Ingestor/main/.github/scripts/puredns_setup_gitpod.sh)
#----------------------------------------------------------------------------#
# Install
# Coreutils & Deps 
sudo apt update -y ; sudo apt install curl coreutils dos2unix gcc git jq libpcap-dev wget moreutils python3 -y
sudo apt install curl coreutils dos2unix gcc git jq libpcap-dev wget moreutils python3 -y
#Ansi2txt (For Logs)
pip install ansi2txt
#Apprise (For TG Bot)
pip install apprise
#Archey (For fetch)
pip install archey4
#-------------------------#
#eget (For Binaries)
sudo curl -qfsSL "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/eget" -o "/usr/local/bin/eget" && sudo chmod +xwr "/usr/local/bin/eget"
# 7z (Archive)
sudo rm /usr/bin/7z 2>/dev/null ; sudo rm /usr/local/bin/7z 2>/dev/null
sudo eget "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/7z" --to "/usr/local/bin/7z"
7z -h
#anew (tee -a)
sudo eget "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/anew" --to "/usr/local/bin/anew"
anew -h
#btop (For Observability & Stats)
sudo eget "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/btop" --to "/usr/local/bin/btop"
btop -h
#inscope (For Scope)
sudo eget "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/inscope" --to "/usr/local/bin/inscope"
inscope -h
#massdns (For PureDNS|ShuffleDNS)
sudo eget "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/massdns" --to "/usr/local/bin/massdns"
massdns -h
#resDNS (Main, should auto install other lacking deps)
sudo eget "https://raw.githubusercontent.com/Azathothas/Arsenal/main/resdns/resdns.sh" --to "/usr/local/bin/resdns" ; sudo chmod +xwr "/usr/local/bin/resdns"
resdns -h
#scopeview (For Scope)
sudo eget "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/scopeview" --to "/usr/local/bin/scopeview"
scopeview -h
#shuffledns (Not Really Needed)
sudo eget "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/shuffledns" --to "/usr/local/bin/shuffledns"
shuffledns -h
#yq (For Yaml)
sudo eget "https://raw.githubusercontent.com/Azathothas/Toolpacks/main/x86_64/yq" --to "/usr/local/bin/yq"
yq -h
#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
# Download & Run 
# ENV:VARS are autoset from https://gitpod.io/user/variables
#Download
curl -qfsSL "https://$INVENTORY_REPO_USER:$INVENTORY_REPO_TOKEN@raw.githubusercontent.com/Azathothas/Inventory/main/.github/scripts/puredns_gitpod.sh" -o "./puredns_gitpod.sh"
#Dos2unix + Chmod
dos2unix "./puredns_gitpod.sh" ; sudo chmod +xwr "./puredns_gitpod.sh"
#Run
clear ; bash "./puredns_gitpod.sh"
#EOF
#----------------------------------------------------------------------------#
