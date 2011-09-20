#!/bin/bash -e

BIN=crunch_server
MIR_RUN=$(which mir-run)

mir-crunch -name "static" static > filesystem_static.ml
mir-build unix-direct/${BIN}.bin
sudo ${MIR_RUN} -b unix-direct ./_build/unix-direct/${BIN}.bin
