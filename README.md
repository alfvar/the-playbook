# The Playbook
Manages my `docker-compose.yml` files and gives me backups for the Docker volumes that are important. The labels of the important Docker volumes are defined in `inventory.yml` and need to be exactly the same as the volume names given through Docker. The amount of backup servers can be scaled, and the backup repositories are stored per Docker volume rather than per user, to make it easier to delegate a task with it volumes to a new machine if necessary.

## How to
1. Install Ansible on the local machine.
2. Define an `inventory.yml` file (not included) in the project folder. Borgbackup clients will only be set up for hosts where `backup_volume: "name_of_docker_volume"` is specified. Make sure the `backup_volume` variable is *exactly* the same as the name of the docker volume.
3. Run the playbook with `ansible-playbook playbook-name.yml`

Example `inventory.yml`:

```
myhosts:
  hosts:
    raspberrypi: # This machine has a Docker volume it needs to backup
      ansible_host: east.example.com
      ansible_user: alfvar
      backup_volume: "pocketbase_data"     
        
    nanode_1: # This machine is a backup server, see backup_server section further down
      ansible_host: 127.0.0.1
      ansible_user: root

    blade: # This machine both has volumes it needs to backup and hosts a backup server
      ansible_host: example.com
      ansible_user: alfvar
      backup_volume: "minecraft_data" # So Borg knows what things to back up

  children:
  # So Borg knows what machines should be backup servers.
  # Multiple machines allowed and recommended for redundancy
    backup_server:
      hosts:
        blade:
        nanode_1:
```


### 1-install-borgclient.yml
Used to back up the Docker volumes to a centralized backup server. Installs `borgbackup` on the Borgclient host, then generates ssh keys on the local Ansible node and copies their private and public keys to the Borgclient host. The ssh keys are labeled after the name of the backup_volume variable defined in `inventory.yml` so they are easier to keep track of.

### 2-install-borgserver.yml
Should run after the clients have been set up. Installs `borgbackup` on each host included in the `backup_server` group in `inventory.yml`, then copies the contents of the .pub files from the `/keys` directory into `authorized_keys` on each server host. A Borgbackup user is then set up for each `backup_volume`.

### 3-initiate-borgrepo.yml
Should be run after the servers have been set up. Makes sure that all clients know the Borgserver hosts and runs `borg init --encryption=none backup@[Name of Borgserver]` on each Borgclient, allowing them to talk to eachother.

### Creating backups
A manual backup is created via `borg create backup@[ansible_host_that_is_a_borg_server]:[backup_volume]::[label] [path_to_file_on_local_system]` on any host that is a Borg client. It is restricted to only make backups to the particular subfolder on the server that houses that client's `backup_volume`.

### Restoring backups
Follow the [offical manual](https://borgbackup.readthedocs.io/en/stable/index.html) for Borg. For the volumes that do not contain sensitive data, I've chosen to not encrypt the backups, which for now can be edited in `3-initiate-borg-repo.yml`. This is so that I can get access to them should I lose the system they reside on.
