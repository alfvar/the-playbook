#!/bin/bash

# Save the Minecraft world
rconclt minecraft "/save-off"
rconclt minecraft "/save-all"
rconclt minecraft "say Backup started. Saving the world..."

# Wait for save to complete (adjust sleep time as needed)
sleep 20

# Backup the Minecraft world (replace /path/to/minecraft/world with the actual path)
# borg create <remote_repository>::<archive_name> /path/to/minecraft/world
timestamp=$(date +%Y%m%d%H%M%S)
backup_dir=$HOME/minecraft/backup_${timestamp}

mkdir -p ${backup_dir}

docker cp minecraft:/papermc ${backup_dir}
# Turn saving back on
rconclt minecraft "save-on"

borg create backup@<all hosts part of backup_server group>:minecraft_data::<timestamp> <path_to_file_on_local_system>