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
FROM debian:buster 

MAINTAINER "Science IS Team" ws@sit.auckland.ac.nz

ENV BUILD_DATE "2020-04-30"

# Add the CRAN PPA to get all versions of R and install base R and required packages
# install shiny server and clean up all downloaded files to make sure the image remains lean as much as possible
# NOTE: we group a lot of commands together to reduce the number of layers that Docker creates in building this image

RUN apt-get update && apt-get install -y gnupg2\
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FCAE2A0E115C3D8A \
    && echo "deb http://cloud.r-project.org/bin/linux/debian buster-cran40/" | tee -a /etc/apt/sources.list.d/R.list \
    && apt-get update \
    && apt-get install -y -q \
        -t buster-cran40 r-base\
        build-essential\
        libssl-dev \
        libssl1.1 \
        lsb-release \
        libxml2-dev\ 
        libssh-4 libssh-dev \
        libcurl4-openssl-dev\
        sudo \
        wget \
    && R -e "install.packages(c('rmarkdown', 'shiny', 'DT'), repos='http://cran.rstudio.com/', lib='/usr/lib/R/site-library')" \
    && rm -rf /tmp/* /var/tmp/*


