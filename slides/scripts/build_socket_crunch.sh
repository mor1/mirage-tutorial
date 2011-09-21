#!/bin/bash -ex

# Switch to the directory with the 'static' subdir containing the slides
cd $(git rev-parse --show-toplevel)/slides

BIN=crunch_server
MIR_RUN=$(which mir-run)

mir-crunch -name "static" static > filesystem_static.ml
mir-build -I src unix-socket/${BIN}.bin
${MIR_RUN} -b unix-socket ./_build/unix-socket/${BIN}.bin
