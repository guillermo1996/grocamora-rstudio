#!/bin/bash
set -e

DEFAULT_USER=${1:-${DEFAULT_USER:-"rstudio"}}

if id -u "${DEFAULT_USER}" >/dev/null 2>&1; then
    echo "User ${DEFAULT_USER} already exists"
else
    ## Need to configure non-root user for RStudio
    useradd -s /bin/bash -m "$DEFAULT_USER"
    echo "${DEFAULT_USER}:${DEFAULT_USER}" | chpasswd
    usermod -a -G staff "${DEFAULT_USER}"

    ## Rocker's default RStudio settings, for better reproducibility
    mkdir -p "/home/${DEFAULT_USER}/.config/rstudio/"
    cat <<EOF >"/home/${DEFAULT_USER}/.config/rstudio/rstudio-prefs.json"
{
    "save_workspace": "never",
    "always_save_history": false,
    "reuse_sessions_for_project_links": true,
    "posix_terminal_shell": "bash"
}
EOF

    ## Download default settings from https://github.com/guillermo1996/grocamora-rstudio
    mv /rstudio_config/* /home/${DEFAULT_USER}/.config/rstudio/
    rm -rf /rstudio_config
    #svn checkout --force https://github.com/guillermo1996/grocamora-rstudio/trunk/rstudio_config /home/${DEFAULT_USER}/.config/rstudio/
    #svn revert -R /home/${DEFAULT_USER}/.config/rstudio/
    #mkdir -p /home/${DEFAULT_USER}/.local/share/rstudio/monitored/lists/
    #cp /home/${DEFAULT_USER}/.config/rstudio/user_dictionary /home/${DEFAULT_USER}/.local/share/rstudio/monitored/lists/

    chown -R "${DEFAULT_USER}:${DEFAULT_USER}" "/home/${DEFAULT_USER}"

    ## Download user dictionary
    
fi

# If shiny server installed, make the user part of the shiny group
if [ -x "$(command -v shiny-server)" ]; then
    adduser "${DEFAULT_USER}" shiny
fi

## configure git not to request password each time
if [ -x "$(command -v git)" ]; then
    git config --system credential.helper 'cache --timeout=3600'
    git config --system push.default simple
fi
