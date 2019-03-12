
FROM ubuntu:16.04

ENV NVM_VERSION v0.34.0
ENV NPM_CONFIG_UNSAFE_PERM true
ENV DOCKER_VERSION 18.09.1

RUN echo "# Upgrade apt" && \
    apt-get -qq update && apt-get upgrade -y && \
    echo "# Install git" && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:git-core/ppa && \
    apt-get -qq update && \
    apt-get install -y git && \
    git --version && \
    apt-get remove -y software-properties-common && \
    echo "# Install common dev dependencies via apt" && \
    apt-get install -y curl \
                       wget \
                       rsync \
                       patch \
                       build-essential \
                       python \
                       mysql-client-5.7 \
                       libfreetype6 libfontconfig \
                       default-jre \
                       xvfb \
                       locales \
                       && \
    echo "# Generate locales" && \
    locale-gen en_US.UTF-8 && \
    locale-gen fr_BE.UTF-8 && \
    export LANG=en_US.UTF-8 && \
    export LC_CTYPE=fr_BE.UTF-8 && \
    echo "# Install firefox" && \
    apt-get install -y firefox=65.0.1+build2-0ubuntu0.16.04.1 && \
    echo "# Install google-chrome-stable" && \
    sh -c 'echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list' && \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    apt-get install -y apt-transport-https && \
    apt-get -qq update && \
    apt-get install -y google-chrome-stable && \
    apt-get remove -y apt-transport-https && \
    echo "# Install nvm" && \
    curl -o- https://raw.githubusercontent.com/creationix/nvm/$NVM_VERSION/install.sh | bash && \
    cp /root/.nvm/nvm.sh /etc/profile.d/ && \
    echo "# Install rvm" && \
    mkdir ~/.gnupg && echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf && \
    gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB && \
    curl -sSL https://get.rvm.io | bash -s stable --ruby && \
    echo "source /etc/profile.d/rvm.sh" >> ~/.bashrc && \
    echo "# Install wkhtmltopdf" && \
    apt install -y wget libxrender1 xfonts-utils xfonts-base xfonts-75dpi libfontenc1 x11-common xfonts-encodings libxfont2 fontconfig && \
    wget --quiet https://downloads.wkhtmltopdf.org/0.12/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz && \
    mkdir -p /opt && \
    tar -xf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz -C /opt && \
    rm -rf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz && \
    ln /opt/wkhtmltox/bin/wkhtmltopdf /usr/local/bin/wkhtmltopdf && \
    ln /opt/wkhtmltox/bin/wkhtmltoimage /usr/local/bin/wkhtmltoimage && \
    echo "# Install docker" && \
    curl -fSL "https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_VERSION.tgz" -o docker.tgz && \
  	tar -xzvf docker.tgz && \
  	mv docker/* /usr/local/bin/ && \
  	rmdir docker && \
  	rm docker.tgz && \
  	docker -v && \
    echo "# Install google cloud sdk" && \
    # Create an environment variable for the correct distribution
    export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    # Add the Cloud SDK distribution URI as a package source
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list && \
    # Import the Google Cloud public key
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    # Update and install the Cloud SDK
    apt-get -qq update && apt-get install -y google-cloud-sdk && \
    echo "# Clean" && \
    apt-get clean && SUDO_FORCE_REMOVE=yes apt-get autoremove -y && rm -rf /tmp/*

ENV DOCKER_HOST tcp://docker:2375
ENV BASH_ENV "/etc/profile"
