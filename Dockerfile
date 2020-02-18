FROM		docker.io/centos:7.7.1908
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
		yum -y group install ve-container && \
		yum -y group install nec-sdk-runtime
#ENV		LOG4C_RCPATH=/etc/opt/nec/ve/veos
CMD		["/bin/bash"]
