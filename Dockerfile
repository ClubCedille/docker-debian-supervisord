FROM debian:jessie
MAINTAINER Michael Faille <michael@faille.io>

ENV LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive HOME=/root

RUN apt-get update && apt-get install -q -y --no-install-recommends locales && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN dpkg-reconfigure locales && locale-gen C.UTF-8 && /usr/sbin/update-locale LANG=C.UTF-8
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen

RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https ca-certificates netcat iproute net-tools \
    vim-nox bash-completion curl supervisor gettext-base && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -o /usr/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.9/gosu-amd64" && chmod +x /usr/bin/gosu
RUN /bin/echo -ne 'set nocompatible\nset backspace=eol,start,indent\nsyntax on\nfiletype indent on\nset autoindent\ncolorscheme desert\nset nobackup\nnnoremap ; :\n\n' > /etc/vim/vimrc.local

ADD supervisor-default.conf /etc/supervisor/conf.d/default.conf

CMD ["/bin/sh", "-c", "/usr/bin/supervisord -n"]

# RUN curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v1.18.1.3/s6-overlay-amd64.tar.gz" | tar zxf - -C /

# volume ["/run"]

# ENTRYPOINT ["/init"]
# CMD ["/bin/bash","-l"]
