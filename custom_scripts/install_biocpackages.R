BiocManager::install(c('dasper', 'rtracklayer'))
BiocManager::install(c("DESeq2", "DEGreport", "tximport", "pcaExplorer"))

devtools::install_github('mskilab/gUtils')
install.packages("datapasta", repos = c(mm = "https://milesmcbain.r-universe.dev", getOption("repos")))