FROM debian:bookworm-slim
MAINTAINER djelenc@gmail.com

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL en_US.UTF-8
ENV LANG ${LC_ALL}
ENV LANGUAGE ${LC_ALL}
ENV workdir /slides/

WORKDIR ${workdir}

ADD Makefile ${workdir}/

RUN echo "#log: Configuring locales" \
 && set -x \
 && apt-get update \
 && apt-get install -y locales \
 && echo "${LC_ALL} UTF-8" | tee /etc/locale.gen \
 && locale-gen ${LC_ALL} \
 && dpkg-reconfigure locales \
 && sync

RUN echo "#log: Preparing system" \
 && set -x \
 && apt-get update -y \
 && apt-get install -y \
  make \
  sudo \
  emacs \
  wget \
  git \
  unzip \
 && sync

RUN mkdir -p /slides

RUN echo "#log: Setup project" \
 && set -x \
 && make setup/debian sudo="" \
 && make setup \
 && make download \
 && sync

CMD ["make", "all"]

# create org-reveal img
# push it to dockerhub
# then pull it from DH in GL-ci
# co project
# build project
# deploy / save artefacts
