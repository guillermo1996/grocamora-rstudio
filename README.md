# RytenLab RStudio Docker Image

This Docker container provides a pre-configured, reproducible R enviroment. It is based on the official [Rocker Project rocker/rstudio](https://rocker-project.org/) image and on the [Bioconductor bioconductor_docker](https://bioconductor.org/help/docker/) image, and supports running the latests versions of R. It is specifically tailored to work on the RytenLab server.

## Run the Container



## Features

+ Based on Rocker's rstudio image, with Bioconductor's image additions. It supports of all the features provided by this images (e.g. custom user/password, root access, etc.).
+ Supports any desired version of R and RStudio server via the `R_VERSION` and `RSTUDIO_VERSION` environment variables.
+ The RStudio Server comes pre-installed and pre-configured.
+ Easily extensible with custom R or system packages.
+ Optimized for volume sharing between host and container with the goal of keeping paths consistent across enviroments.

### File Sharing & Persistence

A design goal of this container is path consistency between the host and the container. For example:

> Host user: `grocamora`
> Project path: `/home/grocamora/RytenLab-Research`

The container ensures that this same path exists withing the Docker session, enabling absolute file reference like:

```r
source("/home/grocamora/RytenLab-Research/script.R")
```

When launching the container, bind the project path from the host into the exact same path in the container:

```r
docker run --rm -it \
  -e PASSWORD=yourpassword \
  -v /home/grocamora/RytenLab-Research:/home/grocamora/RytenLab-Research \
  -p 8787:8787 \
  grocamora-rstudio:latest
```

This ensures that R scripts referencing absolute paths remain valid in any context.

 
### Volume Mapping 

### Dockerfile Overview

## Docker Compose Example

## Resources and Attribution


This repository contains the docker image to run R v4.3.2 on the RytenLab server.

docker run -it --name grocamora-rstudio-v1.3 -p 8917:8787 -e ROOT=TRUE -e PASSWORD=bioc -e DISABLE_AUTH=true -e USERID=1027 -e GROUPID=1028 -v /home/grocamora:/home/grocamora lorddifre/grocamora-rstudio:1.4