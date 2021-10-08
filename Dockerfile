FROM ubuntu

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
	&& apt-get update \
	&& apt-get upgrade -y

RUN apt-get install -y \
		curl \
		locales \
		fonts-noto-color-emoji \
		libsecret-1-0 \
		pulseaudio \
		wget \
	&& curl -L "https://teams.microsoft.com/downloads/desktopurl?env=production&plat=linux&arch=x64&download=true&linuxArchiveType=deb" > /tmp/teams.deb \
	&& apt-get install -y /tmp/teams.deb \
	&& rm /tmp/teams.deb

COPY xdg-open /usr/local/bin/

ENV TZ Pacific/Tahiti

COPY ./environment /etc/environment
COPY ./locale.gen /etc/locale.gen

RUN echo "$TZ" > /etc/timezone \
    && rm -f /etc/localtime \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && locale-gen fr_FR.UTF-8 \
    && dpkg-reconfigure locales

ENV LANG fr_FR:UTF-8
ENV LANGUAGE fr
ENV LC_CTYPE fr_FR.utf8
ENV LC_MESSAGES fr_FR.utf8
ENV LC_ALL fr_FR.utf8

CMD /usr/share/teams/teams
