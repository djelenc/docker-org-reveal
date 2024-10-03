FROM debian:bookworm-slim
LABEL maintainer="djelenc@gmail.com"

ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=en_US.UTF-8
ENV LANG=${LC_ALL}
ENV LANGUAGE=${LC_ALL}
ENV workdir=/slides
ENV reveal_url=https://github.com/hakimel/reveal.js/archive/master.zip

RUN mkdir -p ${workdir}

WORKDIR ${workdir}

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

RUN echo "#log: Setting up emacs" \
 && emacs \
      --no-init-file  \
      --user="" \
      --batch \
      --eval="(require 'package)" \
      --eval="(add-to-list 'package-archives '(\"melpa\" . \"https://melpa.org/packages/\"))" \
      --eval='(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")' \
      --eval="(package-initialize)" \
      --eval="(package-show-package-list)" \
      --eval="(package-refresh-contents)" \
      --eval="(package-list-packages)" \
      --eval="(package-install 'org)" \
      --eval="(package-install 'htmlize)" \
      --eval="(package-install 'ox-reveal)" \
 && sync

RUN echo "#log: Setting up reveal.js" \
 && wget -O- ${reveal_url} > reveal.js.zip \
 && unzip reveal.js.zip \
 && mv reveal.js-master /reveal.js \
 && rm -f reveal.js.zip

ADD org2html.sh /usr/bin/org2html
ADD org-reveal2html.sh /usr/bin/org-reveal2html

