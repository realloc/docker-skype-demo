FROM debian:stable
MAINTAINER Stanislav Bogatyrev "realloc@realloc.spb.ru"

# i386 for Skype
ENV DEBIAN_FRONTEND noninteractive
RUN dpkg --add-architecture i386
RUN apt-get update

# Install Skype and deps
RUN apt-get install -y wget
RUN wget http://download.skype.com/linux/skype-debian_4.3.0.37-1_i386.deb -O /usr/src/skype.deb
RUN dpkg -i /usr/src/skype.deb || true
RUN apt-get install -fy

RUN echo "Europe/Moscow" > /etc/timezone

# Start Skype
ENTRYPOINT ["/usr/bin/skype", "--version"]
