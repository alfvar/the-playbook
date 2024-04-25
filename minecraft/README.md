# To set up the minecraft server according to my specifications.

### Portforwards required:

* 25565:25565 for Java clients
* 19132:19132/udp for Bedrock clients 

Portforwarding reminder: External hosts allowed should be set to * unless you only want specific ip adresses to connect. Internal host should be the ip adress of the machine running the server. 

If you want to allocate more or less RAM to the server you do so under the variable `MC_RAM=<Size in gigabytes>G` found in `compose/minecraft_server.yml`.
