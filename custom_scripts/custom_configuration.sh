#!/bin/bash

set -e

## Fix OPENBLAS configuration not being properly loaded into RStudio-serer:
### https://r-sig-debian.r-project.narkive.com/CVMkK7HQ/r-openblas-and-omp-num-threeads
### https://github.com/rstudio/rstudio/issues/10641
### https://github.com/rstudio/rstudio/issues/9969
echo "local({if(require("RhpcBLASctl", quietly=TRUE)){blas_set_num_threads(${OMP_NUM_THREADS})}})" >> ${R_HOME}/etc/Rprofile.site