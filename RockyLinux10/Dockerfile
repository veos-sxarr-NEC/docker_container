FROM            rockylinux/rockylinux:10.0.20250606
LABEL           maintaner="NEC"
COPY            dnf.conf /etc/dnf/
COPY            TSUBASA-soft-release-*.noarch.rpm /tmp/
COPY            TSUBASA-repo.repo /tmp/
COPY            TSUBASA-restricted.repo /tmp/
ARG             RELEASE_RPM=/tmp/TSUBASA-soft-release-*.noarch.rpm
RUN             yum -y install $RELEASE_RPM && yum clean all
RUN             cp /tmp/*.repo /etc/yum.repos.d
RUN             rm /tmp/*.repo
RUN             yum clean all
RUN             yum -y group install ve-container nec-sdk-runtime && yum clean all
RUN             sed -i -e "s|username=.*|username=|" -e "s|password=.*|password=|" \
                /etc/yum.repos.d/TSUBASA-restricted.repo
#ENV            LOG4C_RCPATH=/etc/opt/nec/ve/veos
CMD             ["/bin/bash"]
