FROM ubuntu:focal

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/guillermo1996/grocamora-rstudio" \
      org.opencontainers.image.vendor="RStudio for RytenLab Research" \
      org.opencontainers.image.authors="Guillermo Rocamora Pérez <guillermorocamora@gmail.com"

################################################################################
# Install r-base

## Set Enviroment variables
ENV R_VERSION=4.5.0
ENV R_HOME=/usr/local/lib/R
ENV TZ="Etc/UTC"
ENV LANG=en_GB.UTF-8

## Run R installation script
COPY install_R.sh /.
RUN ./install_R.sh

################################################################################
# Install R-Studio

## Set Enviroment variables
ENV S6_VERSION=v2.1.0.2
ENV RSTUDIO_VERSION=2025.05.0+496 
ENV DEFAULT_USER=rstudio
ENV PANDOC_VERSION=default
ENV QUARTO_VERSION=default
ENV NCPUS=12
ENV OMP_NUM_THREADS=1

## Set up R, install RStudio and other relevant packages
COPY rocker_scripts /rocker_scripts
RUN rocker_scripts/setup_R.sh

RUN rocker_scripts/install_rstudio.sh
RUN rocker_scripts/install_pandoc.sh
RUN rocker_scripts/install_quarto.sh
RUN rocker_scripts/install_tidyverse.sh

################################################################################
# Install BiocManager

## Set Enviroment variables
ENV BIOCONDUCTOR_VERSION=3.22

## Run BiocManager installation script
COPY bioc_scripts /bioc_scripts
RUN bash /bioc_scripts/install_bioc_sysdeps.sh $BIOCONDUCTOR_VERSION \
    && echo "R_LIBS=/usr/local/lib/R/host-site-library:\${R_LIBS}" > /usr/local/lib/R/etc/Renviron.site \
    && curl -OL http://bioconductor.org/checkResults/devel/bioc-LATEST/Renviron.bioc \
    && sed -i '/^IS_BIOC_BUILD_MACHINE/d' Renviron.bioc \
    && cat Renviron.bioc | grep -o '^[^#]*' | sed 's/export //g' >>/etc/environment \
    && cat Renviron.bioc >> /usr/local/lib/R/etc/Renviron.site \
    && echo BIOCONDUCTOR_VERSION=${BIOCONDUCTOR_VERSION} >> /usr/local/lib/R/etc/Renviron.site \
    && echo BIOCONDUCTOR_DOCKER_VERSION=${BIOCONDUCTOR_DOCKER_VERSION} >> /usr/local/lib/R/etc/Renviron.site \
    && echo 'LIBSBML_CFLAGS="-I/usr/include"' >> /usr/local/lib/R/etc/Renviron.site \
    && echo 'LIBSBML_LIBS="-lsbml"' >> /usr/local/lib/R/etc/Renviron.site \
    && rm -rf Renviron.bioc

## Set additional env variables
ENV LIBSBML_CFLAGS="-I/usr/include"
ENV LIBSBML_LIBS="-lsbml"

################################################################################
# Install other packages & configuration

## Install basic packages
COPY /custom_scripts/install_basic_packages.sh /custom_scripts/install_basic_packages.sh
RUN /custom_scripts/install_basic_packages.sh

## Install custom packages
COPY /custom_scripts/install_custom_packages.sh /custom_scripts/install_custom_packages.sh
RUN /custom_scripts/install_custom_packages.sh

## Install relevant software
ENV SAMTOOLS_VERSION=1.21
ENV REGTOOLS_VERSION=1.0.0
ENV BEDTOOLS_VERSION=2.31.0

COPY /custom_scripts/install_other_software.sh /custom_scripts/install_other_software.sh
RUN /custom_scripts/install_other_software.sh

## Install Leafcutter
COPY /custom_scripts/install_leafcutter.sh /custom_scripts/install_leafcutter.sh
RUN /custom_scripts/install_leafcutter.sh

## Add custom configurations
COPY rstudio_config /rstudio_config
COPY /custom_scripts/custom_configuration.sh /custom_scripts/custom_configuration.sh 
RUN /custom_scripts/custom_configuration.sh

## Add Copilot to RStudio server - Use at your own risk
RUN echo "copilot-enabled=1" >> /etc/rstudio/rsession.conf

################################################################################
# Init command
EXPOSE 8787
CMD ["/init"]