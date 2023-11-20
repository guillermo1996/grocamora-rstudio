#!/bin/bash

set -e

NCPUS=${NCPUS:--1}

install2.r --error --skipinstalled -n "$NCPUS" \
    logger \
    foreach \
    doSNOW \
    bookdown \
    DT \
    kableExtra \
    patchwork \
    latex2exp \
    ggforce \
    ggh4x \
    viridis \
    ggnewscale \
    doParallel \
    openxlsx \
    rmarkdown \
    markdown \
    coin \
    roxygen2 \
    ggsci \
    gridExtra \
    zeallot

# Custom packages
R -q -e 'devtools::install_github("https://github.com/guillermo1996/grpSciRmdTheme")'
R -q -e 'install.packages("datapasta", repos = c(mm = "https://milesmcbain.r-universe.dev", getOption("repos")))'

# Custom BiocParallel packages
R -q -e 'BiocManager::install(c("dasper", "rtracklayer", "DESeq2", "DEGreport", "tximport", "pcaExplorer", "sva", "limma", "edgeR", "DESeq2"))'