MIRAGE = mirage

MODE  ?= unix
NET   ?= socket
PORT  ?= 80

.PHONY: all configure build run depend clean docs

all: build
	@ :

configure:
	NET=$(NET) PORT=$(PORT) $(MIRAGE) configure src/config.ml --$(MODE)

build:
	cd src && make build

run:
	cd src && make run

depend:
	cd src && make depend

clean:
	[ -r src/Makefile ] && ( cd src && make clean ) || true
	$(RM) log src/mir-tutorial src/main.ml src/Makefile

docs:
	cd docs && make run
