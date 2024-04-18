#!/usr/bin/env bash

# For debug
#set -x
#Usage
# Make sure to have a new tmux session running (This preserves accidental closing of panes & Terminals) 
# sudo apt install tmux -y ; tmux new-session -s "puredns"
# bash <(cat $GITPOD_REPO_ROOT/.github/scripts/puredns_setup_gitpod.sh)
# bash <(curl -qfsSL https://raw.githubusercontent.com/Azathothas/Inventory_Ingestor/main/.github/scripts/puredns_setup_gitpod.sh)
# TimeOuts in 30 Mins if no Input : https://www.gitpod.io/docs/configure/workspaces/workspace-lifecycle#workspace-timeouts (Only Available In Paid Plans)
#----------------------------------------------------------------------------#
##Install
#Coreutils & Deps 
sudo apt update -y ; sudo apt install curl coreutils dos2unix gcc git jq libpcap-dev wget moreutils python3 -y
sudo apt install curl coreutils dos2unix gcc git jq libpcap-dev wget moreutils python3 -y
sudo apt update -y
sudo apt install bc coreutils curl dos2unix fdupes jq moreutils wget -y
sudo apt-get install apt-transport-https apt-utils ca-certificates coreutils dos2unix gnupg2 jq moreutils p7zip-full rsync software-properties-common texinfo tmux util-linux wget -y 2>/dev/null ; sudo apt-get update -y 2>/dev/null
sudo apt install bc coreutils curl dos2unix fdupes jq moreutils wget -y
sudo apt-get install apt-transport-https apt-utils ca-certificates coreutils dos2unix gnupg2 jq moreutils p7zip-full rsync software-properties-common texinfo tmux util-linux wget -y 2>/dev/null ; sudo apt-get update -y 2>/dev/null
#Python & PIP
sudo apt-get install python3 -y
python --version 2>/dev/null ; python3 --version 2>/dev/null
#Install pip:
#python3 -m ensurepip --upgrade ; pip3 --version
#curl -qfsSL "https://bootstrap.pypa.io/get-pip.py" -o "$SYSTMP/get-pip.py" && python3 "$SYSTMP/get-pip.py"
sudo apt-get install libxslt-dev lm-sensors pciutils procps python3-distro python-dev-is-python3 python3-lxml python3-netifaces python3-pip python3-venv sysfsutils virt-what -y
pip install --break-system-packages --upgrade pip || pip install --upgrade pip
#Ansi2txt (For Logs)
pip install ansi2txt --break-system-packages --force-reinstall --upgrade
#pipx
pip install pipx --upgrade 2>/dev/null
pip install pipx --upgrade --break-system-packages 2>/dev/null
#DVC
pip install "git+https://github.com/iterative/dvc#egg=dvc[all]" --break-system-packages --force-reinstall --upgrade
#Apprise (For TG Bot)
pip install apprise --upgrade 2>/dev/null
pip install apprise --upgrade --break-system-packages 2>/dev/null
pip install "git+https://github.com/rahiel/telegram-send" --break-system-packages --force-reinstall --upgrade
#Archey (For fetch)
pip install archey4 --upgrade 2>/dev/null
pip install archey4 --upgrade --break-system-packages 2>/dev/null
#-------------------------#
#eget (For Binaries)
sudo curl -qfsSL "https://bin.ajam.dev/x86_64_Linux/eget" -o "/usr/local/bin/eget" && sudo chmod +xwr "/usr/local/bin/eget"
# 7z (Archive)
sudo rm /usr/bin/7z 2>/dev/null ; sudo rm /usr/local/bin/7z 2>/dev/null
sudo eget "https://bin.ajam.dev/x86_64_Linux/7z" --to "/usr/local/bin/7z"
7z -h
#anew (tee -a)
sudo eget "https://bin.ajam.dev/x86_64_Linux/anew" --to "/usr/local/bin/anew"
sudo eget "https://bin.ajam.dev/x86_64_Linux/anew-rs" --to "/usr/local/bin/anew-rs"
anew-rs -h
#btop (For Observability & Stats)
sudo eget "https://bin.ajam.dev/x86_64_Linux/btop" --to "/usr/local/bin/btop"
btop -h
#croc
sudo eget "https://bin.ajam.dev/x86_64_Linux/croc" --to "/usr/local/bin/croc"
croc -h
#inscope (For Scope)
sudo eget "https://bin.ajam.dev/x86_64_Linux/inscope" --to "/usr/local/bin/inscope"
inscope -h
#massdns (For PureDNS|ShuffleDNS)
sudo eget "https://bin.ajam.dev/x86_64_Linux/massdns" --to "/usr/local/bin/massdns"
massdns -h
#resDNS (Main, should auto install other lacking deps)
sudo eget "https://raw.githubusercontent.com/Azathothas/Arsenal/main/resdns/resdns.sh" --to "/usr/local/bin/resdns" ; sudo chmod +xwr "/usr/local/bin/resdns"
resdns -h
#scopeview (For Scope)
sudo eget "https://bin.ajam.dev/x86_64_Linux/scopeview" --to "/usr/local/bin/scopeview"
scopeview -h
#shuffledns (Not Really Needed)
sudo eget "https://bin.ajam.dev/x86_64_Linux/shuffledns" --to "/usr/local/bin/shuffledns"
shuffledns -h
#yq (For Yaml)
sudo eget "https://bin.ajam.dev/x86_64_Linux/yq" --to "/usr/local/bin/yq"
yq -h
##
bash <(curl -qfsSL "https://pub.ajam.dev/repos/Azathothas/Arsenal/misc/Linux/Debian/install_bb_tools_x86_64.sh")
echo ; reset ; echo ; clear ; reset ; echo
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
