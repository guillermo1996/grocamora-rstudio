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
    styler \
    bookdown \
    ggbreak \
    ggExtra \
    ggVennDiagram \
    glmnet \
    latticeExtra \
    randomForest 