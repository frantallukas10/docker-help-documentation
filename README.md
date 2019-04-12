# DOCKER DOCUMENTATION

## DOCKER BASICS
### COMMANDs
1. `docker` - show options and management commands<br>
2. `docker search [name]` - we search the docker container images in registry server from the terminal<br>
3. `docker --version` - show docker version info<br>
4. `docker info` - view even more details about your Docker installation<br>
5. `docker image --help` - show help for manage images<br>
6. `docker image ls -a` - show list all images on this machine<br>
7. `docker inspect '{{.Config}}' [CONTAINER_NAME or CONTAINER ID]` - show config Image for container
8. `docker inspect "{{.NetworkSettings}}" [CONTAINER_NAME or CONTAINER ID]` - show network settings for container
9. `docker inspect -f '{{.Config.Image}}' [CONTAINER_NAME or CONTAINER ID]` - show name Image for container
10. `docker inspect -f '{{.RepoTags}}' [IMAGE_NAME]` - show version image
   
## WORKING WITH CONTAINERS
### COMMANDS
1. `docker container --help` - show help for manage containers<br>
2. `docker container stats [CONTAINER_NAME or CONTAINER ID]` - performance stats (cpu, mem, network, disk, etc)<br>
3. `docker container ls` or `docker ps` - show list all running containers<br>
4. `docker container ls -a` - show list all containers, even those not running<br>
5.  `docker container start <CONTAINER_NAME or CONTAINER ID>` - start specified container<br>
6. `docker container stop <CONTAINER_NAME or CONTAINER ID>` - gracefully stop the specified container<br>
7. `docker container kill <CONTAINER_NAME or CONTAINER ID>` - force shutdown of the specified container<br>
8. `docker container rm <CONTAINER_NAME or CONTAINER ID>` - remove specified container (Can not remove running containers, must stop first)<br>
9.  `docker container rm -f <CONTAINER_NAME or CONTAINER ID>` - to remove a running container use force (-f)<br>
10. `docker container rm <CONTAINER_NAME or CONTAINER ID> <CONTAINER_NAME or CONTAINER ID> <CONTAINER_NAME or CONTAINER ID>` - remove multiple containers (Can not remove running containers, must stop first)<br>
11. `docker rm $(docker ps -aq)` - remove all containers (Can not remove running containers, must stop first)
12. `docker container run -it -p 80:80 nginx` - create an run a container nginx in foreground<br>
    -i = interactive Keep STDIN open if not attached<br>
    -t = tty - Open prompt)<br>
13. `docker container run -d -p 80:80 nginx` - create an run a container nginx in background<br>
14. `docker container run -d -p 80:80 --name nginx-server-my-name nginx` - create an run container nginx in background with define name<br>
15. `docker container logs [CONTAINER_NAME or CONTAINER ID]` - show all logs<br>
16. `docker container logs --tail=1 [CONTAINER_NAME or CONTAINER ID]` - show custom count logs<br>
17. `docker container top [CONTAINER_NAME or CONTAINER ID]` - show list processes running in container<br>

### ABOUT CONTAINERS
Docker containers are often compared to virtual machines but they are actually just processes running on your host os. In Windows/Mac, Docker runs in a mini-VM so to see the processes youll need to connect directly to that. On Linux however you can run "ps aux" and see the processes directly
    
### HOW RUN DOCKER CONTAINER WORKS?
- First looked for image called nginx in image cache
- If not found in cache, it looks to the default image repo on Dockerhub
- Pulled it down (latest version), stored in the image cache
- Started it in a new container
- We specified to take port 80- on the host and forward to port 80 on the container
- We could do "$ docker container run --publish 8000:80 --detach nginx" to use port 8000
- We can specify versions like "nginx:1.09"
   
