#!/usr/bin/env bash

#Sanity Check
if [ -z "$GITPOD_TOKEN" ] || [ -z "${GITPOD_TOKEN+x}" ]; then
   echo -e "\n[-] FATAL: Gitpod Token (GITPOD_TOKEN) is not exported (Maybe Empty?)\n"
  exit 1
fi
if ! command -v curl &>/dev/null || ! command -v tmux &>/dev/null || ! command -v gitpod &>/dev/null ; then
   echo -e "\n[-] FATAL: Install curl gitpod & tmux :: https://bin.ajam.dev/$(uname -m)/\n"
fi

#Configure & Setup GitPOD
gitpod config set --verbose --autoupdate="false"
gitpod config set --verbose --telemetry="false"
gitpod config set --verbose --token="$GITPOD_TOKEN"
gitpod login --verbose --token "$GITPOD_TOKEN" && gitpod whoami
gitpod config get

#Stop/Delete (I)
echo -e "\[+] Stopping/Removing Workspaces..."
gitpod workspace list | awk 'NR>1 {print $1}' | xargs -I {} gitpod workspace stop {} --dont-wait --verbose
gitpod workspace list | awk 'NR>1 {print $1}' | xargs -I {} gitpod workspace delete {} --verbose
gitpod workspace list | sed '1d'

#Create/Run
echo -e "\[+] Creating a New WorkSpace..."
gitpod workspace create "https://github.com/Azathothas/Inventory_Ingestor" --verbose
#POD_WORKSPACE_ID="$(gitpod workspace list --running-only | grep -i "azathothas" | grep -i "running" | awk '{print $1}' | head -n 1)" && export POD_WORKSPACE_ID="$POD_WORKSPACE_ID"
POD_WORKSPACE_ID="$(gitpod workspace list --running-only --field id | head -n 1)" && export POD_WORKSPACE_ID="$POD_WORKSPACE_ID"
gitpod workspace ssh "$POD_WORKSPACE_ID" -- -t 'gp url' | grep -i "https"
POD_WORKSPACE_URL="$(gitpod workspace ssh "$POD_WORKSPACE_ID" -- -t 'gp url' | grep -i "https" | awk '{print $1}')" && export POD_WORKSPACE_URL="$POD_WORKSPACE_URL"
echo -e "\n[+] Workspace ID : $POD_WORKSPACE_ID"
echo -e "\n[+] Workspace URL : $POD_WORKSPACE_URL"
echo -e "\n[+] Workspace Tasks : $(gitpod workspace ssh "$POD_WORKSPACE_ID" -- -t 'gp tasks list')"
echo -e "\n[+] Workspace INFO : $(gitpod workspace ssh "$POD_WORKSPACE_ID" -- -t 'gp info')\n"

#Allocate Pseudo TTY
echo -e "\n[+] Allocating Pseduo TTY..."
#Sleep
gitpod workspace ssh "$POD_WORKSPACE_ID" --verbose -- -t 'nohup sleep infinity >/dev/null 2>&1 &'
tmux kill-session -t "gitpod-tty-sleep" 2>/dev/null
nohup tmux new-session -s "gitpod-tty-sleep" -d "timeout -k 1m 360m gitpod workspace ssh '$POD_WORKSPACE_ID' --verbose -- -t 'sleep infinity'" >/dev/null 2>&1 &
#Date
tmux kill-session -t "gitpod-tty-date" 2>/dev/null
nohup tmux new-session -s "gitpod-tty-date" -d "timeout -k 1m 360m gitpod workspace ssh '$POD_WORKSPACE_ID' --verbose -- -t 'watch -n 1 date'" >/dev/null 2>&1 &
# On POD: sudo ps -ef | grep 'tty\|pts'

#Browser
echo -e "\n[+] Open (Browser) :: $POD_WORKSPACE_URL"
echo -e "[+] Open DevTools Console (Ctrl+Shift+I) >> Copy Paste:\n"
echo 'let a=document.querySelectorAll(".monaco-list-row"),b=0;function c(){a.length>0?(a[b].click(),b=(b+1)%a.length):console.log("No terminal tabs found.");let d=Math.floor(1e3*Math.random())+1e3;setTimeout(c,d)}c();'
echo -e "\n[+] You can Minimize Browser OR User another Tab BUT DO NOT CLOSE GITPOD TAB (Closing Developer Console is Okay)"
echo -e "[+] You have 100 Seconds to do this (PureDNS will make ws connection unstable)"
echo -e "[+] Workspaces will be auto Stopped/Deleted after Tasks Finish Executing."
# #Stop/Delete (II)
# echo -e "\n[+] Stopping/Removing Workspaces..."
# gitpod workspace list | awk 'NR>1 {print $1}' | xargs -I {} gitpod workspace stop {} --dont-wait --verbose
# gitpod workspace list | awk 'NR>1 {print $1}' | xargs -I {} gitpod workspace delete {} --verbose
##END
