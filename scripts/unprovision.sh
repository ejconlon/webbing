#!/bin/bash
set -eux

# Tears down the heroku app.

APPNAME=heroku apps:info | head -n1 | cut -c5-
heroku apps:delete --app $APPNAME
