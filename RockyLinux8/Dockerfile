FROM            rockylinux:8.6.20227707
MAINTAINER      NEC
ADD             dnf.conf /etc/dnf
ADD             TSUBASA-soft-release-*.noarch.rpm /tmp
ADD             TSUBASA-repo.repo /tmp
ADD             TSUBASA-restricted.repo /tmp
ARG             RELEASE_RPM=/tmp/TSUBASA-soft-release-*.noarch.rpm
RUN             yum -y install $RELEASE_RPM
RUN             cp /tmp/*.repo /etc/yum.repos.d
RUN             rm /tmp/*.repo
RUN             yum clean all
RUN             yum -y group install ve-container nec-sdk-runtime
RUN             sed -i -e "s|username=.*|username=|" -e "s|password=.*|password=|" \
                /etc/yum.repos.d/TSUBASA-restricted.repo
#ENV            LOG4C_RCPATH=/etc/opt/nec/ve/veos
CMD             ["/bin/bash"]
