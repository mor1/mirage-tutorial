all: run-socket_crunch

help:
	@echo valid targets for various combinations :
	@echo "	run-socket_crunch"
	@echo "	run-socket_fs"
	@echo "	run-direct_crunch"
	@echo "	run-direct_fs"
	@echo "	run-xen_crunch"
	@echo "	run-xen_fs"

run-%:
	./scripts/build_$*.sh

.PHONY:clean
clean:
	$(RM) filesystem_static.ml myocamlbuild.ml static.img
	ocamlbuild -clean
