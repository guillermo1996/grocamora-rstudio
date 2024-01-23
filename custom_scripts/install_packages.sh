#!/bin/bash

set -e

NCPUS=${NCPUS:--1}

install2.r --error --skipinstalled -n "$NCPUS" \
    logger \
    foreach \
    doSNOW \
    bookdown \
    DT \
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
    zeallot \
    caret \
    Hmisc \
    factoextra \
    janitor \
    optparse \
    RhpcBLASctl \
    DGEobj.utils \
    styler

# Custom packages
R -q -e 'devtools::install_github("https://github.com/guillermo1996/grpSciRmdTheme")'
R -q -e 'install.packages("datapasta", repos = c(mm = "https://milesmcbain.r-universe.dev", getOption("repos")))'
R -q -e 'devtools::install_github("kupietz/kableExtra")'

# Custom BiocParallel packages
R -q -e 'BiocManager::install(c("rtracklayer", "DESeq2", "DEGreport", "tximport", "pcaExplorer", "sva", "limma", "edgeR", "DESeq2"))'
R -q -e 'BiocManager::install("guillermo1996/dasper")'
R -q -e 'BiocManager::install(c("variancePartition"))'