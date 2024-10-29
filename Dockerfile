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
## Enviroment variables
ENV S6_VERSION=v2.1.0.2
ENV RSTUDIO_VERSION=2024.09.0+375
ENV DEFAULT_USER=rstudio
ENV PANDOC_VERSION=default
ENV QUARTO_VERSION=default
ENV NCPUS=12
ENV OMP_NUM_THREADS=1

## Setup R, install RStudio and other relevant packages
COPY rocker_scripts /rocker_scripts
RUN rocker_scripts/setup_R.sh

RUN /rocker_scripts/install_rstudio.sh 
RUN /rocker_scripts/install_pandoc.sh
RUN /rocker_scripts/install_quarto.sh
RUN /rocker_scripts/install_tidyverse.sh

# Bioconductor installation
## Set Bioc version (dasper not supported above 3.17)
ENV BIOCONDUCTOR_VERSION=3.18

## Install BiocManager
COPY bioc_scripts /bioc_scripts
RUN /bioc_scripts/install_bioc_sysdeps.sh $BIOCONDUCTOR_VERSION

## Variables in Renviron.site are made available inside of R.
## Add libsbml CFLAGS
RUN  echo BIOCONDUCTOR_VERSION=${BIOCONDUCTOR_VERSION} >> /usr/local/lib/R/etc/Renviron.site \
    && echo 'LIBSBML_CFLAGS="-I/usr/include"' >> /usr/local/lib/R/etc/Renviron.site \
    && echo 'LIBSBML_LIBS="-lsbml"' >> /usr/local/lib/R/etc/Renviron.site
ENV LIBSBML_CFLAGS="-I/usr/include"
ENV LIBSBML_LIBS="-lsbml"

# Custom installations
## Install custom packages to get a complete R version
COPY /custom_scripts/install_basic_packages.sh /custom_scripts/install_basic_packages.sh
RUN /custom_scripts/install_basic_packages.sh

COPY /custom_scripts/install_custom_packages.sh /custom_scripts/install_custom_packages.sh
RUN /custom_scripts/install_custom_packages.sh

COPY /custom_scripts/install_beta_packages.sh /custom_scripts/install_beta_packages.sh
RUN /custom_scripts/install_beta_packages.sh

## Instal custom programs
ENV SAMTOOLS_VERSION=1.17
ENV REGTOOLS_VERSION=1.0.0
ENV BEDTOOLS_VERSION=2.31.0

COPY /custom_scripts/install_programs.sh /custom_scripts/install_programs.sh
RUN /custom_scripts/install_programs.sh

### Install leafcutter
COPY /custom_scripts/install_leafcutter.sh /custom_scripts/install_leafcutter.sh
RUN /custom_scripts/install_leafcutter.sh

## Add custom configurations
COPY rstudio_config /rstudio_config
COPY /custom_scripts/custom_configuration.sh /custom_scripts/custom_configuration.sh 
RUN /custom_scripts/custom_configuration.sh

## Init command for s6-overlay
EXPOSE 8787
CMD ["/init"]