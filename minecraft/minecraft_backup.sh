#!/bin/bash
timestamp=$(date +%Y%m%d%H%M) # Define the timestamp variable
mcserver_backup_dir=/tmp/minecraft/mc_${timestamp} # Temporary backup directory on the minecraft server machine
# Save the Minecraft world
rconclt minecraft "save-off"
rconclt minecraft "save-all"

rconclt minecraft "tellraw @a {\"text\":\"<Jesper> Sparar världen...\"}"
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
borg_exit_status=$?
echo "Borg exit status: $borg_exit_status" >> /home/alfvar/minecraft/logs/${timestamp}.log

if [ $borg_exit_status -eq 0 ]; then
    rconclt minecraft "tellraw alfvar_ {\"text\":\"<Jesper> Kopian skickades till backupservrarna!\"}"
else
    rconclt minecraft "tellraw @a {\"text\":\"<Jesper> Lyckades inte säkerhetskopiera. Ring Alfvar!\"}"
fi

# Pruning repository
info "Pruning repository"
borg prune                          \
    --list                          \
    --glob-archives 'mc_*'          \
    --show-rc                       \
    --keep-minutely 24              \
    --keep-daily    7               \
    --keep-weekly   4               \
    --keep-monthly  6

prune_exit=$?

# actually free repo disk space by compacting segments
info "Compacting repository"
borg compact
compact_exit=$?