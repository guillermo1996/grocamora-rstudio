#!/bin/bash

set -e

NCPUS=${NCPUS:--1}

# Custom packages
R -q -e 'devtools::install_github("https://github.com/guillermo1996/grpSciRmdTheme", Ncpus = '$NCPUS')'
R -q -e 'install.packages("datapasta", repos = c(mm = "https://milesmcbain.r-universe.dev", getOption("repos")), Ncpus = '$NCPUS')'
R -q -e 'devtools::install_github("juanbot/G2PML", Ncpus = '$NCPUS')'
R -q -e 'devtools::install_github("haozhu233/kableExtra", Ncpus = '$NCPUS')'


# Custom BiocParallel packages
R -q -e 'BiocManager::install(c("rtracklayer", "DESeq2", "DEGreport", "tximport", "pcaExplorer", "sva", "limma", "edgeR", "DESeq2", "ggtree"), Ncpus = '$NCPUS')'
R -q -e 'BiocManager::install(c("AnnotationHub", "Mus.musculus", "rrvgo", "SingleCellExperiment", "clusterProfiler", "EnsDb.Hsapiens.v86", "org.Hs.eg.db", "org.Mm.eg.db", "DirichletMultinomial", "fgsea", "KEGGgraph", "GenomicState", "recount"), Ncpus = '$NCPUS')'
R -q -e 'BiocManager::install("guillermo1996/dasper", Ncpus = '$NCPUS')'
R -q -e 'devtools::install_github("DiseaseNeuroGenomics/variancePartition", Ncpus = '$NCPUS')'
R -q -e 'devtools::install_github("DiseaseNeurogenomics/crumblr", Ncpus = '$NCPUS')'