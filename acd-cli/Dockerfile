FROM ubuntu:16.04
MAINTAINER Peter DeMartini <thepeterdemartini@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -y python3-pip git fuse

RUN pip3 install --upgrade pip
RUN pip3 install --upgrade git+https://github.com/yadayada/acd_cli.git

ADD crontab /etc/cron.d/the-cron
RUN chmod a+x /etc/cron.d/the-cron
RUN touch /var/log/cron.log

ADD build.sh /opt
ADD upload.sh /opt
ADD clean-up.sh /opt
RUN chmod +x /opt/clean-up.sh
RUN chmod +x /opt/upload.sh
RUN chmod +x /opt/build.sh

CMD ["/opt/build.sh"]
