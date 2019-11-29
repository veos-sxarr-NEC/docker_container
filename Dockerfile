FROM		docker.io/centos:7.5.1804
MAINTAINER	NEC
ADD		yum.conf /etc
ADD		CentOS-Base.repo /etc/yum.repos.d
ADD		TSUBASA-soft-release-2.0-1.noarch.rpm /tmp
ADD		TSUBASA-repo.repo /tmp
ADD		TSUBASA-restricted.repo /tmp
ARG		RELEASE_RPM=/tmp/TSUBASA-soft-release-2.0-1.noarch.rpm
RUN		\
		yum -y install $RELEASE_RPM && \
		cp /tmp/*.repo /etc/yum.repos.d && \
		rm /tmp/*.repo && \
		yum clean all && \
		yum -y install veos libved libsysve velayout glibc-ve \
		  coreutils-ve procps-ng-ve psmisc-ve time-ve util-linux-ve \
		  veosinfo strace-ve gdb-ve libthread_db-ve veos-libveptrace \
		  veoffload veoffload-veorun glibc-ve-devel kheaders-ve \
		  libgcc-ve-static libsysve-devel vedebuginfo autoconf-ve \
		  automake-ve libtool-ve veoffload-devel \
		  veoffload-veorun-devel veos-headers veos-devel && \
		echo "/opt/nec/ve/veos/lib64" >	 /etc/ld.so.conf.d/veos.conf && \
		yum -y group install nec-sdk-runtime
#ENV		LOG4C_RCPATH=/etc/opt/nec/ve/veos
CMD		["/bin/bash"]
