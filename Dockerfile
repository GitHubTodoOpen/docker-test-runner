
FROM ubuntu:14.04
MAINTAINER Florent Detry <detry.florent@gmail.com>

RUN locale-gen en_US.UTF-8
RUN locale-gen fr_BE.UTF-8
ENV LANG en_US.UTF-8
ENV LC_CTYPE fr_BE.UTF-8

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y git curl build-essential

# nvm
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.25.4/install.sh | bash

# rvm
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN curl https://raw.githubusercontent.com/rvm/rvm/master/binscripts/rvm-installer | bash -s stable --ruby
RUN echo "source /etc/profile.d/rvm.sh" >> ~/.bashrc

# clean
RUN apt-get clean
