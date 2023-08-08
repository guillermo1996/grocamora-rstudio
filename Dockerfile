FROM bioconductor/bioconductor_docker:RELEASE_3_16-R-4.2.3

# Install HTOP
RUN apt-get update \
    && apt-get -y install htop nano

# Install other tools
RUN mkdir /tools \
    && git clone https://github.com/eddelbuettel/littler.git tools/littler/
ENV PATH="$PATH:/tools/littler/inst/examples"

RUN cd /tools \
    && wget https://github.com/samtools/samtools/releases/download/1.17/samtools-1.17.tar.bz2 \
    && tar -xjf samtools-1.17.tar.bz2 && rm samtools-1.17.tar.bz2 && cd samtools-1.17 \
    && ./configure && make && make install \
    && cd /

RUN cd /tools \
    && git clone https://github.com/griffithlab/regtools \
    && cd regtools/ \
    && mkdir build && cd build/ \
    && cmake .. && make \
    && cd /
ENV PATH="$PATH:/tools/regtools/build"

RUN cd /tools \
    && mkdir bedtools && cd bedtools \
    && wget https://github.com/arq5x/bedtools2/releases/download/v2.31.0/bedtools.static \
    && mv bedtools.static bedtools && chmod a+x bedtools \
    && cd /
ENV PATH="$PATH:/tools/bedtools"

RUN wget http://hollywood.mit.edu/burgelab/maxent/download/fordownload.tar.gz \
    && tar -xf fordownload.tar.gz && rm fordownload.tar.gz
    
# Install tesseract-OCR
RUN apt-get -y install tesseract-ocr \
    && apt-get -y install libtesseract-dev \
    && pip3 install pytesseract \
    && pip3 install pymupdf pytest fontTools

# Sync with grocamora
#RUN mkdir /home/grocamora \
#    && ln -s /home/grocamora /home/rstudio/grocamora

# Install most relevant R packages
RUN install.r tidyverse logger foreach doSNOW bookdown DT kableExtra patchwork \
    && install.r latex2exp ggforce ggh4x viridis ggnewscale doParallel openxlsx \
    && install.r knitr rmarkdown markdown coin roxygen2
RUN install.r ggsci 

# Install most relevant R bioconductor packages
RUN Rscript -e 'BiocManager::install()'
RUN Rscript -e 'BiocManager::install("dasper")'

# Rstudio configuration
#COPY rstudio_config /home/rstudio/.config/rstudio
#COPY fix_uid_server.sh /.
