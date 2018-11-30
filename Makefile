SOURCES = load_data.ml pqueue.ml modele.ml solve.ml
TARGET = conflicts_resolution
OCAMLC = ocamlc -g
OCAMLOPT = ocamlopt -unsafe -inline 100
DEP = ocamldep
OBJS = $(SOURCES:.ml=.cmo)
OBJS_OPT = $(SOURCES:.ml=.cmx)

all: .depend byte opt

byte: $(TARGET)
opt : $(TARGET).opt

$(TARGET): $(OBJS)
	$(OCAMLC) -o $@ $^

$(TARGET).opt: $(OBJS_OPT)
	$(OCAMLOPT) -o $@ $^

%.cmi: %.mli
	$(OCAMLC) $<

%.cmo: %.ml
	$(OCAMLC) -c $<

%.cmx: %.ml
	$(OCAMLOPT) -c $<

.PHONY: clean

clean:
	rm -f *.cm[io] *~
.depend: $(SOURCES)
	$(DEP) *.mli *.ml > .depend
include .depend
