#!/bin/bash

set -e

## Fix OPENBLAS configuration not being properly loaded into RStudio-serer:
### https://r-sig-debian.r-project.narkive.com/CVMkK7HQ/r-openblas-and-omp-num-threeads
### https://github.com/rstudio/rstudio/issues/10641
### https://github.com/rstudio/rstudio/issues/9969
echo "local({if(require("RhpcBLASctl", quietly=TRUE)){blas_set_num_threads(${OMP_NUM_THREADS})}})" >> ${R_HOME}/etc/Rprofile.site
echo "local({suppressPackageStartupMessages(suppressWarnings(library(tcltk)))})" >> ${R_HOME}/etc/Rprofile.site

## Add predefined configuration to rstudio
mv /rstudio_config/* /home/${DEFAULT_USER}/.config/rstudio/
rm -rf /rstudio_config
chown -R "${DEFAULT_USER}:${DEFAULT_USER}" "/home/${DEFAULT_USER}"

## Add user dictionary to RStudio
mkdir -p /home/${DEFAULT_USER}/.local/share/rstudio/monitored/lists/
cp /home/${DEFAULT_USER}/.config/rstudio/user_dictionary /home/${DEFAULT_USER}/.local/share/rstudio/monitored/lists/
chown -R "${DEFAULT_USER}:${DEFAULT_USER}" "/home/${DEFAULT_USER}/.local"