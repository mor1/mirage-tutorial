#!/bin/bash -e

BIN=kv_ro_server
MIR_RUN=$(which mir-run)

dd if=/dev/zero of=static.img bs=1024 count=8192
mir-fs-create static static.img

mir-build unix-direct/${BIN}.bin
sudo ${MIR_RUN} -b unix-direct -vbd staticvbd:static.img -kv_ro static:staticvbd ./_build/unix-direct/${BIN}.bin
