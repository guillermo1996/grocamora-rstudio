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
    randomForest \
    compositions \
    rcompanion
    
R -q -e 'BiocManager::install(c("rtracklayer", "DESeq2", "DEGreport", "tximport", "pcaExplorer", "sva", "limma", "edgeR", "DESeq2", "ggtree"), Ncpus = '$NCPUS')'
R -q -e 'BiocManager::install(c("AnnotationHub", "Mus.musculus", "rrvgo", "SingleCellExperiment", "clusterProfiler", "EnsDb.Hsapiens.v86", "org.Hs.eg.db", "org.Mm.eg.db", "DirichletMultinomial", "fgsea", "KEGGgraph", "GenomicState", "recount"), Ncpus = '$NCPUS')'