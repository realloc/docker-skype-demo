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

# SSH and X11 forwarding
RUN apt-get install -y openssh-server
RUN useradd -m -d /home/skype skype
RUN echo "skype:skype" | chpasswd
RUN mkdir -p /var/run/sshd
RUN echo X11Forwarding yes >> /etc/ssh/ssh_config

RUN echo "Europe/Moscow" > /etc/timezone

# Expose the SSH port
EXPOSE 22

# Start SSH
ENTRYPOINT ["/usr/sbin/sshd",  "-D"]