## WORKING WITH IMAGES
### COMMANDS
1. `docker iamges --help` - show help for manage iamges<br>
2. `docker image ls` or `docker images` - show list the images we have pulled<br>
3. `docker pull [IMAGE_NAME]` - we can also just pull down images<br>
4. `docker image rm [IMAGE_NAME]` or `docker rmi [IMAGE_NAME]` - remove image<br>
5. `docker rmi $(docker images -a -q)` - remove all images<br>

### ABOUT IMAGES
Images are app bianaries and dependencies with meta data about the image data and how to run the image
Images are no a complete OS. No kernel, kernel modules (drivers)
Host provides the kernel, big difference between VM

## SOME SAMPLE CONTAINER CREATION
- UBUNTU:<br>
`docker container run -it --name ubuntu-test ubuntu`
- NGINX:<br>
`docker container run -d -p 80:80 --name nginx-test nginx (-p 80:80 is optional as it runs on 80 by default)` 
- APACHE:<br>
`docker container run -d -p 8080:80 --name apache-test httpd` 
- MONGODB:<br>
`docker container run -d -p 27017:27017 --name mongo-test mongo:4.0.4` 
- MYSQL:<br>
`docker container run -d -p 3306:3306 --name mysql-test --env MYSQL_ROOT_PASSWORD=123456 mysql` 
Alpine is a very small Linux distro good for docker (use sh because it does not include bash) (alpine uses apk for its package manager - can install bash if you want):<br>
`docker container run -dit alpine sh` or ontainers running `ash`, which is Alpine’s default shell rather than bash<br>
`docker container run -dit alpine ash`

## ACCESSING CONTAINERS
`docker container run -it --name [NAME] nginx bash` - Create new nginx container and bash into
`docker container run -it --name [NAME] node` - create new node container
`docker container run -it --name [NAME] ubuntu` - Run/Create Ubuntu container (no bash because ubuntu uses bash by default)
`docker container start -ai [CONTINAR_ID or CONTAINER_NAME]` - Access an already created container, start with -ai
`docker exec -it [CONTINAR_ID or CONTAINER_NAME] "/bin/sh"`, `docker exec -it [CONTINAR_ID or CONTAINER_NAME] bash` - Use exec to edit config, etc
`docker exec -it [CONTINAR_ID or CONTAINER_NAME] ping -w3 google.com` -

## NETWORKING
"bridge" or "host" or "none" is the default network
`docker network ls` - List networks (bridge, host, null are default)
`docker network inspect [NETWORK_NAME]` - inspect network information
`docker network inspect bridge` - show network information where you can see which container use driver bridge
`docker network create --driver [DRIVER_NAME] [NETWORK_NAME]` - Create network default DRIVER_NAME is bridge
`docker network connect [NETWORK_NAME] [CONTAINER_NAME]` - Connect existing container to network
`docker network disconnect [NETWORK_NAME] [CONTAINER_NAME]` - Disconnect container from network
`docker network rm [NETWORK_NAME]` - Remove network
`docker container port [CONTINAR_ID or CONTAINER_NAME]` - Get port
`docker container run -d --name [NAME] --network [NETWORK_NAME] [IMAGE_NAME]` - Create container on network
`docker container attach [CONTAINER_NAME or CONTAINER ID]` - start attach local standard input, output, and error streams to a running container, we can ping another container via ip adress or CONTAINER_NAME (for example `ping -c 2 [CONTAINER_NAME or IP_ADDRESS]`)

### NETWORK TUTORIALs
- (tutorial BRIDGE)[https://docs.docker.com/network/network-tutorial-standalone/]<br>
  Everything what is connect with bridge it has acces on internet. If you not specify driver default is bridge
- (tutorial HOST)[https://docs.docker.com/network/network-tutorial-host/]<br>
  The host networking driver only works on Linux hosts, and is not supported on Docker Desktop for Mac, Docker Desktop for Windows, or Docker EE for Windows Server. `docker run -d -p 8080:80 --name my_web_server nginx` after that you can use this link (http://localhost:8080/.)[http://localhost:8080/.]
  