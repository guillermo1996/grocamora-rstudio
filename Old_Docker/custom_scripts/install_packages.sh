#!/bin/bash

set -e

## build ARGs
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
    knitr \
    rmarkdown \
    markdown \
    coin \
    roxygen2 \
    ggsci