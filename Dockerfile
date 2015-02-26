FROM debian:stable
MAINTAINER Stanislav Bogatyrev "realloc@realloc.spb.ru"

# i386 for Skype
ENV DEBIAN_FRONTEND noninteractive
RUN dpkg --add-architecture i386
RUN apt-get update

# Install pulse-audio
RUN apt-get install -y libpulse0:i386 pulseaudio:i386

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

# Set up the launch wrapper - sets up PulseAudio to work correctly
RUN echo 'export PULSE_SERVER="tcp:localhost:64713"' >> /usr/local/bin/skype-pulseaudio
RUN echo 'PULSE_LATENCY_MSEC=60 skype "$@"' >> /usr/local/bin/skype-pulseaudio
RUN chmod 755 /usr/local/bin/skype-pulseaudio

# Expose the SSH port
EXPOSE 22

# Start SSH
ENTRYPOINT ["/usr/sbin/sshd",  "-D"]
