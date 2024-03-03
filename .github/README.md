<div align="center">
    <img src="https://pokemmo.com/build/images/opengraph.ce52eb8f.png" width="110", height="110">
</div>
<h1 align="center">PokeMMO-Docker</h1>

[PokeMMO](https://pokemmo.com/en/) directly in your browser.  
Container based on [Docker Baseimage KasmVNC by linuxserver](https://github.com/linuxserver/docker-baseimage-kasmvnc).  

Under no circumstances expose this container to anything but your local machine, unless you really know what you're doing.  
Failure to practice proper security could lead to compromise of account. 

It's against PokeMMO [Code of Conduct](https://pokemmo.com/en/code_of_conduct/)(4d.) to run in any form of virtual machine, but the client seems to be unable to detect it as long as docker is not run in a VM itself. 
This image comes with no guarantee however, and all use is at your own risk.  

Current Required Compatible ROMS: Black/White  
Current Optional Content Compatible ROMS: Fire Red, Emerald, Platinum, HeartGold/SoulSilver  

## Usage

Some snippets to get you started.

### docker-compose

```yaml
services:
  pokemmo-docker:
    image: ghcr.io/lanjelin/pokemmo-docker:latest
    container_name: pokemmo-docker
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Oslo
      - DRINODE=/dev/dri/renderD128 # select GPU
    ports:
      - "3000:3000" #http
      - "3001:3001" #https
    volumes:
      - /path/to/config:/pokemmo/config
      - /path/to/roms:/pokemmo/roms
      - /path/to/mods:/pokemmo/data/mods
    devices:
      - /dev/dri:/dev/dri # enable GPU Accel
    restart: unless-stopped
```

### docker cli

```bash
docker run -d \
  --name=pokemmo-docker \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/Oslo \
  -e DRINODE=/dev/dri/renderD128 \
  -p 3000:3000 \
  -p 3001:3001 \
  -v /path/to/config:/pokemmo/config \
  -v /path/to/roms:/pokemmo/roms \
  -v /path/to/mods:/pokemmo/data/mods \
  --device /dev/dri:/dev/dri \
  --restart unless-stopped \
  ghcr.io/lanjelin/pokemmo-docker:latest
```

### UnRaid
I've inlcuded a template to make it a fast process setting this up in UnRaid.  
Simply run the following to download the template, then navigate to your Docker-tab, click Add Container, and find PokeMMO in the Template-dropdown.

```bash
wget -O /boot/config/plugins/dockerMan/templates-user/my-PokeMMO.xml https://raw.githubusercontent.com/Lanjelin/docker-templates/main/lanjelin/pokemmo.xml
```

## Application Setup

The application can be accessed at:

* http://yourhost:3000/
* https://yourhost:3001/

### Options in all KasmVNC based GUI containers

This container is based on [Docker Baseimage KasmVNC](https://github.com/linuxserver/docker-baseimage-kasmvnc) which means there are additional environment variables and run configurations to enable or disable specific functionality.

#### Optional environment variables

| Variable | Description |
| :----: | --- |
| CUSTOM_PORT | Internal port the container listens on for http if it needs to be swapped from the default 3000. |
| CUSTOM_HTTPS_PORT | Internal port the container listens on for https if it needs to be swapped from the default 3001. |
| CUSTOM_USER | HTTP Basic auth username, abc is default. |
| PASSWORD | HTTP Basic auth password, abc is default. If unset there will be no auth |
| SUBFOLDER | Subfolder for the application if running a subfolder reverse proxy, need both slashes IE `/subfolder/` |
| TITLE | The page title displayed on the web browser, default "KasmVNC Client". |
| FM_HOME | This is the home directory (landing) for the file manager, default "/config". |
| START_DOCKER | If set to false a container with privilege will not automatically start the DinD Docker setup. |
| DRINODE | If mounting in /dev/dri for [DRI3 GPU Acceleration](https://www.kasmweb.com/kasmvnc/docs/master/gpu_acceleration.html) allows you to specify the device to use IE `/dev/dri/renderD128` |

#### Optional run configurations

| Variable | Description |
| :----: | --- |
| `--privileged` | Will start a Docker in Docker (DinD) setup inside the container to use docker in an isolated environment. For increased performance mount the Docker directory inside the container to the host IE `-v /home/user/docker-data:/var/lib/docker`. |
| `-v /var/run/docker.sock:/var/run/docker.sock` | Mount in the host level Docker socket to either interact with it via CLI or use Docker enabled applications. |
| `--device /dev/dri:/dev/dri` | Mount a GPU into the container, this can be used in conjunction with the `DRINODE` environment variable to leverage a host video card for GPU accelerated appplications. Only **Open Source** drivers are supported IE (Intel,AMDGPU,Radeon,ATI,Nouveau) |

### Lossless mode

This container is capable of delivering a true lossless image at a high framerate to your web browser by changing the Stream Quality preset to "Lossless", more information [here](https://www.kasmweb.com/docs/latest/how_to/lossless.html#technical-background). In order to use this mode from a non localhost endpoint the HTTPS port on 3001 needs to be used. If using a reverse proxy to port 3000 specific headers will need to be set as outlined [here](https://github.com/linuxserver/docker-baseimage-kasmvnc#lossless).

