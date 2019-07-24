FROM debian:10-slim

LABEL maintainer="Marlon Leerkotte <marlon@leerkotte.net>"

ARG DEBIAN_FRONTEND=noninteractive

ENV PRX_UID=5137 \
    PRX_GID=5137

RUN apt-get update && apt-get install -y openssh-server && rm -rf /var/lib/apt/lists/* \
    && groupadd -r prx -g $PRX_GID \
    && useradd --no-log-init -m -r -u $PRX_UID -g $PRX_GID prx

RUN mkdir /var/run/sshd

RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

RUN /bin/rm -v /etc/ssh/ssh_host_*

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

COPY files/init.sh /init.sh
RUN chmod +x /init.sh

VOLUME /etc/ssh

EXPOSE 22
CMD ["/init.sh"]
