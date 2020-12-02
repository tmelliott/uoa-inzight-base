# ---------------------------------------------
#
# Dockerfile best practices
# Refer: http://docs.docker.com/engine/articles/dockerfile_best-practices/
#
# This file makes use of contributions from Rafal Szkup, Application Engineer, UoA
# and the iNZight Team, UoA
#
# ---------------------------------------------

# start with a light-weight base image
FROM debian:jessie

LABEL maintainer="inzightlite_support@stat.auckland.ac.nz"
LABEL nz.inzight="iNZight"

ENV BUILD_DATE "2020-12-03"

# Add the CRAN PPA to get all versions of R and install base R and required packages
# install shiny server and clean up all downloaded files to make sure the image remains lean as much as possible
# NOTE: we group a lot of commands together to reduce the number of layers that Docker creates in building this image

COPY shiny-server.sh /opt/

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FCAE2A0E115C3D8A \
    && echo "deb http://cran.stat.auckland.ac.nz/bin/linux/debian jessie-cran34/" | tee -a /etc/apt/sources.list.d/R.list \
    && apt-get update \
    && apt-get install -y -q \
        r-base-core \
        libssl-dev \
        libssl1.0.0 \
        libxml2-dev \
        libcairo2-dev \
        libxt-dev \
        locales \
        sudo \
        wget \
    && wget --no-verbose -O libssl.deb https://mirrors.mediatemple.net/debian-archive/debian/pool/main/o/openssl/libssl0.9.8_0.9.8o-4squeeze14_amd64.deb \
    && dpkg -i libssl.deb \
    && rm -f libssl.deb \
    && R -e "install.packages('rmarkdown', dependencies = TRUE, repos='http://cran.rstudio.com/', lib='/usr/lib/R/site-library')" \
    && R -e "install.packages('shiny', dependencies = TRUE, repos='http://cran.rstudio.com/', lib='/usr/lib/R/site-library')" \
    && R -e "install.packages('DT', dependencies = TRUE, repos='http://cran.rstudio.com/', lib='/usr/lib/R/site-library')" \
    && wget --no-verbose -O shiny-server.deb https://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.5.6.875-amd64.deb \
    && dpkg -i shiny-server.deb \
    && chmod +x /opt/shiny-server.sh \
    && rm -f shiny-server.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# fix locale settings:
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
	&& locale-gen en_US.utf8 \
	&& /usr/sbin/update-locale LANG=en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

# expose ports
EXPOSE 3838

# we do NOT initiate any process - treat this image as abstract class equivalent
