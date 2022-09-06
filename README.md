# Dockerfile for SX-Aurora TSUBASA

This repository has a Dockerfile to build docker image to execute a program on Vector Engine of SX-Aurora TSUBASA.

This document explains how to build a docker image with VEOS and related software, and how to execute a VE application on Docker using the image.
Note users can not execute MPI program in a container built by this Dockerfile because NEC MPI will not be installed.

You can save and use the image as execution environment for your program.

We have tested the Dockerfile with the following version of Docker.

* docker-ce-20.10.17-3

## Compatibility problems

To avoid the compatibility problem, please consider the below points:

* The compatibility of software between a host machine and a container.
  * The version of VEOS in a host machine must be greater than or equal to the version of VEOS in a container.

* The compatibility of software between a container and a build machine
  * Each software version of NEC SDK in a container must be greater than or equal to each software version of NEC SDK in a build machine where you built your program.

## Build the docker image of VEOS

Clone the repository.

~~~
$ git clone https://github.com/veos-sxarr-NEC/docker_container.git
~~~

Change the current directory to the directory which has Dockerfile.

~~~
$ cd docker_container/RockyLinux8
~~~

Download TSUBASA-soft-release-2.8-1.noarch.rpm.


~~~
$ curl -O https://sxauroratsubasa.sakura.ne.jp/repos/TSUBASA-soft-release-2.8-1.noarch.rpm
~~~

Build a docker image.
~~~
$ docker build . -t veos:latest
~~~

## Run an application in the docker container

Run an application using the below command.

~~~
$ docker run --device=<path to host ve device file>:<path to ve device file in container> -v /dev:/dev:z -v /var/opt/nec/ve/veos:/var/opt/nec/ve/veos:z -v <pass to host binary directry>:<pass to container binary directry>:z -it <image ID> <pass to binary in container>
~~~

For example, run container image with VE NODE#0
~~~
$ docker run --device=`readlink -f /dev/veslot0`:`readlink -f /dev/veslot0` -v /dev:/dev:z -v /var/opt/nec/ve/veos:/var/opt/nec/ve/veos:z -v ${HOME}:${HOME}:z -it veos:latest ${HOME}/binary
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

**Make tar file from a docker image**  
`$ docker save "image ID" > "tar file name"`  

**Load a docker image from a tar file**  
`$ docker load < "tar file name"`  
