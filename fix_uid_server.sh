groupmod -g 1028 rstudio
usermod -u 1027 -g 1028 rstudio
chown 1027:1028 -R /home/rstudio