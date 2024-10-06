# The Playbook
Manages my `docker-compose.yml` files and gives me backups for the Docker volumes that are important. The labels that are given to the backup repositories are defined in `inventory.yml` under `backup_volume`. The amount of backup servers can be scaled, and the backup repositories are stored per service rather than per user, to make it easier to delegate a task to a new machine and bring its data along with it. Like Kubernetes for snails.

## How to
1. Install Ansible on the local machine.
2. Define an `inventory.yml` file (not included) in the project folder. Borgbackup clients will only be set up for hosts where `backup_volume: "name_of_docker_volume"` is specified (currently moving to instead defining them by the group name of `backup_client`). 
3. Run the playbook with `ansible-playbook playbook-name.yml`

Example `inventory.yml`:

```
myhosts:
  hosts:
    raspberrypi: # This machine has a Docker volume it needs to backup
      ansible_host: east.example.com
      ansible_user: alfvar
      backup_volume: "pocketbase_data" # So Borg knows what things to back up
        
    nanode_1: # This machine is a backup server, see backup_server section further down
      ansible_host: 127.0.0.1
      ansible_user: alfvar # The ssh config won't work with root as the user

    blade: # This machine both has volumes it needs to backup and hosts a backup server
      ansible_host: example.com
      ansible_user: alfvar
      backup_volume: "minecraft_data" # Currently only one backup volume per host is supported

  children:
    backup_server: # You are only safe if your data is in at least three locations
      hosts:
        blade:
        nanode_1:
        raspberrypi:
    backup_client:
      hosts:
        blade: # The same machine can be both client and server!
        raspberrypi:
    minecraft_server: # Multiple servers not supported at the moment
      hosts:
        blade:
```


### 1-install-borgclient.yml
Used to back up the Docker volumes to the backup servers. Installs `borgbackup` on all `backup_client` hosts, then generates ssh keys on the Ansible contorl node and copies their private and public keys to the Borgclient host. The ssh keys are labeled after the name of the backup_volume variable defined in `inventory.yml` so they are easier to keep track of.

### 2-install-borgserver.yml
Should run after the clients have been set up. Installs `borgbackup` on each `backup_server` host, then copies the contents of the .pub files from the `/keys` directory into `authorized_keys` on each server host. A Borgbackup user is then set up for each `backup_volume`. 

### 3-initiate-borgrepo.yml
Should be run after the servers have been set up. Makes sure that all clients know the Borgserver through `known_hosts` and runs `borg init --encryption=none backup@<Name of Borgserver>` on each backup client, allowing them to talk to eachother. For now this doesn't work if the `ansible_user` is root. 

### Creating backups
A manual backup is created via `borg create backup@<ansible_host_that_is_a_borg_server>:<backup_volume>::<label_of_this_backup> <path_to_local_file_to_backup>` on any host that is a `backup_client`. It is restricted to only make backups to the particular subfolder on the server that houses that client's `backup_volume`.

### Restoring backups
Follow the [offical manual](https://borgbackup.readthedocs.io/en/stable/index.html) for Borg. The syntax for this setup would be `borg extract backup@[ip]:/./minecraft_data::mc_2024xxxxxxxx`  For the volumes that do not contain sensitive data, I've chosen to not encrypt the backups, which for now can be edited in `3-initiate-borg-repo.yml`. This is so that I can get access to them should I lose the system they reside on.
