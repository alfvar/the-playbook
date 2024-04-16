# The Playbook
Turns my lost and found old machines into usable parts of my homelab. Tested with Ubuntu servers.

## How to use
1. Install Ansible on the local machine.
2. Define an `inventory.yml` file. Borgbackup users will only be set up for hosts where `backup_volume: "name_of_docker_volume"` is specified. Make sure the `backup_volume` variable is exactly the same as the name of the docker volume.
3. Run the playbook with `ansible-playbook playbook-name.yml`

### Borgclient
Used to back up the Docker volumes to a central Docker server. Installs `borgbackup` on the remote host, then generates ssh keys locally and copies the private keys to the remote.

### Borgserver
Should be the machine with the beefiest storage. Installs `borgbackup` on the remote host, then copies the .pub files from the `/keys` directory and also sets up a Borgbackup user for each .pub file. Each client for the Borgserver then runs the the `borg init` command. If new hosts with the property `backup_volume`are added, this script should be run again.

### Pocketbase, Minecraft Server
Copies the relevant file from `compose/filename.yml` file to the target and runs it using Docker Compose.
