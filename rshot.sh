#! /bin/bash

# author: Ari Selseng
# version: v1, 15. september 2011
# license: gplv2


# The folder to backup locally
foldertobackup=/home/$USER

# the user to use with ssh
remoteuser=

# address to remoteserver (can be host name, dns name or ip)
backupserver=

# The folder where the backups will be placed.
backupserverfolder=""

# getting the date and time.
date=`date "+%Y-%m-%dT%H_%M_%S"`

rsync -azP \
  --delete \
  --delete-excluded \
  --exclude 'reallyhugefolder' \
  --link-dest=../current \
  $foldertobackup $remoteuser@$backupserver:$backupserverfolder/incomplete_backup-$date \
  && ssh $remoteuser@$backupserver \
  "mv $backupserverfolder/incomplete_backup-$date $backupserverfolder/backup-$date \
  && rm -f $backupserverfolder/current \
  && ln -s backup-$date $backupserverfolder/current"
  
  

# Commentary on the rsync command:
#rsync -azP \

# this option makes sure deletes files on client doesn't show up in current backup.
#  --delete \

# same as above but deletes excluded too.
#  --delete-excluded \ 

# exclude.txt can hold names of the folders and files you want exclude from the backup (line separated). PS: I have left that line out and used  --exclude instead. 
#  --exclude-from=exclude.txt \ 

# Tells rsync on the remote server to use the previous backup and links all the files to the new.
#  --link-dest=../current \ 

# gives rsync local folder + a temporary remote folder
#  $foldertobackup $remoteuser@$backupserver:$backupserverfolder/incomplete_backup-$date \ 

# connects  through ssh
#  && ssh $remoteuser@$backupserver \ 

# moves the temporary folder to a more final folder name
#  "mv $backupserverfolder/incomplete_backup-$date $backupserverfolder/backup-$date \ 

# Removes the previous "current" (which is just a symlink anyway)
#  && rm -f $backupserverfolder/current \ 

# makes the latest backup symlinked to  a new "current"
#  && ln -s backup-$date $backupserverfolder/current" 
