#!/bin/bash

set -e

NCPUS=${NCPUS:--1}

# Custom packages
R -q -e 'devtools::install_github("https://github.com/guillermo1996/grpSciRmdTheme", Ncpus = '$NCPUS')'
R -q -e 'install.packages("datapasta", repos = c(mm = "https://milesmcbain.r-universe.dev", getOption("repos")), Ncpus = '$NCPUS')'
R -q -e 'devtools::install_github("juanbot/G2PML", Ncpus = '$NCPUS')'
R -q -e 'devtools::install_github("haozhu233/kableExtra", Ncpus = '$NCPUS')'
R -q -e 'devtools::install_github("jennybc/jadd")'
R -q -e 'devtools::install_github("dzhang32/ggtranscript")'

# Custom BiocParallel packages
R -q -e 'BiocManager::install("guillermo1996/dasper", Ncpus = '$NCPUS')'
R -q -e 'devtools::install_github("DiseaseNeuroGenomics/variancePartition", Ncpus = '$NCPUS')'
R -q -e 'devtools::install_github("DiseaseNeurogenomics/crumblr", Ncpus = '$NCPUS')'
R -q -e 'devtools::install_github("hms-dbmi/UpSetR", Ncpus = '$NCPUS')'