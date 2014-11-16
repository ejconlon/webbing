#!/bin/bash
set -eux

# Builds and tests the application from scratch.  Requires ghc && cabal.

cabal sandbox init
cabal install --only-dependencies --enable-tests
cabal build webbing-exec
cabal test webbing-test
