#!/bin/bash

#global variables
MENUBOX=${MENUBOX=dialog}
MSGBOX=${MSGBOX=dialog}
SETTINGS_FILE=settings.txt
MEMO_FILE=README.md
DOCFILE="script_listing"
PACKAGE=package.txt
DIR=dir.txt
METRICS_NAME=empty
METRICS_VAL=empty
MESSAGE="Message"
TITLE="Title"
XCOORD=10
YCOORD=10
OPEARTION_MODE=$1
SSH_RUN=$2
# function definitions

#Message box to display
funcDisplayMsgBox () {
 $MSGBOX --title "$1" --msgbox "$2" "$3" "$4"
 sleep 1
}

#Function to check if required directory existis and suggests to create if not
function funcCheckPrerequirementsDir(){
  DIRECTORY=$1
  echo "Checking Prerequirements:"
if [ -d $DIRECTORY ] 
then
    echo "Directory $DIRECTORY exists." 
else
    echo "Directory $DIRECTORY is required for script to run . Please  press 'y' to create."
    echo "Please press y to create"
    read input
    if [ "$input" == "Y" ] || [ "$input" == "y" ]; then
    echo `sudo mkdir $DIRECTORY`
    echo "Directory $DIRECTORY created with exist status $?"
    sleep 3
    else 
     echo "Error! Script directory $DIRECTORY needs to be created to run the script. Exiting."
    sleep 3
    exit 1
    fi
fi
}

#Function to check if required packages are installed and suggests to install if not
function funcCheckPrerequirementsPackage(){
  PACKAGE=$1
  if yum list installed $PACKAGE >/dev/null 2>&1; then
    echo "Necessary package is installed"
  else
    echo "Package $PACKAGE is required for script to run. Please press 'y' to install"
    read input
    if [ "$input" == "Y" ] || [ "$input" == "y" ]; then
    echo `sudo yum install -y $PACKAGE` > /dev/null
    echo "Package $PACKAGE istalled with exist status $?"
    else
    echo "Error! Package $ PACKAGE needs to be installed to run the script. Exiting."
    exit 1
    fi
  fi
}

#Function to read particular data from Settings file
function funcReadSettingsFromFile (){
PARM=$1
column=$2
VAL=`cat $SETTINGS_FILE | grep $PARM | awk -F: '{print $var}' var="${column}"`
echo $VAL
}

#Function to read data for bath mode
function funcReadSettingsFromFileBatch (){
column=$1
VAL=`cat $SETTINGS_FILE | awk -F: '{print $var}' var="${column}"`
echo $VAL
}

#Funciton to read parameters from file. Used for checking prerequirements
function funcReadFromFIle(){
FUNC=$1
FILE=$2
while IFS= read -u 7 -r LINE; do
  $FUNC $LINE
done 7< $FILE
sleep 3
}

#Funciton to Verify Internet connectivity
function funcInternetConnectivity(){
APP_ADDRESS=$(funcReadSettingsFromFile $1 3)

result=$(curl --connect-timeout 5 -s -o /dev/null -w "%{http_code}" ${APP_ADDRESS})

# check is APP status code is equal to "301" OK
if [ $result == "301" ]; then
  funcDisplayMsgBox "Internet connectivity" "Internet connectivity is fine. Site $APP_ADDRESS is reachable" "50" "80" "5"
  clear
fi
}

#Function to output requested parameters
function funcDisplayParm(){
  D1_PARM=$(funcReadSettingsFromFile $1 3)
  D2_PARM=$(funcReadSettingsFromFile $1 1)
  funcDisplayMsgBox "$D2_PARM" "$D2_PARM is: `$D1_PARM`" "50" "80" "5"
  sleep 1
  clear
}

#Function to display 
function funcDisplayMemo(){
  A=$#
  B=$1
 if [ $A == 0 ]; then
echo "ERROR! Script should be started with parameters."
echo "Mode of run: human-readable, batch, daemon.Use keys:-b batch -d daemon mode -i interactive -h help"
echo "All settings are stored in file settings.txt, metrix are stored in file metrics.txt"
sleep 2
elif [ $B == -i ] ; then
 # Display menu
funcDisplayMenu
#Display while not quited
while [ "`cat choice.txt`" != "Q" ] && [ "`cat choice.txt`" != "q" ]; do
funcDisplayMenu
case "`cat choice.txt`" in

  1) funcDisplayParm ADDRESS;;
    #funcInternetConnectivity ADDRESS;;

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
clear
elif [ $B == -d ] ; then
 #echo "/5 * * * * * $DIRECTORY/task3.sh -d">>/var/spool/cron/vagrant
 #echo "@something" >>/var/log/spool/cron/vagrant
 (crontab -l 2>/dev/null; echo "0 4 * * * $DIRECTORY/task3.sh -d")

#will put code to start as daemon
elif [ $B == -b ]; then
echo "#!/bin/more" > "$DOCFILE"
  funcReadSettingsFromFileBatch 3 > tmpfile1.txt
  echo `cat tmpfile1.txt`
  funcReadSettingsFromFileBatch 1 > tmpfile2.txt
  #ls *.sh > tmplisting.txt

 while IFS= read -r LINE; do
   echo "==================================" >> "$LINE"
   echo "Command: $LINE " >> "$LINE"
   echo "==================================" >> "$LINE"
   echo ""
   echo "`$LINE`" >> "$DOCFILE"
done < tmpfile1.txt

chmod 755 "$DOCFILE"

#rm tmpfile1.txt
#rm tmpfile2.txt
else
 echo error! Need to be started with parameter!
sleep 2
fi
}


function funcDisplayMenu () {
 $MENUBOX --title " MAIN MENU" --menu "Use Arrows" "50" "80" "15" 1 "Internet Connectivity" 2 "Operating System Name" 3 "Hostname" 4 "Internal IP"  5 "External IP" 6 "Number of Logged In users" 7 "Ram Usage" 8 "Swap Usage" 9 "Disk Usages" 10 "Disk IO" 11 "Load Average" 12 "System Uptime" 13 "Open Port/socket" Q "Quit" 2>choice.txt
}
#Display memo
#funcCheckPrerequirementsDir
#funcCheckPrerequirementsPackage
funcReadFromFIle funcCheckPrerequirementsDir $DIR
funcReadFromFIle funcCheckPrerequirementsPackage $PACKAGE

echo "something"
echo $?
sleep 2
funcDisplayMemo $OPEARTION_MODE $SSH_RUN

