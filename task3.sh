#!/bin/bash

#global variables
MENUBOX=${MENUBOX=dialog}
MSGBOX=${MSGBOX=dialog}
SETTINGS_FILE=settings.txt
MEMO_FILE=readme.md
METRICS_NAME=empty
METRICS_VAL=empty
MESSAGE="Message"
TITLE="Title"
XCOORD=10
YCOORD=10

# function definitions

funcDisplayMsgBox () {
 $MSGBOX --title "$1" --msgbox "$2" "$3" "$4"
 sleep 1
}

function funcReadSettingsFromFile (){
PARM=$1
column=$2
VAL=`cat $SETTINGS_FILE | grep $PARM | awk -F: '{print $var}' var="${column}"`
echo $VAL
}


function funcInternetConnectivity(){
APP_ADDRESS=$(funcReadSettingsFromFile $1 3)

result=$(curl --connect-timeout 5 -s -o /dev/null -w "%{http_code}" ${APP_ADDRESS})

# check is APP status code is equal to "301" OK
if [ $result == "301" ]; then
  funcDisplayMsgBox "Internet connectivity" "Internet connectivity is fine. Site $APP_ADDRESS is reachable" "50" "80" "5"
  clear
fi
}

function funcDisplayParm(){
  echo $1
  D1_PARM=$(funcReadSettingsFromFile $1 3)
  D2_PARM=$(funcReadSettingsFromFile $1 1)
  funcDisplayMsgBox "$D2_PARM" "$D2_PARM is: `$D1_PARM`" "50" "80" "5"
  sleep 1
  clear
}


funcDisplayMenu () {
 $MENUBOX --title " MAIN MENU" --menu "Use Arrows" "50" "80" "15" 1 "Internet Connectivity" 2 "Operating System Name" 3 "Hostname" 4 "Internal IP"  5 "External IP" 6 "Number of Logged In users" 7 "Ram Usage" 8 "Swap Usage" 9 "Disk Usages" 10 "Disk IO" 11 "Load Average" 12 "System Uptime" 13 "Open Port/socket" Q "Quit" 2>choice.txt
}

#MAIN
#funcInternetConnectivity

#sleep 1
#funcOSName

#funcDisplayParm OS_Name
#: '
#Memo
#To be done
#funcDisplayMsgBox "$MEMO_FILE" "$D2_PARM is: `$D1_PARM`" "50" "80" "5"
#Read input parameters to be done
#funcInputParms to be done
#Verify preconditions for script to operate
#funcVerifyPackets

# Display menu
while [ "`cat choice.txt`" != "Q" ] && [ "`cat choice.txt`" != "q" ]; do
funcDisplayMenu
case "`cat choice.txt`" in

  1) funcInternetConnectivity ADDRESS;;

  2) funcDisplayParm OS_Name;;

  3) funcDisplayParm hname;;

  4) funcDisplayParm intip;;

  5) funcDisplayParm extip;;

  6) funcDisplayParm usernum;;

  7) funcDisplayParm ram;;

  8) funcDisplayParm swap;;

  9) funcDisplayParm dusage;;

  10) funcDisplayParm dio;;

  11) funcDisplayParm lavg;;

  12) funcDisplayParm suptime;;

  13) funcDisplayParm openport;;

  X) echo "Exit";;

esac
clear
done