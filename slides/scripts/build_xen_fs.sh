#!/bin/bash -ex

# Switch to the directory with the 'static' subdir containing the slides
cd $(git rev-parse --show-toplevel)/slides

BIN=kv_ro_server
MIR_RUN=$(which mir-run)

dd if=/dev/zero of=static.img bs=1024 count=8192
mir-fs-create static static.img

mir-build xen/${BIN}.xen
sudo ${MIR_RUN} -b xen -vif xenbr0 -vbd hda1:static.img -kv_ro static:hda1 ./_build/xen/${BIN}.xen
