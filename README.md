# Host machine setup

Please use CentOS 7.5 / RHEL 7.5 as host machine.  

At first, please install the latest VEOS and related packages
in your host machine.  

## 1. Install Docker daemon

### Cent OS 7.5
Edit /etc/yum.repos.d/CentOS-Base.repo to enable "base", "updates" and
"extras" repository for packages required by Docker.

~~~
[base]
name=CentOS-$releasever - Base
mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os&infra=$infra
#baseurl=http://mirror.centos.org/centos/$releasever/os/$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
enabled=1

#released updates
[updates]
name=CentOS-$releasever - Updates
mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=updates&infra=$infra
#baseurl=http://mirror.centos.org/centos/$releasever/updates/$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
enabled=1

#additional packages that may be useful
[extras]
name=CentOS-$releasever - Extras
mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras&infra=$infra
#baseurl=http://mirror.centos.org/centos/$releasever/extras/$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
enabled=1
~~~

Install Docker.

~~~
$ sudo yum-config-manager --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
$ sudo yum install docker-ce
~~~

Edit /etc/yum.repos.d/CentOS-Base.repo to disable "base", "updates" and "extras" repository.

### RHEL 7.5
Download the following RPM package files and install the packages.

    PyYAML-3.10-11.el7.x86_64.rpm
    atomic-registries-1.22.1-26.gitb507039.el7.x86_64.rpm
    container-selinux-2.74-1.el7.noarch.rpm
    container-storage-setup-0.11.0-2.git5eaf76c.el7.noarch.rpm
    containers-common-0.1.31-8.gitb0b750d.el7.x86_64.rpm
    docker-1.13.1-91.git07f3374.el7.x86_64.rpm
    docker-client-1.13.1-91.git07f3374.el7.x86_64.rpm
    docker-common-1.13.1-91.git07f3374.el7.x86_64.rpm
    docker-rhel-push-plugin-1.13.1-91.git07f3374.el7.x86_64.rpm
    libseccomp-2.3.1-3.el7.x86_64.rpm
    libselinux-2.5-14.1.el7.x86_64.rpm
    libselinux-python-2.5-14.1.el7.x86_64.rpm
    libselinux-utils-2.5-14.1.el7.x86_64.rpm
    libsemanage-2.5-14.el7.x86_64.rpm
    libsemanage-python-2.5-14.el7.x86_64.rpm
    libsepol-2.5-10.el7.x86_64.rpm
    oci-register-machine-0-6.git2b44233.el7.x86_64.rpm
    oci-systemd-hook-0.1.18-3.git8787307.el7_6.x86_64.rpm
    oci-umount-2.3.4-2.git87f9237.el7.x86_64.rpm
    policycoreutils-2.5-29.el7_6.1.x86_64.rpm
    policycoreutils-python-2.5-29.el7_6.1.x86_64.rpm
    python-backports-1.0-8.el7.x86_64.rpm
    python-backports-ssl_match_hostname-3.5.0.1-1.el7.noarch.rpm
    python-ipaddress-1.0.16-2.el7.noarch.rpm
    python-pytoml-0.1.14-1.git7dea353.el7.noarch.rpm
    python-setuptools-0.9.8-7.el7.noarch.rpm
    selinux-policy-3.13.1-229.el7_6.9.noarch.rpm
    selinux-policy-targeted-3.13.1-229.el7_6.9.noarch.rpm
    setools-libs-3.3.8-4.el7.x86_64.rpm
    yajl-2.0.4-4.el7.x86_64.rpm

~~~
$ sudo yum install *.rpm
~~~

## 2. Make docker group and add your account
~~~
$ sudo groupadd docker
$ sudo usermod -aG docker <name>
~~~

Please logout and login.

## 3. Start docker service
~~~
$ sudo systemctl start docker
$ sudo systemctl enable docker
~~~

# Create a docker image

## 1. Get the docker image of CentOS.

~~~
$ docker pull centos:7.5.1804
$ docker images
~~~

## 2. Build the docker image of VEOS
~~~
$ git clone https://github.com/veos-sxarr-NEC/docker_container.git
$ cd docker_container.git
$ docker build . -t veos:develop
~~~

If your network is behind a proxy, please prepare yum.conf with
proxy setting and edit Dockerfile to use the proxy.
You need to edit two lines in Dockerfile to use a proxy server.
First, enable the following line
~~~
 ADD yum.conf /etc
~~~
by removing '#' in Dockerfile.  
Second, add --httpproxy option to the rpm command on importing the GPG key of
SX-Aurora TSUBASA software. For example, suppose that your proxy is
proxy.example.com:
~~~
RUN		yum -y install yum-utils && \
		...
		rpm --import --httpproxy proxy.example.com https://www.nec.com/en/global/prod/hpc/aurora/ve-software/files/RPM-GPG-KEY-TSUBASA-soft && \
		yum -y install ....
