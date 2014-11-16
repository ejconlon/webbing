#!/bin/bash

# Ensure Heroku is installed

INSTALL_HEROKU="wget -qO- https://toolbelt.heroku.com/install.sh | sh"

command -v heroku >/dev/null 2>&1 || { $INSTALL_HEROKU; }

# Login

heroku login

# Provision instance

heroku create --stack=cedar --buildpack \
  https://github.com/begriffs/heroku-buildpack-haskell.git

# Add database

heroku addons:add heroku-postgresql:dev
DBNAME=$(heroku config | grep POSTGRES | cut -d: -f1)
heroku pg:promote $DBNAME

# Rename

if [ -e "$1" ]; then
    heroku apps:rename newname
fi

# Deploy

git push heroku master
