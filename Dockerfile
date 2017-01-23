
FROM ubuntu:xenial
MAINTAINER iGLOO Team <support@igloo.be>

ENV DOCKER_BUCKET get.docker.com
ENV DOCKER_VERSION 1.12.3
ENV DOCKER_SHA256 626601deb41d9706ac98da23f673af6c0d4631c4d194a677a9a1a07d7219fa0f

RUN set -x \
  && apt-get update \

  && echo "Dependencies" \
  && apt-get install -y \
          git \
          curl \
          gettext-base \

  && echo "AWS-cli" \
  && apt-get install -y \
          python \
          python-pip \
  && pip install awscli \
  && apt-get remove -y python-pip \

  && echo "docker-registry-login" \
  && git clone --branch 0.0.2 https://github.com/loicmahieu/docker-registry-login.git \
  && cd docker-registry-login \
  && ./install.sh /usr/local \
  && rm -rf docker-registry-login \

  && echo "Docker client" \
	&& curl -fSL "https://${DOCKER_BUCKET}/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz" -o docker.tgz \
	&& echo "${DOCKER_SHA256} *docker.tgz" | sha256sum -c - \
	&& tar -xzvf docker.tgz \
	&& mv docker/* /usr/local/bin/ \
	&& rmdir docker \
	&& rm docker.tgz \
	&& docker -v

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["sh"]
