FROM          docker.io/centos:7.5.1804
MAINTAINER      NEC
ARG		VEOS_REPO=https://www.hpc.nec/repos/TSUBASA-repo_el7.5

ADD		yum.conf /etc/
RUN		yum -y install yum-utils && \
		yum-config-manager --add-repo $VEOS_REPO && yum clean all && \
		rpm --import https://www.nec.com/en/global/prod/hpc/aurora/ve-software/files/RPM-GPG-KEY-TSUBASA-soft && \
		yum -y install veos libved libsysve velayout glibc-ve \
		  coreutils-ve procps-ng-ve psmisc-ve time-ve util-linux-ve \
		  veosinfo strace-ve gdb-ve libthread_db-ve veos-libveptrace \
		  veoffload veoffload-veorun glibc-ve-devel kernel-headers-ve \
		  libgcc-ve-static libsysve-devel vedebuginfo autoconf-ve \
		  automake-ve libtool-ve veoffload-devel \
		  veoffload-veorun-devel veos-headers veos-devel
ENV		LOG4C_RCPATH=/etc/opt/nec/ve/veos
CMD		["/bin/bash"]
