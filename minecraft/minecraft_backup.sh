#!/bin/bash

timestamp=$(date +%Y%m%d%H%M) # Define the timestamp variable
mcserver_backup_dir=/tmp/minecraft/mc_${timestamp} # Temporary backup directory on the minecraft server machine

# Save the Minecraft world
rconclt minecraft "save-off"
rconclt minecraft "save-all"
rconclt minecraft "tellraw @a {\"text\":\"<Jesper> Sparar världen i mc_${timestamp}\"}"
sleep 1

# Wait until save is disabled
until rconclt minecraft "save-off status" | grep -q "off"; do
    sleep 1
done

rm -rf /tmp/minecraft/* # Remove all old backups
mkdir -p ${mcserver_backup_dir} # Make the directory if it doesn't exist
docker cp minecraft:/papermc ${mcserver_backup_dir} # Copy the world data to the backup directory

rconclt minecraft "save-on" # Turn saving back on

# DYNAMICALLY GENERATED

if [ $? -eq 0 ]; then
    rconclt minecraft "tellraw alfvar_ {\"text\":\"<Jesper> Kopian skickades till backupservrarna.\"}"
else
    rconclt minecraft "tellraw @a {\"text\":\"<Jesper> Lyckades inte säkerhetskopiera. Ring Alfvar!\"}"
fi