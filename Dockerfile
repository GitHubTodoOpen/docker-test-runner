
FROM ubuntu:14.04
MAINTAINER iGLOO Team <support@igloo.be>

RUN echo "# Generate locales" && \
    locale-gen en_US.UTF-8 && \
    locale-gen fr_BE.UTF-8 && \
    export LANG=en_US.UTF-8 && \
    export LC_CTYPE=fr_BE.UTF-8 && \

    echo "# Upgrade apt" && \
    apt-get update && apt-get upgrade -y && \

    echo "# Install common dev dependencies via apt" && \
    apt-get install -y git \
                       curl \
                       wget \
                       rsync \
                       patch \
                       build-essential \
                       python \
                       mysql-client-5.6 \
                       libfreetype6 libfontconfig \
                       && \

    echo "# Install nvm" && \
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.25.4/install.sh | bash && \
    cp /root/.nvm/nvm.sh /etc/profile.d/ && \

    echo "# Install rvm" && \
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 && \
    curl https://raw.githubusercontent.com/rvm/rvm/master/binscripts/rvm-installer | bash -s stable --ruby && \
    echo "source /etc/profile.d/rvm.sh" >> ~/.bashrc && \

    echo "# Clean" && \
    apt-get clean && rm -rf /tmp/*
