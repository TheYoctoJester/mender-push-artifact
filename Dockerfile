# Container image that runs your code
FROM ubuntu:latest

COPY install-packages /usr/bin

### base ###
ARG DEBIAN_FRONTEND=noninteractive

RUN yes | unminimize \
    && install-packages \
    ca-certificates \
    curl \
    locales \
    && locale-gen en_US.UTF-8

ENV LANG=en_US.UTF-8

### Local user ###
# '-l': see https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#user
RUN useradd -l -u 1000 -G sudo -md /home/user -s /bin/bash -p user user \
    # passwordless sudo for users in the 'sudo' group
    && sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers
ENV HOME=/home/user
WORKDIR $HOME

### Local user (2) ###
USER user
# use sudo so that user does not get sudo usage info on (the first) login
RUN sudo echo "Running 'sudo' for user: success"

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]