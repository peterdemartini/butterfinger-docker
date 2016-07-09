FROM ubuntu:16.04
MAINTAINER Peter DeMartini <thepeterdemartini@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -y unionfs-fuse

ADD build.sh /opt
RUN chmod +x /opt/build.sh

CMD ["/opt/build.sh"]
