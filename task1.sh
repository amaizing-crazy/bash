#!/bin/bash

VAL=`cat /proc/meminfo | grep MemFree | awk '{print $2}'`

echo $VAL

if [ $VAL -gt 100000 ]; then
 echo Free memory OK
else
 echo Minimum of 1GB RAM is required
fi

echo Exit code: $?
