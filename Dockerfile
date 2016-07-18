
FROM ubuntu:14.04
MAINTAINER iGLOO Team <support@igloo.be>

RUN echo "# Generate locales" && \
    locale-gen en_US.UTF-8 && \
    locale-gen fr_BE.UTF-8 && \
    export LANG=en_US.UTF-8 && \
    export LC_CTYPE=fr_BE.UTF-8 && \

    echo "# Upgrade apt" && \
    apt-get update && apt-get upgrade -y && \

    echo "# Install git" && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:git-core/ppa && \
    apt-get update && \
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
                       mysql-client-5.6 \
                       libfreetype6 libfontconfig \
                       default-jre \
                       firefox \
                       xvfb \
                       && \

    echo "# Install google-chrome-stable" && \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    sh -c 'echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
    apt-get install -y apt-transport-https && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    apt-get remove -y apt-transport-https && \

    echo "# Install nvm" && \
    export NVM_VERSION=v0.31.2 && \
    curl -o- https://raw.githubusercontent.com/creationix/nvm/$NVM_VERSION/install.sh | bash && \
    cp /root/.nvm/nvm.sh /etc/profile.d/ && \

    echo "# Install rvm" && \
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 && \
    curl https://raw.githubusercontent.com/rvm/rvm/master/binscripts/rvm-installer | bash -s stable --ruby && \
    echo "source /etc/profile.d/rvm.sh" >> ~/.bashrc && \

    echo "# Install wkhtmltopdf" && \
    apt-get install -y gdebi \
                       libssl-dev \
                       libxrender-dev && \
    wget http://download.gna.org/wkhtmltopdf/0.12/0.12.2.1/wkhtmltox-0.12.2.1_linux-trusty-amd64.deb && \
    gdebi --n wkhtmltox-0.12.2.1_linux-trusty-amd64.deb && \
    rm -rf wkhtmltox-0.12.2.1_linux-trusty-amd64.deb && \
    apt-get remove -y gdebi && \

    echo "# Install docker client" && \
    export DOCKER_BUCKET=get.docker.com && \
    export DOCKER_VERSION=1.11.2 && \
    export DOCKER_SHA256=8c2e0c35e3cda11706f54b2d46c2521a6e9026a7b13c7d4b8ae1f3a706fc55e1 && \
  	curl -fSL "https://${DOCKER_BUCKET}/builds/Linux/x86_64/docker-$DOCKER_VERSION.tgz" -o docker.tgz && \
  	echo "${DOCKER_SHA256} *docker.tgz" | sha256sum -c - && \
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
    apt-get update && apt-get install google-cloud-sdk && \

    echo "# Clean" && \
    apt-get clean && apt-get autoremove -y && rm -rf /tmp/*

ENV DOCKER_HOST tcp://docker:2375
