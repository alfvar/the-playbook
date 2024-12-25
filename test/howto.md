### What
Creates a local test environment with nodes corresponding to the containers specified in `docker-compose.yml`. 

### How
(Make sure Docker and compose is installed locally)
1. Place the public key for your local machine `id_rsa.pub` in the same dir as the `Dockerfile`. 

2. Run with `ansible-playbook inventory_to_containers.yml -i ../inventory --ask-become-pass`. Make sure to specify the path to your production inventory. 

The script takes an inventory file defined in the root folder and generates a derivative where each hostname is prepended with `test`. The new test_inventory.yml is then used to generate a new `docker-compose.yml` which returns each service in the form of a container. These can then be used with playbooks by delegating them to `-i test-inventory` when run. 