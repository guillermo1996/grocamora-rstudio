# RStudio Server Docker image for the RytenLab server

This repository contains the docker image to run R v4.3.2 on the RytenLab server.

docker run -it --name grocamora-rstudio-v1.3 -p 8917:8787 -e ROOT=TRUE -e PASSWORD=bioc -e DISABLE_AUTH=true -e USERID=1027 -e GROUPID=1028 -v /home/grocamora:/home/grocamora lorddifre/grocamora-rstudio:1.4