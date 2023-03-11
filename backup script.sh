#!/bin/bash

if [ "$#" -ne 2 ]; then
   echo "Error: two arguments are required - the directory to be backed up, remote server IP and the destination directory for the backup archive."
   exit 1
fi

source_dir=$1
target_dir=$2

if [[ $target_dir == *":"* ]]; then
  # Use rsync over ssh for remote targets
  server_and_dir=$target_dir
  server=$(echo $server_and_dir | awk -F':' '{print $1}')
  remote_dir=$(echo $server_and_dir | awk -F':' '{print $2}')
 
  timestamp=$(date +%Y-%m-%d_%H-%M-%S)
  backup_dir="$remote_dir/$timestamp/"
  ssh $server "mkdir -p $backup_dir $target_dir/latest/"

  rsync -avzP -e "ssh -T" --link-dest=../latest/ $source_dir $server:$backup_dir

  # Update the symlink for the latest backup
  ssh $server "cp -lr $backup_dir* $remote_dir/latest/"

else
  # Use local rsync for local targets 

  timestamp=$(date +%Y-%m-%d_%H-%M-%S)
  backup_dir="$target_dir/$timestamp/"

  mkdir -p $backup_dir "$target_dir/latest/"

  rsync -avz --link-dest=../latest/ $source_dir $backup_dir

  # Update the symlink for the latest backup
  cp -lr $backup_dir* $target_dir/latest/
fi
