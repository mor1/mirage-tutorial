#!/bin/bash -e

# Switch to the directory with the 'static' subdir containing the slides
cd $(git rev-parse --show-toplevel)/slides

BIN=crunch_server
MIR_RUN=$(which mir-run)

mir-crunch -name "static" static > filesystem_static.ml
mir-build xen/${BIN}.xen
sudo ${MIR_RUN} -b xen -vif xenbr0 ./_build/xen/${BIN}.xen
