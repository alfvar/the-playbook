# The Playbook
Turns my lost and found old machines into usable parts of my homelab. Tested with Ubuntu servers.

## How to use
1. Install Ansible on the local machine.
2. Define an `inventory.yml` file (not included) in the project folder . Borgbackup clients will only be set up for hosts where `backup_volume: "name_of_docker_volume"` is specified. Make sure the `backup_volume` variable is exactly the same as the name of the docker volume.
3. Run the playbook with `ansible-playbook playbook-name.yml`

Example `inventory.yml`:

```
myhosts:
  hosts:
    blade:
      ansible_host: example.com
      ansible_user: alfvar
      backup_volume: "minecraft_data"
      tags:
        - minecraft

    raspberrypi:
      ansible_host: east.example.com
      ansible_user: alfvar
      backup_volume: "pocketbase_data"      
      tags:
        - pocketbase
        
    nanode_1:
      ansible_host: 127.0.0.1
      ansible_user: root
```


### Borgclient
Used to back up the Docker volumes to a centralized backup server. Installs `borgbackup` on the remote host, then generates ssh keys locally and copies their private keys to the remote. The ssh keys are labeled after the name of the backup_volume variable defined in `inventory.yml`

### Borgserver
Should run after the appropriate ssh keys exist in the `keys` folder. Installs `borgbackup` on the specified remote host, then copies the contents of the .pub files from the `/keys` directory into `authorized_keys` and also sets up a Borgbackup user for each .pub file. Each client for the Borgserver should then run the the `borg init` command. 

### Pocketbase, Minecraft Server
Copies the relevant file from `compose/filename.yml` file to the target and runs it using Docker Compose.
