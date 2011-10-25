#! /bin/bash

# author: Ari Selseng
# version: v1.01, 15. september 2011
# license: GPLv2

. rshot-config

mkdir -p $tmpfolder
ln -s "$foldertobackup" "$tmpfolder"/
ln -s "$foldertobackup2" "$tmpfolder"/	
foldertobackup=$tmpfolder

# getting the date and time.
date=`date "+%Y-%m-%dT%H_%M_%S"`

rsync -azPke "ssh -c $sshencryption -i $sshid -p $sshport" \
  --delete \
  --delete-excluded \
  --exclude 'reallyhugefolder' \
  --link-dest=../latest \
  $foldertobackup/ $remoteuser@$remoteserver:$remoteserverfolder/incomplete_backup-$date \
  && ssh -c $sshencryption -i $sshid -p $sshport $remoteuser@$remoteserver \
  "mv $remoteserverfolder/incomplete_backup-$date $remoteserverfolder/backup-$date \
  && rm -f $remoteserverfolder/latest \
  && ln -s backup-$date $remoteserverfolder/latest"  
  
rm -rf "$foldertobackup"

# Commentary on the rsync command:
#rsync -azP \

# this option makes sure deletes files on client doesn't show up in latest backup.
#  --delete \

# same as above but deletes excluded too.
#  --delete-excluded \ 

# exclude.txt can hold names of the folders and files you want exclude from the backup (line separated). PS: I have left that line out and used  --exclude instead. 
#  --exclude-from=exclude.txt \ 

# Tells rsync on the remote server to use the previous backup and links all the files to the new.
#  --link-dest=../latest \ 

# gives rsync local folder + a temporary remote folder
#  $foldertobackup $remoteuser@$remoteserver:$remoteserverfolder/incomplete_backup-$date \ 

# connects  through ssh
#  && ssh $remoteuser@$remoteserver \ 

# moves the temporary folder to a more final folder name
#  "mv $remoteserverfolder/incomplete_backup-$date $remoteserverfolder/backup-$date \ 

# Removes the previous "latest" (which is just a symlink anyway)
#  && rm -f $remoteserverfolder/latest \ 

# makes the latest backup symlinked to  a new "latest"
#  && ln -s backup-$date $remoteserverfolder/latest" 
