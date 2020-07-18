#!/bin/bash

#global variables
MENUBOX=${MENUBOX=dialog}
MSGBOX=${MSGBOX=dialog}
SETTINGS_FILE=settings.txt
MEMO_FILE=README.md
METRICS_NAME=empty
METRICS_VAL=empty
MESSAGE="Message"
TITLE="Title"
XCOORD=10
YCOORD=10
OPEARTION_MODE=$1
SSH_RUN=$2
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
  D1_PARM=$(funcReadSettingsFromFile $1 3)
  D2_PARM=$(funcReadSettingsFromFile $1 1)
  funcDisplayMsgBox "$D2_PARM" "$D2_PARM is: `$D1_PARM`" "50" "80" "5"
  sleep 1
  clear
}

function funcDisplayMemo(){
echo Pareamter count is $#
echo first param is $1
A=$#
B=$1
 if [ $A == 0 ]; then
echo "Workstation monitoring;"
echo "Mode of run: human-readable, batch, daemon.Use keys:-b batch -d daemon mode -h human readable"
echo "All settings are stored in file settings.txt, metrix are stored in file metrics.txt"
sleep 2
elif [ $B == -h ] ; then
 # Display menu
funcDisplayMenu
#Display while not quited
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
else
 echo error! Need to be started with parameter!
sleep 2
fi
}


function funcDisplayMenu () {
 $MENUBOX --title " MAIN MENU" --menu "Use Arrows" "50" "80" "15" 1 "Internet Connectivity" 2 "Operating System Name" 3 "Hostname" 4 "Internal IP"  5 "External IP" 6 "Number of Logged In users" 7 "Ram Usage" 8 "Swap Usage" 9 "Disk Usages" 10 "Disk IO" 11 "Load Average" 12 "System Uptime" 13 "Open Port/socket" Q "Quit" 2>choice.txt
}
#Display memo

funcDisplayMemo $OPEARTION_MODE $SSH_RUN

