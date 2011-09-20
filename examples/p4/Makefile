TARGETS = simple_html simple_css

PP  = $(TARGETS:%=%.pp.ml)
BIN = $(TARGETS:%=unix-socket/%.bin)

all: $(PP) $(BIN)

clean:
	mir-build -clean
	rm -f myocamlbuild.ml

%.pp.ml: %.ml
	mir-build $@

unix-socket/%.bin: %.ml
	mir-build $@