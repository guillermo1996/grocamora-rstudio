FROM ubuntu:focal

# Image Label
LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/guillermo1996/grocamora-rstudio" \
      org.opencontainers.image.vendor="RStudio for RytenLab Research" \
      org.opencontainers.image.authors="Guillermo Rocamora Pérez <guillermorocamora@gmail.com"

# Enviroment variables
ENV R_VERSION=4.3.2
ENV R_HOME=/usr/local/lib/R

# Install R
COPY install_R.sh /.
RUN ./install_R.sh

# RStudio installation
ENV S6_VERSION=v2.1.0.2
ENV RSTUDIO_VERSION=2023.09.1+494
ENV DEFAULT_USER=rstudio
ENV PANDOC_VERSION=default
ENV QUARTO_VERSION=default
ENV NCPUS=12

COPY rocker_scripts /rocker_scripts
RUN /rocker_scripts/setup_R.sh

RUN /rocker_scripts/install_rstudio.sh
RUN /rocker_scripts/install_pandoc.sh
RUN /rocker_scripts/install_quarto.sh
RUN /rocker_scripts/install_tidyverse.sh

EXPOSE 8787

# Bioconductor installation
ENV BIOCONDUCTOR_VERSION=3.18 

COPY bioc_scripts /bioc_scripts
RUN /bioc_scripts/install_bioc_sysdeps.sh $BIOCONDUCTOR_VERSION

# Custom installation


## Init command for s6-overlay
# CMD ["/init"]