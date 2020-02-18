# Dockerfile for SX-Aurora TSUBASA

This repository has a Dockerfile to build docker image to execute a program on Vector Engine of SX-Aurora TSUBASA.

This document explains how to build a docker image with VEOS and related software, and how to execute a VE program on Docker using the image.
Note users can not execute MPI program in a container built by this Dockerfile because NEC MPI will not be installed.

We have tested the Dockerfile with the following version of Docker.

* docker-ce-19.03.5-3

## Create a docker image

Clone the repository on github.

~~~
$ git clone https://github.com/veos-sxarr-NEC/docker_container.git
$ cd docker_container
~~~

Download TSUBASA-soft-release-2.0-1.noarch.rpm.

~~~
$ curl -O https://www.hpc.nec/repos/TSUBASA-soft-release-2.0-1.noarch.rpm
~~~

Update "username" and "password" for "nec-sdk" in TSUBASA-restricted.repo.

If your network is behind a proxy, please update yum.conf to set the proxy.

Build a docker image.

~~~
$ docker build . -t veos:latest
~~~

## Run an application in the docker container
~~~
$ docker run --device=<path to host ve device file>:<path to ve device file in container> -v /dev:/dev:z -v /var/opt/nec/ve/veos:/var/opt/nec/ve/veos:z -v /opt/nec/ve/veos:/opt/nec/ve/veos:ro -v <pass to host binary directry>:<pass to container binary directry>:z -it <image ID> <pass to binary in container>
~~~

for example  
~~~
$ docker run --device=/dev/ve0:/dev/ve0 -v /dev:/dev:z -v /var/opt/nec/ve/veos:/var/opt/nec/ve/veos:z -v /opt/nec/ve/veos:/opt/nec/ve/veos:ro -v ${HOME}:${HOME}:z -it veos:latest ${HOME}/binary
~~~

## Appendix 1: docker run
make container from docker image  
`$ docker run [-t, image name or image ID] command`  

option  
**-i** : Acquire device. Keep STDIN open even if not attached.  

**-d** : Run container in background and print container ID  

**-v [host:container:option]** : Mount a volume  
    option : -z : change the label of directry  

**--device=[host:contianer]** : Add a host device to the container  

**--privileged** : Give extended privileges to this container  

**--cap-add=[]** : Add Linux capabilities  

## Appendix 2: docker command

**List up docker image**  
`$ docker images`  

**Commit the docker image**  
`$ docker commit <container ID> <image name>`

**Remove a docker image**  
`$ docker rmi <image ID>`  

**Check a running container ID**  
`$ docker ps`  

**Check a container ID**  
`$ docker ps -a`  

**Run container**  
`$ docker start <container ID>`  
  
**Stop container from host machine**  
`$ docker stop <container ID>`  

**Stop container from host forcibly**  
`$ docker kill <container ID>`  

**Remove a container**  
`$ docker rm <container ID>`  

**Remove all container**  
`$ docker rm   $(sudo docker ps -a -q)`  

**Into a running container**  
`$ docker exec -it <container ID> /bin/bash`  

**make tar file from docker image**  
`$ docker save "image ID" > "tar file name"`  
