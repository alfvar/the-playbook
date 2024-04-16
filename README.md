# The Playbook
Turns my lost and found old machines into usable parts of my homelab. Tested with Ubuntu servers.

## How to use
1. Install Ansible on the local machine
2. Define hosts where the scripts should execute (per install script or in a central `inventory.yml` file)
3. Run the playbook with `ansible-playbook playbook-name.yml`

### Borgclient
Used to back up the Docker volumes to a central Docker server. Installs `borgbackup` on the target host, generates a public key and copies it into the local folder `/pubkeys`.

### Borgserver
Should be the machine with the beefiest storage. Copies the keys from the `/pubkeys` directory and also sets up a user per .pub file.

### Pocketbase, Minecraft Server
Copies the relevant file from `compose/filename.yml` file to the target and runs it using Docker Compose.
