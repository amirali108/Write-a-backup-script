#!/bin/bash

if [ "$#" -ne 2 ]; then
   echo "Error: two arguments are required - the directory to be backed up, remote server IP and the destination directory for the backup archive."
   exit 1
fi

source_dir=$1
target_dir=$2

if [[    ]]; then
 # Use rsync over ssh for remote targets
  




  

else
  
