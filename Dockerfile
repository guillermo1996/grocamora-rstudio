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

# Bioconductor installation (dasper not supported above 3.17)
ENV BIOCONDUCTOR_VERSION=3.17  

COPY bioc_scripts /bioc_scripts
RUN /bioc_scripts/install_bioc_sysdeps.sh $BIOCONDUCTOR_VERSION

## Variables in Renviron.site are made available inside of R.
## Add libsbml CFLAGS
RUN  echo BIOCONDUCTOR_VERSION=${BIOCONDUCTOR_VERSION} >> /usr/local/lib/R/etc/Renviron.site \
    && echo 'LIBSBML_CFLAGS="-I/usr/include"' >> /usr/local/lib/R/etc/Renviron.site \
    && echo 'LIBSBML_LIBS="-lsbml"' >> /usr/local/lib/R/etc/Renviron.site

ENV LIBSBML_CFLAGS="-I/usr/include"
ENV LIBSBML_LIBS="-lsbml"

# Custom installation
COPY custom_scripts /custom_scripts
RUN /custom_scripts/install_packages.sh

## Init command for s6-overlay
CMD ["/init"]