#
# Copyright (c) 2013-2017 Richard Mortier <mort@cantab.net>
#
# Permission to use, copy, modify, and distribute this software for any purpose
# with or without fee is hereby granted, provided that the above copyright
# notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.
#

.PHONY: configure clean build publish destroy run
all: build
	@ :

PORT ?= 8080

MIRAGE = cd src && DOCKER_FLAGS="$$DOCKER_FLAGS -p $(PORT)" dommage

FLAGS ?= -vv --net socket -t unix --port $(PORT)

configure:
	$(MIRAGE) configure $(FLAGS)

clean:
	$(RM) -r _mirage/_build
	$(MIRAGE) clean || true
	$(MIRAGE) destroy || true

build:
	$(MIRAGE) build

publish:
	$(MIRAGE) publish mor1/mirage-tutorial

destroy:
	$(MIRAGE) destroy

run:
	$(MIRAGE) run ./tutorial
