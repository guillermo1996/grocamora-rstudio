#!/bin/bash

set -e

NCPUS=${NCPUS:--1}

# Leafcutter packages
install2.r --error --skipinstalled -n "$NCPUS" \
    RcppParallel \
    inline \
    loo

## To install leafcutter, we need old versions of the packages "StanHeaders" and "rstan". We cannot update any of these packages, or the installation would fail.
R -q -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/StanHeaders/StanHeaders_2.21.0-7.tar.gz", source = T, Ncpus = '$NCPUS')'
R -q -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/rstan/rstan_2.21.7.tar.gz", source = T, Ncpus = '$NCPUS')'
R -q -e 'BiocManager::install("DirichletMultinomial", Ncpus = '$NCPUS')'
R -q -e 'devtools::install_github("davidaknowles/leafcutter/leafcutter", upgrade = "never", Ncpus = '$NCPUS')'