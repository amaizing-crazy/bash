#!/bin/bash

#Variables
backupname=backup-`date +%d.%m.`zip
BACKUP_DIR=/opt/lab-backup/
JENKINS_DIR=/var/lib/jenkins/
#
echo "Total arguments : $#"
ARG=$#
if [ $ARG != 0 ];then
  echo "Backup started on `date +%d.%m`"
  cd $BACKUP_DIR
  echo "List of files before backup:`ls`"

  #find specifc files and add to backup archive
  echo `find $JENKINS_DIR -name "*.MD" -o -name "*.html" -exec zip -r $backupname {} +`

  #remove backups older then input value
  echo `find $BACKUP_DIR -name "*.zip" -type f -mtime +$1 -exec rm -f {} \;`

  echo "List of files after backup:`ls`"
else
  echo "Error!!! Argument describing number of backups taken needs to be added!"
fi
