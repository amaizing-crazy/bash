#!/bin/bash

VAL=`cat /proc/meminfo | grep MemFree | awk '{print $2}'`

#VAL1=$(echo $VAL | grep -o -E '[0-9]+')
echo $VAL
#echo $VAL1

if [ $VAL -gt 100000 ]; then
 echo Free memory OK
else
 echo Minimum of 1GB RAM is required
fi

echo Exit code: $?
