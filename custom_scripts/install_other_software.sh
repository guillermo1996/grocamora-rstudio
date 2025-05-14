#!/bin/bash

set -ex
apt-get update

# Install samtools
mkdir /tools
cd /tools
wget -q "https://github.com/samtools/samtools/releases/download/${SAMTOOLS_VERSION}/samtools-${SAMTOOLS_VERSION}.tar.bz2"
tar -xjf "samtools-${SAMTOOLS_VERSION}.tar.bz2"
rm "samtools-${SAMTOOLS_VERSION}.tar.bz2"
cd "samtools-${SAMTOOLS_VERSION}"
./configure
make
make install
cd /

# Install regtools
cd /tools
wget -q "https://github.com/griffithlab/regtools/archive/refs/tags/${REGTOOLS_VERSION}.tar.gz"
tar -xf "${REGTOOLS_VERSION}.tar.gz"
rm "${REGTOOLS_VERSION}.tar.gz"
cd "regtools-${REGTOOLS_VERSION}"
mkdir build
cd build/
cmake ..
make
cd /

# Install bedtools
cd /tools
mkdir bedtools
cd bedtools
wget -q "https://github.com/arq5x/bedtools2/releases/download/v${BEDTOOLS_VERSION}/bedtools.static"
mv bedtools.static bedtools
chmod a+x bedtools
cd /

# # Fordownload
# cd /tools
# wget -q "http://hollywood.mit.edu/burgelab/maxent/download/fordownload.tar.gz"
# tar -xf "fordownload.tar.gz"
# rm "fordownload.tar.gz"

# Tesseract-OCR (for text recognition in images)
apt-get -y install tesseract-ocr libtesseract-dev
pip3 install pytesseract
pip3 install pymupdf pytest fontTools

# Add programs to /usr/bin
ln -s /tools/bedtools/bedtools /usr/local/bin
# ln -s /tools/fordownload/score3.pl /usr/local/bin
# ln -s /tools/fordownload/score5.pl /usr/local/bin
ln -s /tools/regtools-${REGTOOLS_VERSION}/build/regtools /usr/local/bin