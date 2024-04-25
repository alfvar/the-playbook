# Minecraft server based on the Docker image of [phyremaster/papermc](https://hub.docker.com/r/phyremaster/papermc)

### Portforwards required:

* 25565:25565/tcp-udp for Java clients
* 19132:19132/udp for Bedrock clients 

Portforwarding reminder: External hosts allowed should be set to * unless you only want specific ip adresses to connect. Internal host should be the ip adress of the machine running the server. 

If you want to allocate more or less RAM to the server you do so under the variable `MC_RAM=<Size in gigabytes>G` found in `compose/minecraft_server.yml`.

Most other configs are available inside the container when the server has started. These are accessed through `docker exec -it minecraft bash`, in the directory of `papermc` inside the Docker volume's filesystem.
