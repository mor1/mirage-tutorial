# valid targets for various combinations :
# run-socket_crunch
# run-socket_fs
# run-direct_crunch
# run-direct_fs
# run-xen_crunch
# run-xen_fs

all: run-socket_crunch

run-%:
	./scripts/build_$*.sh

.PHONY:clean
clean:
	rm -f filesystem_static.ml
	rm -f myocamlbuild.ml
	ocamlbuild -clean
