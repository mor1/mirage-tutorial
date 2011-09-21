#!/bin/bash -e

# Switch to the directory with the 'static' subdir containing the slides
cd $(git rev-parse --show-toplevel)/slides

BIN=kv_ro_server
MIR_RUN=$(which mir-run)

mir-build unix-socket/${BIN}.bin
${MIR_RUN} -b unix-socket -kv_ro static:static ./_build/unix-socket/${BIN}.bin
