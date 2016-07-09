FROM ubuntu:16.04
MAINTAINER Peter DeMartini <thepeterdemartini@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -y python3-pip git fuse

RUN pip3 install --upgrade git+https://github.com/yadayada/acd_cli.git

ADD build.sh /opt
RUN chmod +x /opt/build.sh

CMD ["/opt/build.sh"]
