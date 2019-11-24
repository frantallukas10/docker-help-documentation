# DOCKER BASICS

### COMMANDS:
- docker or docker --help - show options and management commands
- docker search [IMAGE_NAME] - we search the Docker container images in registry server from the terminal
- docker --version - show docker version info
- docker ps - show list with the actual running container and more info
- docker ps -a - show list with all container and more info
- docker info - view even more details about your Docker installation
- docker inspect '{{.Config}} - [CONTAINER_NAME or CONTAINER ID]` - show config Image for container
- docker inspect "{{.NetworkSettings}}" [CONTAINER_NAME_or_CONTAINER_ID] - show network settings for the container
- docker inspect -f '{{.Config.Image}}' [CONTAINER_NAME_or_CONTAINER_ID] - show name Image for container
- docker inspect -f '{{.RepoTags}}' [IMAGE_NAME] - show version image

## ABOUT IMAGES
Images are app binaries and dependencies with metadata about the image data and how to run the image<br>
Images are no complete OS. No kernel, kernel modules (drivers)<br>
The host provides the kernel, big difference between VM<br>

### COMMANDS:
- docker images --help - show help for manage images
- docker image ls or docker images - show list the images we have pulled
- docker image ls -a or docker images -a - show list all images we have pulled and with removed images
- docker pull [IMAGE_NAME] - we can also just pull down images
- docker image rm [IMAGE_NAME] or docker rmi [IMAGE_NAME] - remove image
- docker rmi $(docker images -aq) - remove all images

## ABOUT CONTAINERS
Docker containers are often compared to virtual machines but they are actually just processes running on your host os. In Windows/Mac,
Docker runs in a mini-VM so to see the processes you'll need to connect directly to that. On Linux however, you can run "ps aux" and see the processes directly

## HOW RUN DOCKER CONTAINER WORKS?
First looked for an image called nginx in the image cache<br>
If not found in the cache, it looks to the default image repo on Dockerhub<br>
Pulled it down (latest version), stored in the image cache<br>
Started it in a new container<br>
We specified to take port 80- on the host and forward to port 80 on the container<br>
We could do - docker container run --publish 8000:80 --detach nginx to use port 8000<br>
We can specify versions like -  docker container run --publish 8000:80 --detach nginx:1.09<br>

### COMMANDS:
- docker container --help - show help for manage containers
- docker container stats [CONTAINER_NAME_or_CONTAINER_ID] - performance statistics (cpu, mem, network, disk, etc)
- docker container ls or docker ps - show list all running containers
- docker container ls -a - show list all containers, even those not running
- docker container run [IMAGE_NAME] - run container with pulled image
- docker container run [IMAGE_NAME]:[IMAGE_VERSION] - run container with pulled image
- docker container stop [CONTAINER_NAME_or_CONTAINER_ID] - gracefully stop the specified container
- docker container kill [CONTAINER_NAME_or_CONTAINER_ID] - force shutdown of the specified container
- docker container start [CONTAINER_NAME_or_CONTAINER_ID] - start the specified container
- docker container rm [CONTAINER_NAME_or_CONTAINER_ID] - remove specified container (Can not remove running containers, must stop first)
- docker container rm -f [CONTAINER_NAME_or_CONTAINER_ID] - to remove a running container use force (-f)
- docker container rm [CONTAINER_NAME_or_CONTAINER_ID] [CONTAINER_NAME_or_CONTAINER_ID] [CONTAINER_NAME_or_CONTAINER_ID] - remove multiple containers (Can not remove running containers, must stop first)
- docker rm $(docker ps -aq) - remove all containers (Can not remove running containers, must stop first)
- docker rm -f $(docker ps -aq) - with option -f we can remove containers with running containers
- docker container run -it [IMAGE_NAME] - create an run a container in foreground  (-i = interactive Keep STDIN open if not attached), (-t = tty - Open prompt)
- docker container run -d [IMAGE_NAME] - The -d option makes the container run in the background. You can connect to the container by using the exec command and running a bash shell
- docker container run -d --name [DEFINE_NAME_CONTAINER] [IMAGE_NAME] - create an run container in the background with a defined name
- docker exec -it [CONTAINER_NAME_or_CONTAINER_ID] [COMMANDS] - execute commands inside the container
- docker container logs [CONTAINER_NAME_or_CONTAINER_ID] - show all logs
- docker container logs --tail=1 [CONTAINER_NAME_or_CONTAINER_ID] - show custom count logs
- docker container top [CONTAINER_NAME_or_CONTAINER_ID] - show list processes running in the container

## NETWORKING
"bridge" or "host" or "none" is the default network
- docker network ls - List networks (bridge, host, null are the default)
- docker network inspect [NETWORK_NAME] - inspect network information
- docker network inspect bridge - show network information where you can see which container use driver bridge
- docker network create --driver [DRIVER_NAME] [NETWORK_NAME] - Create network default DRIVER_NAME is a bridge
- docker network connect [NETWORK_NAME] [CONTAINER_NAME] - Connect an existing container to a network
- docker network disconnect [NETWORK_NAME] [CONTAINER_NAME] - Disconnect container from a network
- docker network rm [NETWORK_NAME] - Remove network
- docker container port [CONTINAR_ID or CONTAINER_NAME] - Get port
- docker container run -d --name [NAME] --network [NETWORK_NAME] [IMAGE_NAME] - Create a container on network
- docker container attach [CONTAINER_NAME or CONTAINER ID] - start attach local standard input, output, and error streams to a running container, we can ping another container via IP address or CONTAINER_NAME (for example `ping -c 2 [CONTAINER_NAME or IP_ADDRESS]`)

