#!/bin/bash

## Install R from source.
##
## Based on https://github.com/rocker-org/rocker-versioned2/blob/master/scripts/install_R_source.sh

set -e

R_VERSION=$R_VERSION
R_HOME=$R_HOME

source /etc/os-release
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get -y install locales

## Configure default locale
LANG=${LANG:-"en_GB.UTF-8"}
/usr/sbin/locale-gen --lang "${LANG}"
/usr/sbin/update-locale --reset LANG="${LANG}"

apt-get install -y --no-install-recommends \
    bash-completion \
    ca-certificates \
    file \
    fonts-texgyre \
    g++ \
    gfortran \
    gsfonts \
    libblas-dev \
    libbz2-* \
    libcurl4 \
    "libicu[0-9][0-9]" \
    liblapack-dev \
    libpcre2* \
    libjpeg-turbo* \
    libpangocairo-* \
    libpng16* \
    libreadline8 \
    libtiff* \
    liblzma* \
    make \
    tzdata \
    unzip \
    zip \
    zlib1g

apt-get install -y --no-install-recommends \
    curl \
    default-jdk \
    devscripts \
    nano \
    libbz2-dev \
    libcairo2-dev \
    libcurl4-openssl-dev \
    libpango1.0-dev \
    libjpeg-dev \
    libicu-dev \
    libpcre2-dev \
    libpng-dev \
    libreadline-dev \
    libtiff5-dev \
    liblzma-dev \
    libx11-dev \
    libxt-dev \
    liblz4-dev \
    libzstd-dev \
    perl \
    rsync \
    subversion \
    tcl-dev \
    tk-dev \
    texinfo \
    texlive-extra-utils \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    texlive-latex-recommended \
    texlive-latex-extra \
    x11proto-core-dev \
    xauth \
    xfonts-base \
    xvfb \
    wget \
    zlib1g-dev
    
# Download and install R from source.
# https://docs.posit.co/resources/install-r-source/#specify-r-version
sed -i.bak "/^#.*deb-src.*universe$/s/^# //g" /etc/apt/sources.list
apt-get update
apt-get -y build-dep r-base

curl -o "R.tar.gz" https://cran.rstudio.com/src/base/R-4/R-${R_VERSION}.tar.gz
tar -xzf "R.tar.gz"
cd R-*/

R_PAPERSIZE=letter \
    R_BATCHSAVE="--no-save --no-restore" \
    R_BROWSER=xdg-open \
    PAGER=/usr/bin/pager \
    PERL=/usr/bin/perl \
    R_UNZIPCMD=/usr/bin/unzip \
    R_ZIPCMD=/usr/bin/zip \
    R_PRINTCMD=/usr/bin/lpr \
    LIBnn=lib \
    AWK=/usr/bin/awk \
    CFLAGS="-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -g" \
    CXXFLAGS="-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -g" \
    ./configure --enable-R-shlib \
    --enable-memory-profiling \
    --with-readline \
    --with-blas \
    --with-lapack \
    --with-tcltk \
    --with-recommended-packages

make
make install
make clean

## Add a library directory (for user-installed packages)
mkdir -p "${R_HOME}/site-library"
chown root:staff "${R_HOME}/site-library"
chmod g+ws "${R_HOME}/site-library"
## Fix library path
echo "R_LIBS=\${R_LIBS-'${R_HOME}/site-library:${R_HOME}/library'}" >>"${R_HOME}/etc/Renviron.site"

## Clean up from R source install
cd ..
rm -rf /tmp/*
rm -rf R-*/
rm -rf "R.tar.gz"

## Copy the checkbashisms script to local before remove devscripts package.
## https://github.com/rocker-org/rocker-versioned2/issues/510
cp /usr/bin/checkbashisms /usr/local/bin/checkbashisms

# shellcheck disable=SC2086
apt-get autoremove -y
apt-get autoclean -y
rm -rf /var/lib/apt/lists/*

# Check the R info
echo -e "Check the R info...\n"

R -q -e "sessionInfo()"

echo -e "\nInstall R from source, done!"