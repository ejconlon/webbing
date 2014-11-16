#!/bin/bash
set -eux

APPNAME=heroku apps:info | head -n1 | cut -c5-
heroku apps:delete --app $APPNAME
