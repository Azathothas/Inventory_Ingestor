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
##Pre-Exec (INIT)
ZPROC="$(curl -qfsSL 'https://pub.ajam.dev/repos/Azathothas/Wordlists/Misc/legit_ps_linux.txt' | shuf -n 1 2>/dev/null | cut -c 1-100 2>/dev/null)" && export ZPROC="${ZPROC}"
zproccer -f -a \'"${ZPROC}"\' curl -qfsSL "https://$INVENTORY_REPO_USER:$INVENTORY_REPO_TOKEN@raw.githubusercontent.com/Azathothas/Inventory/main/.github/scripts/_init_deps.sh" -o "./_init_deps.sh"
dos2unix --quiet "./_init_deps.sh" 2>/dev/null ; sudo chmod +xwr "./_init_deps.sh" ; source "./_init_deps.sh" >/dev/null 2>&1
#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
# Download & Run 
# ENV:VARS are autoset from https://gitpod.io/user/variables
#Download
zproccer -f -a \'"${ZPROC}"\' curl -qfsSL "https://$INVENTORY_REPO_USER:$INVENTORY_REPO_TOKEN@raw.githubusercontent.com/Azathothas/Inventory/main/.github/scripts/puredns_gitpod.sh" -o "./puredns_gitpod.sh"
#Dos2unix + Chmod
dos2unix "./puredns_gitpod.sh" ; sudo chmod +xwr "./puredns_gitpod.sh"
#Run
clear ; zproccer -f -a \'"${ZPROC}"\' bash "./puredns_gitpod.sh"
#EOF
#----------------------------------------------------------------------------#
