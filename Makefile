PACKAGENAME=persbib
BINARIES=persbib.cls
SOURCES=$(PACKAGENAME).dtx $(PACKAGENAME).ins
DOC=$(PACKAGENAME).dvi $(PACKAGENAME).pdf
USEPDFLATEX=1

INSTALLDIR=`kpsexpand '$${TEXMFHOME}'/tex/latex/persbib`

default : $(DOC) $(BINARIES)
dist : persbib.zip


install: persbib-tds.zip 
	unzip -d $(INSTALLDIR) $^ 
	texhash
	


BINDIR=texmf/tex/latex/$(PACKAGENAME)
DOCDIR=texmf/doc/latex/$(PACKAGENAME)
SRCDIR=texmf/source/latex/$(PACKAGENAME)

$(BINARIES) : $(PACKAGENAME).install

$(PACKAGENAME)-tds.zip : $(BINARIES) $(SOURCES) $(DOC)
	-install -d $(BINDIR) $(SRCDIR) $(DOCDIR)
	install -m 644 $(BINARIES) $(BINDIR)
	install -m 644 $(DOC) $(DOCDIR)
	install -m 644 $(SOURCES) $(SRCDIR)
	zip -mr $@ texmf

$(PACKAGENAME).zip : $(SOURCES) persbib-tds.zip $(PACKAGENAME).pdf
	-mkdir $(PACKAGENAME)
	-install -m 644 $^ $(PACKAGENAME)
	zip -mr $@ $(PACKAGENAME)

persbib.dvi: persbib.dtx persbib.cls

maintainerclean: cleanall
	-rm $(BINARIES) $(PACKAGENAME).ins $(PACKAGENAME).install $(PACKAGENAME).zip $(PACKAGENAME)-tds.zip

include Makefile.latex
