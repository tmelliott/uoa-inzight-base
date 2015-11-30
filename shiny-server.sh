#!/bin/bash

# -------------------------------------------------
# To overcome pretty annoying "no such file or directory" error
#
# http://kimh.github.io/blog/en/docker/gotchas-in-writing-dockerfile-en/
#
# -------------------------------------------------

touch /var/log/shiny-server.log
chown shiny:shiny /var/log/shiny-server.log

# run shiny server
sudo -u shiny shiny-server >> /var/log/shiny-server.log 2>&1

