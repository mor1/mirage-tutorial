#!/bin/sh -e

mir-crunch -name "static" static > filesystem_static.ml
echo open Filesystem_static > main.ml
echo open Server >> main.ml
echo "let _ = OS.Main.run (main ())" >> main.ml
