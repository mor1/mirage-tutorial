IOCAML ?= iocaml -completion ./notebooks

MODE  ?= unix
NET   ?=
MIRAGE = mirage

.PHONY: all configure build run depend clean docs

all: build
	@ :

configure:
	$(MIRAGE) configure src/config.ml --$(MODE)

build:
	cd src && make build

run:
#	$(IOCAML) &
	cd src && sudo make run

depend:
	cd src && make depend

clean:
	cd src && make clean
	$(RM) src/mir-tutorial log

docs:
	cd docs && make run