~~~

# Run an application in the docker container
~~~
$ docker run --device=<path to host ve device file>:<path to ve device file in container> -v /dev:/dev:z -v /var/opt/nec/ve/veos:/var/opt/nec/ve/veos:z -v /opt/nec/ve/veos:/opt/nec/ve/veos:ro -v <path to host binary directry>:<path to container binary directry>:z -it <image ID> <path to binary in container>
~~~

For example,
~~~
$ docker run --device=/dev/ve0:/dev/ve0 -v /dev:/dev:z -v /var/opt/nec/ve/veos:/var/opt/nec/ve/veos:z -v /opt/nec/ve/veos:/opt/nec/ve/veos:ro -v ${HOME}:${HOME}:z -it veos:develop ${HOME}/binary
~~~

# Appendix 1: docker run
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

# Appendix 2: docker command
**Exit container**
`$ exit`  

*At host machine:*  
  
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

# Appendix 3: docker related packages
    Dep-Install PyYAML-3.10-11.el7.x86_64                                          @base
    Dep-Install atomic-registries-1:1.22.1-26.gitb507039.el7.centos.x86_64         @extras
    Dep-Install container-selinux-2:2.74-1.el7.noarch                              @extras
    Dep-Install container-storage-setup-0.11.0-2.git5eaf76c.el7.noarch             @extras
    Dep-Install containers-common-1:0.1.31-8.gitb0b750d.el7.centos.x86_64          @extras
    Install     docker-2:1.13.1-91.git07f3374.el7.centos.x86_64                    @extras
    Dep-Install docker-client-2:1.13.1-91.git07f3374.el7.centos.x86_64             @extras
    Dep-Install docker-common-2:1.13.1-91.git07f3374.el7.centos.x86_64             @extras
    Dep-Install libseccomp-2.3.1-3.el7.x86_64                                      @base
    Updated     libselinux-2.5-12.el7.x86_64                                       @anaconda
    Update                 2.5-14.1.el7.x86_64                                     @base
    Updated     libselinux-python-2.5-12.el7.x86_64                                @anaconda
    Update                        2.5-14.1.el7.x86_64                              @base
    Updated     libselinux-utils-2.5-12.el7.x86_64                                 @anaconda
    Update                       2.5-14.1.el7.x86_64                               @base
    Updated     libsemanage-2.5-11.el7.x86_64                                      @anaconda
    Update                  2.5-14.el7.x86_64                                      @base
    Updated     libsemanage-python-2.5-11.el7.x86_64                               @c7-media
    Update                         2.5-14.el7.x86_64                               @base
    Updated     libsepol-2.5-8.1.el7.x86_64                                        @anaconda
    Update               2.5-10.el7.x86_64                                         @base
    Dep-Install oci-register-machine-1:0-6.git2b44233.el7.x86_64                   @extras
    Dep-Install oci-systemd-hook-1:0.1.18-3.git8787307.el7_6.x86_64                @extras
    Dep-Install oci-umount-2:2.3.4-2.git87f9237.el7.x86_64                         @extras
    Updated     policycoreutils-2.5-22.el7.x86_64                                  @anaconda
    Update                      2.5-29.el7_6.1.x86_64                              @updates
    Updated     policycoreutils-python-2.5-22.el7.x86_64                           @c7-media
    Update                             2.5-29.el7_6.1.x86_64                       @updates
    Dep-Install python-backports-1.0-8.el7.x86_64                                  @base
    Dep-Install python-backports-ssl_match_hostname-3.5.0.1-1.el7.noarch           @base
    Dep-Install python-ipaddress-1.0.16-2.el7.noarch                               @base
    Dep-Install python-pytoml-0.1.14-1.git7dea353.el7.noarch                       @extras
    Dep-Install python-setuptools-0.9.8-7.el7.noarch                               @base
    Updated     selinux-policy-3.13.1-192.el7.noarch                               @anaconda
    Update                     3.13.1-229.el7_6.9.noarch                           @updates
    Updated     selinux-policy-targeted-3.13.1-192.el7.noarch                      @anaconda
    Update                              3.13.1-229.el7_6.9.noarch                  @updates
    Updated     setools-libs-3.3.8-2.el7.x86_64                                    @c7-media
    Update                   3.3.8-4.el7.x86_64                                    @base
    Dep-Install subscription-manager-rhsm-certificates-1.21.10-3.el7.centos.x86_64 @updates
    Dep-Install yajl-2.0.4-4.el7.x86_64                                            @base
