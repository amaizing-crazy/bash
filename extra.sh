:'
function funcReadSettings (){
PARM=$1
column=3
METRICS_VAL=`cat $SETTINGS_FILE | grep $PARM | awk -F: '{print $var}' var="${column}"`
echo $METRICS_VAL
}


function funcReadOption (){
PARM=$1
METRICS_NAME=`cat $SETTINGS_FILE | grep $PARM | awk -F: '{print $1}'`
echo $METRICS_NAME
}
'


:'
function funcOSName(){
PARM=$(funcReadSettings OS_Name)
sleep 1
echo PARM is $PARM
echo `$PARM`
funcDisplayMsgBox "OS Name" "Operating system name is: $OS" "50" "80" "5"
sleep 1
#clear
}

function displayParm(){
  echo $1
  D1_PARM=$(funcReadSettings $1)
  D2_PARM=$(funcReadOption $1)
  
  echo New var1 $D1_PARM
  echo New var2 $D2_PARM
  sleep 1
  funcDisplayMsgBox "$D2_PARM" "$D2_PARM is: `$D1_PARM`" "50" "80" "5"
  sleep 1
clear
} '


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