## NETWORK TUTORIALS
- tutorial BRIDGE Everything what is connect with the bridge has access on the internet. If you do not specify driver default is a bridge
- tutorial HOST The host networking driver only works on Linux hosts and is not supported on Docker Desktop for Mac, Docker Desktop for Windows, or Docker EE for Windows Server. `docker run -d -p 8080:80 --name my_web_server nginx` after that you can use this link http://localhost:8080/.
 
## IMAGE TAGGING & PUSHING TO DOCKERHUB
- Tags are labels that point of an image ID
- docker image tag nginx test/nginx - Retag existing image
- docker image push test/nginx - Upload to dockerhub
If denied, do docker login

## DOCKERFILE PARTS
- FROM - The operation system used. Common is alpine, Debian, Ubuntu or another image... [https://hub.docker.com/search?&q=](https://hub.docker.com/search?&q=)
- ENV - Environment variables
- RUN - Run commands/shell scripts, etc
- EXPOSE - Ports to expose
- CMD - Final command run when you launch a new container from the image
- WORKDIR - Sets working directory (also could use 'RUN cd /some/path')
- COPY - Copies files from host to the container

- MAINTAINER - who create docker `MAINTAINER name surname <mail@gmail.com>`
- VOLUME - we can define a path for sharing data to container or containers, we don't have to rebuild image after changes

Build an image from Dockerfile (repo name can be whatever)
docker image build -t [REPONAME] . - From the same directory as Dockerfile

### TIP: CACHE & ORDER
If you re-run the build, it will be quick because everything is cached.<br>
If you change one line and re-run, that line and everything after will not be cached<br>
Keep things that change the most toward the bottom of the Dockerfile<br>

### EXTENDING DOCKERFILE
Custom Dockerfile for HTML page with nginx<br>
Dockerfile<br>
FROM nginx:latest # Extends nginx so everything included in that image is included here<br>
WORKDIR /usr/share/nginx/html<br>
COPY index.html index.html<br>

- docker image build -t nginx-website - Build an image from Dockerfile
- docker container run -p 80:80 --rm nginx-website - Running it
- docker image tag nginx-website:latest btraversy/nginx-website:latest - Tag and push to Dockerhub
- docker image push bradtraversy/nginx-website - or push without tag

# Manage data in Docker

## VOLUME
Volumes are stored in a part of the host filesystem which is managed by Docker (/var/lib/docker/volumes/ on Linux). Non-Docker processes should not modify this part of the filesystem. Volumes are the best way to persist data in Docker. Volumes makes special location outside of container union fily system. Used for databases.

- docker volume ls - check volumes
- docker volume prune - Cleanup unused volumes
- docker volume rm [VOLUME_NAME] - remove volume
# Example:

- docker pull mysql - Pull down MySQL image to test
- docker image inspect mysql - Inspect and see volume
- docker container run -d --name mysql -e MYSQL_ALLOW_EMPTY_PASSWORD=True mysql - Run container
- docker container inspect mysql - Inspect and see volume in the container
- docker container run -d --name mysql -e MYSQL_ALLOW_EMPTY_PASSWORD=True -v mysql-db:/var/lib/mysql mysql - Named volumes (Add -v command)(the name here is mysql-db which could be anything)
#### TIP: Mounts
You will also see the volume under mounts<br>
The container gets its own unique location on the host to store that data<br>
Source: xxx is where it lives on the host<br>

## BIND MOUNTS
Can not use in Dockerfile, specified at run time (uses -v as well)<br>
... run -v /Users/brad/stuff:/path/container (mac/linux)<br>
... run -v //c/Users/brad/stuff:/path/container (windows)<br>
Bind mounts may be stored anywhere on the host system. They may even be important system files or directories. Non-Docker processes on the Docker host or a Docker container can modify them at any time.<br>

#### TIP: Instead of typing out local path, for working directory use $(pwd):/path/container - On windows may not work unless you are in your users folder

## SOME SAMPLE CONTAINER CREATION
- docker container run -it --name ubuntu-test ubuntu - UBUNTU
- docker container run -d -p 80:80 --name nginx-test nginx - NGINX
- docker container run -d -p 8080:80 --name apache-test httpd - APACHE
- docker container run -d -p 27017:27017 --name mongo-test mongo - MongoDB
- docker container run -d -p 3306:3306 --name mysql-test --env MYSQL_ROOT_PASSWORD=123456 mysql - MYSQL
- docker container run -dit alpine sh - Alpine is a very small Linux distro good for docker

## ACCESSING CONTAINERS
- docker container run -it --name [NAME] nginx bash - Create a new nginx container and bash into
- docker container run -it --name [NAME] node - create a new node container
- docker container run -it --name [NAME] ubuntu - Run/Create Ubuntu container (no bash because ubuntu uses bash by default)
- docker container start -ai [CONTINAR_ID or CONTAINER_NAME] - Access an already created container, start with -ai
- docker exec -it [CONTAINER_ID or CONTAINER_NAME] "/bin/sh", docker exec -it [CONTINAR_ID or CONTAINER_NAME] bash - Use exec to edit config, run bash inside the container, etc
- docker exec -it [CONTINAR_ID or CONTAINER_NAME] ping -w3 google.com

Best management solution for Docker
[Portainer](https://www.portainer.io/overview/)
[setup portainer](https://www.portainer.io/installation/)

run portainer for windows
```bash
docker volume create portainer_data
docker run -d -p 9000:9000 -v //var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data --name portainer portainer/portainer
```
