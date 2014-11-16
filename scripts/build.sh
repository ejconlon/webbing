#!/bin/bash
set -eux
cd ..

# Builds and tests the application from scratch.  Requires ghc && cabal.

cabal sandbox init
cabal configure --enable-tests
cabal install --only-dependencies --enable-tests
cabal build webbing-exec
cabal test webbing-test
