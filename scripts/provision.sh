#!/bin/bash
set -eux
cd ..

# Deploys the application on heroku. It is not necessary to build beforehand,
# but it's probably smart to do so just to confirm everything should work.

# Set appname if present as first argument

APPNAME="${1-}"

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

if [ ! -z "$APPNAME" ]; then
    heroku apps:rename $APPNAME
fi

# Deploy

git push heroku master
