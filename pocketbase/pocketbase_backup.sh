p#!/bin/bash
timestamp=$(date +%Y%m%d%H%M) # Define the timestamp variable
shorttime=$(date +%H:%M) # Define the shorttime variable
pbserver_backup_dir=/tmp/pocketbase/pb_${timestamp} # Temporary backup directory on the pocketbase server machine

rm -rf /tmp/pocketbase/* # Remove all old backups
mkdir -p ${pbserver_backup_dir} # Make the directory if it doesn't exist
docker cp pocketbase: ${pbserver_backup_dir} # Copy the world data to the backup directory

#BORGCREATE
