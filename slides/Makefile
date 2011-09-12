all:
	cd fs && mir-crunch -name fs . > ../crunch_fs.ml
	mir-build unix-socket/server.bin

clean:
	ocamlbuild -clean
	rm -f myocamlbuild.ml crunch_fs.ml
