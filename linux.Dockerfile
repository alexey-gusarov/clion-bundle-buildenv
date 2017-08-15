FROM centos:6

RUN (echo ; \
     echo "group_package_types=mandatory";) >> /etc/yum.conf \
 && yum -y update \
 && yum -y groupinstall "Development Tools" \
 && yum -y install \
      sudo \
      git \
 && yum clean all

RUN yum -y update \
 && yum -y install \
      libarchive-devel \
      nano \
 && yum clean all

COPY linux/install-pacman.sh /tmp/install-pacman.sh
RUN chmod a+x /tmp/install-pacman.sh \
 && /tmp/install-pacman.sh \
 && rm -f /tmp/install-pacman.sh

RUN groupadd -r build \
 && useradd --no-log-init -r -m -g build build \
 && echo "build ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/build && \
    chmod 0440 /etc/sudoers.d/build

RUN mkdir -p /opt \
 && chown build:build /opt

WORKDIR /home/build

COPY common/ ./
COPY linux/ ./

RUN chown -R build:build . \
 && chmod a+x *.sh

USER build
