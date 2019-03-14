
FROM alpine:3.9

RUN apk --update add \
  less \
  bash \
  curl \
  git \
  openssh \
  jq \
  ca-certificates

ENTRYPOINT ["/bin/bash", "-c"]
