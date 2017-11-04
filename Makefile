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

PORT  ?= 8080
FLAGS ?= -vv --net socket -t unix --port $(PORT)

MIRAGE = DOCKER_FLAGS="$$DOCKER_FLAGS -p $(PORT)" \
    dommage --dommage-chdir src

.PHONY: all
all: build
	@ :

.PHONY: clean
clean:
	$(MIRAGE) clean || true
	$(RM) src/*.img

.PHONY: configure
configure:
	$(MIRAGE) configure $(FLAGS)

.PHONY: build
build:
	$(MIRAGE) build

.PHONY: destroy
destroy:
	$(MIRAGE) destroy

.PHONY: update
update:
	$(MIRAGE) update

.PHONY: publish
publish:
	$(MIRAGE) publish mor1/mirage-tutorial

.PHONY: run
run:
	$(MIRAGE) run sudo ./decksopenmirageorg

.PHONY: shell
shell:
	$(MIRAGE) run /bin/bash
