.PHONY: all clean

project := paper
bib :=
figs :=

ltx = pdflatex
opts := -interaction=nonstopmode -pdf -latexoption="-synctex=1" -time

#Uncomment this if compiling through a format
#fmt :=

figs_pdf := $(figs:%=figures/%.pdf)
deps = $(bib) $(figs_pdf)
ifneq ($(origin fmt), undefined )
	deps := $(deps) $(fmt)
endif

$(project).pdf: $(project).tex $(deps)
	latexmk $(opts) $<

$(project).tar.gz : $(project).tex $(project).bbl $(figs_pdf)
	tar -czvf $@ $^

$(fmt).fmt: $(fmt)
	$(ltx) -ini -jobname=$(fmt) mylatexformat.ltx $(fmt).tex

figures/%.pdf:
	cd python && "$(MAKE)" $(notdir $@)

all: $(project).tar.gz

clean:
	latexmk -c $(project).tex
