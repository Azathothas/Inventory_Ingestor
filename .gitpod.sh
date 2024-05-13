#!/usr/bin/env bash

#Sanity Check
if [ -z "$GITPOD_TOKEN" ] || [ -z "${GITPOD_TOKEN+x}" ]; then
   echo -e "\n[-] FATAL: Gitpod Token (GITPOD_TOKEN) is not exported (Maybe Empty?)\n"
  exit 1
fi
if ! command -v curl &>/dev/null || ! command -v gitpod &>/dev/null || ! command -v jq &>/dev/null || ! command -v ssh &>/dev/null || ! command -v tmux &>/dev/null ; then
   echo -e "\n[-] FATAL: Install curl gitpod jq ssh tmux :: https://bin.ajam.dev/$(uname -m)/\n"
   echo 'sudo apt-get update -y && sudo apt-get install coreutils curl moreutils openssh-client ssh tmux util-linux -y'
   echo 'sudo curl -qfsSL "https://bin.ajam.dev/$(uname -m)/gitpod" -o "/usr/local/bin/gitpod" && sudo chmod +x "/usr/local/bin/gitpod"'
   echo 'sudo curl -qfsSL "https://bin.ajam.dev/$(uname -m)/jq" -o "/usr/local/bin/jq" && sudo chmod +x "/usr/local/bin/jq"'
 exit 1  
fi

#Configure & Setup GitPOD
gitpod login --verbose --token "$GITPOD_TOKEN" && gitpod whoami
gitpod config set --verbose --autoupdate="false"
gitpod config set --verbose --telemetry="false"
gitpod config set --verbose --token="$GITPOD_TOKEN"
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
POD_WORKSPACE_ID="$(timeout -k 10 20 gitpod workspace list --running-only --field id | head -n 1)" && export POD_WORKSPACE_ID="$POD_WORKSPACE_ID"
timeout -k 10 20 gitpod workspace ssh "$POD_WORKSPACE_ID" -- -t 'gp url' | grep -i "https"
POD_WORKSPACE_URL="$(timeout -k 10 20 gitpod workspace ssh "$POD_WORKSPACE_ID" -- -t 'gp url' | grep -i "https" | awk '{print $1}')" && export POD_WORKSPACE_URL="$POD_WORKSPACE_URL"
GITPOD_USERNAME="$(timeout -k 10 20 gitpod workspace ssh "$POD_WORKSPACE_ID" -- -t 'echo $GITPOD_GIT_USER_NAME' | awk '{print $1}')" && export GITPOD_USERNAME="$GITPOD_USERNAME"
GITPOD_USEREMAIL="$(timeout -k 10 20 gitpod workspace ssh "$POD_WORKSPACE_ID" -- -t 'echo $GITPOD_GIT_USER_EMAIL' | grep -i '\@' | awk '{print $1}')" && export GITPOD_USEREMAIL="$GITPOD_USEREMAIL"
echo -e "\n[+] Workspace ID : $POD_WORKSPACE_ID"
echo -e "\n[+] Workspace URL : $POD_WORKSPACE_URL"
echo -e "\n[+] Workspace Tasks : $(timeout -k 10 20 gitpod workspace ssh "$POD_WORKSPACE_ID" -- -t 'gp tasks list')"
echo -e "\n[+] Workspace INFO : $(timeout -k 10 20 gitpod workspace ssh "$POD_WORKSPACE_ID" -- -t 'gp info')\n"

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
echo -e "[+] UserInfo :: $GITPOD_USERNAME $GITPOD_USEREMAIL"
echo -e "[+] Open DevTools Console (Ctrl+Shift+I) >> Copy Paste:\n"
echo 'let panes=document.querySelectorAll(".action-label"),terminalTabs=document.querySelectorAll(".monaco-list-row"),currentIndex=0;function clickPane(){panes.length>0?(panes[currentIndex].click(),currentIndex=(currentIndex+1)%panes.length,scheduleNextClick()):console.log("No panes found.")}function switchTerminal(){if(terminalTabs.length>0){let e=terminalTabs[currentIndex];e?(e.click(),currentIndex=(currentIndex+1)%terminalTabs.length):console.log("No terminal tab found at index:",currentIndex)}else console.log("No terminal tabs found.")}function scheduleNextClick(){let e=Math.floor(12001*Math.random())+5e3;setTimeout((function(){clickPane(),switchTerminal()}),e)}function moveMouseToRandomPosition(){let e=window.innerWidth,n=window.innerHeight,t=Math.floor(Math.random()*e),o=Math.floor(Math.random()*n);window.scrollTo(t,o)}function sendKeyG(){let e=document.activeElement;e.value+="g";let n=new KeyboardEvent("keydown",{key:"Enter",keyCode:13,code:"Enter"});e.dispatchEvent(n);let t=new KeyboardEvent("keydown",{key:"ArrowUp",keyCode:38,code:"ArrowUp"});e.dispatchEvent(t);let o=new KeyboardEvent("keydown",{key:"g",keyCode:71,code:"KeyG"});e.dispatchEvent(o);let l=new KeyboardEvent("keydown",{key:"ArrowDown",keyCode:40,code:"ArrowDown"});e.dispatchEvent(l);let r=new KeyboardEvent("keydown",{key:"0",keyCode:48,code:"Digit0"});e.dispatchEvent(r)}setInterval(moveMouseToRandomPosition,500),setInterval(sendKeyG,2e3),scheduleNextClick();'
echo -e "\n[+] You can Minimize Browser OR User another Tab BUT DO NOT CLOSE GITPOD TAB (Closing Developer Console is Okay)"
echo -e "[+] OPTIONAL : Drag the Terminal Winndow to Max (So btop can work)"
echo -e "[+] You have 100 Seconds to do this (PureDNS will make ws connection unstable)"
echo -e "[+] Workspaces will be auto Stopped/Deleted after Tasks Finish Executing.\n"
# #Stop/Delete (II)
# echo -e "\n[+] Stopping/Removing Workspaces..."
# gitpod workspace list | awk 'NR>1 {print $1}' | xargs -I {} gitpod workspace stop {} --dont-wait --verbose
# gitpod workspace list | awk 'NR>1 {print $1}' | xargs -I {} gitpod workspace delete {} --verbose
##END
