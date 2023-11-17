FROM ubuntu:focal

# Main R installation

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/rocker-org/rocker-versioned2" \
      org.opencontainers.image.vendor="Rocker Project" \
      org.opencontainers.image.authors="Carl Boettiger <cboettig@ropensci.org>"

ENV R_VERSION=4.2.1
ENV R_HOME=/usr/local/lib/R
ENV TZ=Etc/UTC

COPY rocker_scripts /rocker_scripts

RUN /rocker_scripts/install_R_source.sh

ENV CRAN=https://cran.rstudio.com
ENV LANG=en_US.UTF-8

RUN /rocker_scripts/setup_R.sh

# Main RStudio installation

ENV S6_VERSION=v2.1.0.2
ENV RSTUDIO_VERSION=2023.06.1+524
ENV DEFAULT_USER=rstudio
ENV PANDOC_VERSION=default
ENV QUARTO_VERSION=default

RUN /rocker_scripts/install_rstudio.sh
RUN /rocker_scripts/install_pandoc.sh
RUN /rocker_scripts/install_quarto.sh
RUN /rocker_scripts/install_tidyverse.sh

EXPOSE 8787

# Main Bioconductor installation
ARG BIOCONDUCTOR_VERSION=3.15
ARG BIOCONDUCTOR_PATCH=27
ARG BIOCONDUCTOR_DOCKER_VERSION=${BIOCONDUCTOR_VERSION}.${BIOCONDUCTOR_PATCH}

##  Add Bioconductor system dependencies
COPY bioc_scripts /bioc_scripts
RUN /bioc_scripts/install_bioc_sysdeps.sh
RUN echo "R_LIBS=/usr/local/lib/R/host-site-library:\${R_LIBS}" > /usr/local/lib/R/etc/Renviron.site
RUN R -f /bioc_scripts/install.R

## Variables in Renviron.site are made available inside of R.
## Add libsbml CFLAGS
RUN  echo BIOCONDUCTOR_VERSION=${BIOCONDUCTOR_VERSION} >> /usr/local/lib/R/etc/Renviron.site \
    && echo BIOCONDUCTOR_DOCKER_VERSION=${BIOCONDUCTOR_DOCKER_VERSION} >> /usr/local/lib/R/etc/Renviron.site \
    && echo 'LIBSBML_CFLAGS="-I/usr/include"' >> /usr/local/lib/R/etc/Renviron.site \
    && echo 'LIBSBML_LIBS="-lsbml"' >> /usr/local/lib/R/etc/Renviron.site

ENV LIBSBML_CFLAGS="-I/usr/include"
ENV LIBSBML_LIBS="-lsbml"
ENV BIOCONDUCTOR_DOCKER_VERSION=$BIOCONDUCTOR_DOCKER_VERSION
ENV BIOCONDUCTOR_VERSION=$BIOCONDUCTOR_VERSION

# Main Custom installation
## Install HTOP
RUN apt-get update \
    && apt-get -y install htop nano 

## Install other tools
RUN mkdir /tools \
    && git clone https://github.com/eddelbuettel/littler.git tools/littler/
ENV PATH="$PATH:/tools/littler/inst/examples"

RUN cd /tools \
    && wget https://github.com/samtools/samtools/releases/download/1.17/samtools-1.17.tar.bz2 \
    && tar -xjf samtools-1.17.tar.bz2 && rm samtools-1.17.tar.bz2 && cd samtools-1.17 \
    && ./configure && make && make install \
    && cd /

RUN cd /tools \
    && git clone https://github.com/griffithlab/regtools \
    && cd regtools/ \
    && mkdir build && cd build/ \
    && cmake .. && make \
    && cd /
ENV PATH="$PATH:/tools/regtools/build"

RUN cd /tools \
    && mkdir bedtools && cd bedtools \
    && wget https://github.com/arq5x/bedtools2/releases/download/v2.31.0/bedtools.static \
    && mv bedtools.static bedtools && chmod a+x bedtools \
    && cd /
ENV PATH="$PATH:/tools/bedtools"

RUN wget http://hollywood.mit.edu/burgelab/maxent/download/fordownload.tar.gz \
    && tar -xf fordownload.tar.gz && rm fordownload.tar.gz
    
## Install tesseract-OCR
RUN apt-get -y install tesseract-ocr \
    && apt-get -y install libtesseract-dev \
    && pip3 install pytesseract \
    && pip3 install pymupdf pytest fontTools

## Install custom packages
COPY custom_scripts /custom_scripts
RUN bash /custom_scripts/install_packages.sh
RUN R -f /custom_scripts/install_biocpackages.R

## Init command for s6-overlay
CMD ["/init"]