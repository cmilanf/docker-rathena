# Docker rAthena, an open-source cross-platform MMORPG server
This repository is a Docker build of [rAthena](https://github.com/rathena/rathena) with the following features:
  * Build features:
    * Uses the small [Alpine Linux](https://hub.docker.com/_/alpine/) as base image.
    * Builds the server from master branch of rAthena's Github repository.
    * Accepts two methods of configuration: by using environment variables or by providing download URL of config file package.
    * Allows to enable or disable packet ofuscation in build time.
  * Runtime features:
    * If not previously existing, the entrypoint creates and prepares the database with the connection parameters provided.
    * Account pre-creation script, prepared to be used with [OpenKore](http://openkore.com) for populating an empty server.
    * Application state stored in MySQL database, so the container can be created and destroyed dinamically.
    * Login-Server, Char-Server and Map-Server are part of the same container. It would be a good practice to build three separated containers for each one, but rAthena only offers limited scalability in Map-Server. Whatever to leave AS IS or build a new repo with each server in different containers is something to be studied in the future.

This Docker image was developed for the call for speakers of the [Global Azure Bootcamp 2018 - Madrid](http://azurebootcamp.es) and you can view the session recording (Spanish only):

[![GAB 2018 - Track 1 - Modo Dios en un MMORPG sobre AKS y la ciudad de los 200 bots](https://img.youtube.com/vi/ZBDJImdmiUo/0.jpg)](https://www.youtube.com/watch?v=ZBDJImdmiUo)

Even if this Docker build was developed for that session, it is focused at [Kubernetes](https://kubernetes.io) and container orchestration in [Azure Kubernetes Service](https://azure.microsoft.com/es-es/services/kubernetes-service/).

## File description

  * **k8s/**. Kubernetes YAML files to deploy the service in on-premises development environment, AKS and Rancher 2.x.
  * **tools/**. Some small Windows batch scripts for automating some operations as ACR permissions for AKS cluster.
  * **accountsandchars.sql**. MySQL script that creates 2 GM accounts and 5000 bot accounts for use with [OpenKore](http://openkore.com). It creates accounts, characters, items and skills.
  * **Dockerfile**. The core of this repo, documented with the LABEL entries.
  * **docker-entrypoint.sh**. The Docker entrypoint that leaves the container in the desired state for execution.
  * **gab_npc.txt**. A sample rAthena script for invoking monsters fought in Global Azure Bootcamp session.

## Requeriments
The only pre-requisites this image has in an existing MySQL database server, with version 5.7 preferred.
The image is based on Alpine Linux and target to run at Linux x64 architectures.

Alpine Linux and rAthena footprints are fairly small and you can run your server with a single machine core and 512 MB RAM memory.

## Environment variables accepted by the image

  * DOWNLOAD_OVERRIDE_CONF_URL. If defined, it will download a ZIP file with the import configuration overrides. If this is the case, no environment variables applies.
  * **MYSQL_HOST**. Hostname of the MySQL database. Ex: calnus-beta.mysql.database.azure.com
  * **MYSQL_DB**. Name of the MySQL database.
  * **MYSQL_USER**. Database username for authentication.
  * **MYSQL_PWD**. Password for authenticating with database.
  * MYSQL_ACCOUNTSANDCHARS. To whatever to execute the accountsandchars.sql so GM and bot accounts get precreated in the database.
  * SET_CHAR_TO_LOGIN_IP. IP that CHAR server uses to connect to LOGIN.
  * SET_MAP_TO_CHAR_IP. IP that MAP server uses to connect to CHAR.
  * **SET_CHAR_PUBLIC_IP**. Public IP of CHAR server.
  * **SET_MAP_PUBLIC_IP**. Public IP of MAP server.
  * **ADD_SUBNET_MAP1**. Subnet mapping in format: net-submask:char_ip:map_ip. Check is check is if((net-submask & char_ip ) == (net-submask & servip)) => ok
  * SET_INTERSRV_USERID. UserID for interserver communication.
  * SET_INTERSRV_PASSWD. Password for interserver communication.
  * SET_SERVER_NAME. DisplayName of the rAthena server.
  * SET_MAX_CONNECT_USER. Maximun number of users allowed to connect concurrently. Default is unlimited.
  * SET_START_ZENNY. Amount of zenny to start with. Default is 0.
  * SET_START_POINT. Point where newly created characters will start AFTER trainning. Format: <map_name>,<x>,<y>{:<map_name>,<x>,<y>...}
  * SET_START_POINT_PRE. Point where newly created character will start. Format: <map_name>,<x>,<y>{:<map_name>,<x>,<y>...}
  * SET_START_POINT_DORAM. Point where a new character from Doram race will start. Format: <map_name>,<x>,<y>{:<map_name>,<x>,<y>...}
  * SET_START_ITMES. Starting items for new characters. For auto-equip, include the position, otherwise 0. Format: <id>,<amount>,<position>{:<id>,<amount>,<position>
  * SET_START_ITEMS_DORAM. Starting items for new character from Doram race.
  * SET_PINCODE_ENABLED. Whatever a PINCODE only inputable by mouse is asked to the player. If we are testing bots this should be disabled.
  * SET_ALLOWED_REGS. How many new characters registration are we going to allow per time unit.
  * SET_TIME_ALLOWED. Amount of time in seconds for allowing characters registration"

## NAT configuration

rAthena is very sensitive to NAT configurations on your network and it is mandatory to place careful attention to the IP definition variables. These are: ADD_SUBNET_MAP1, SET_CHAR_PUBLIC_IP and SET_MAP_PUBLIC_IP.

ADD_SUBNET_MAP1 tells rAthena in which subnet mask is running. This is used to determine whatever an incoming connection is from LAN or WAN realm. It has the form "LAN netmask:char server ip:map server ip". For example, if the char server is at 10.0.0.3/8 and the map server is at 10.0.0.4/8 then this variable must be set at "255.0.0.0:10.0.0.3:10.0.0.4".

SET_CHAR_PUBLIC_IP and SET_MAP_PUBLIC_IP speak by themselves, you just put here their publicly accesible IP addresses.

## Usage
If you have a readily accesible MySQL sever, then usage is straight forward:

```
docker run -d -p 6900:6900 -p 6121:6121 -p 5121:5121 --restart=unless-stopped --name rathena -e MYSQL_HOST="MYSQL host IP" -e MYSQL_USER="MySQL username" -e MYSQL_PWD="MySQL password" -e MYSQL_DB="rAthena" -e ADD_SUBNET_MAP1="255.255.0.0:10.0.0.3:10.0.0.3" -e SET_CHAR_PUBLIC_IP="52.232.25.13" -e SET_MAP_PUBLIC_IP="52.232.25.13" -e MYSQL_ACCOUNTSANDCHARS="1" -e SET_SERVER_NAME="My dockerized rAthena server" cmilanf/docker-rathena:latest
```

## Related projects:

  * [docker-openkore](https://github.com/cmilanf/docker-openkore)
  * [docker-rathena-fluxcp](https://github.com/cmilanf/docker-rathena-fluxcp)

## License
MIT License

Copyright (c) 2018 Carlos Milán Figueredo

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
