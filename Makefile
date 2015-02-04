IOCAML ?= iocaml -completion ./notebooks

MODE  ?= unix
NET   ?= socket
MIRAGE = mirage

.PHONY: all configure build run depend clean docs

all: build
	@ :

configure:
	NET=$(NET) $(MIRAGE) configure src/config.ml --$(MODE)

build:
	cd src && make build

run:
#	$(IOCAML) &
	cd src && sudo make run

depend:
	cd src && make depend

clean:
	[ -r src/Makefile ] && ( cd src && make clean ) || true
	$(RM) log src/mir-tutorial src/main.ml src/Makefile

docs:
	cd docs && make run
