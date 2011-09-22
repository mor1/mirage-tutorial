JOBS ?= -j 4

%:
	mir-build $(JOBS) unix-socket/$*.bin
	./_build/unix-socket/$*.bin

%.pp:
	mir-build unix-socket/$*.pp.ml
	cat _build/unix-socket/$*.pp.ml

clean:
	mir-build -clean
