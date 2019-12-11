.PHONY: all clean

project := paper
bib :=
figs :=

ltx = pdflatex
opts := -interaction=nonstopmode -pdf -latexoption="-synctex=1" -time

#Uncomment this if compiling through a format
fmt := $(project)

figs_pdf := $(figs:%=figures/%.pdf)
deps = $(bib) $(figs_pdf)
ifneq ($(origin fmt), undefined)
	deps := $(deps) $(fmt).fmt
endif

$(project).pdf: $(project).tex $(deps)
	latexmk $(opts) $<

$(project).tar.gz : $(project).tex $(project).bbl $(figs_pdf)
	tar -czvf $@ $^

$(fmt).fmt: $(project).tex
ifeq ($(ltx), pdflatex)
	etex -initialize -jobname=$(fmt) "&pdflatex" mylatexformat.ltx $(fmt).tex
endif
ifeq ($(ltx), xelatex)
	xelatex -ini -jobname=$(fmt) "&xelatex" mylatexformat.ltx $(fmt).tex
endif

figures/%.pdf:
	cd python && "$(MAKE)" $(notdir $@)

all: $(project).tar.gz

clean:
# cd python && "$(MAKE)" clean
	latexmk -c $(project).tex
ifneq ($(origin fmt), undefined)
	rm -f $(fmt).fmt $(project)Notes.bib $(project).synctex.gz
endif
