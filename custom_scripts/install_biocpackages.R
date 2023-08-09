BiocManager::install(c('dasper', 'rtracklayer'))
BiocManager::install(c("DESeq2", "DEGreport", "tximport", "pcaExplorer"))

devtools::install_github('mskilab/gUtils')

new_packages <- BiocManager::valid()
BiocManager::install(rownames(new_packages$too_new), update = TRUE, ask = FALSE, force = T)
BiocManager::install(update = TRUE, ask = FALSE)
install.packages("datapasta", repos = c(mm = "https://milesmcbain.r-universe.dev", getOption("repos")))