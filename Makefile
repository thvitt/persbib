PACKAGENAME=persbib
BINARIES=persbib.cls german-pb.lbx
SOURCES=$(PACKAGENAME).dtx $(PACKAGENAME).ins
EXSOURCES=$(PACKAGENAME).bib $(PACKAGENAME)-example.tex
DOC=$(PACKAGENAME).dvi $(PACKAGENAME).pdf persbib-example.pdf

INSTALLDIR=`kpsexpand '$${TEXMFHOME}'`

default : $(DOC) $(BINARIES)
dist : $(PACKAGENAME).zip


install: $(PACKAGENAME).tds.zip 
	unzip -o -d $(INSTALLDIR) $^ 
	texhash

BINDIR=texmf/tex/latex/$(PACKAGENAME)
DOCDIR=texmf/doc/latex/$(PACKAGENAME)
SRCDIR=texmf/source/latex/$(PACKAGENAME)

persbib.dvi: persbib.dtx persbib.cls

persbib.pdf: persbib.dtx persbib.cls

persbib-example.pdf : persbib-example.tex persbib.cls


$(PACKAGENAME).tds.zip : $(BINARIES) $(SOURCES) $(DOC)
	-rm -f $@
	-install -d $(BINDIR) $(SRCDIR) $(DOCDIR)
	install -m 644 $(BINARIES) $(BINDIR)
	install -m 644 $(DOC) $(EXSOURCES) $(DOCDIR)
	install -m 644 $(SOURCES) $(SRCDIR)
	cd texmf && zip -mr ../$@ *
	rmdir texmf

$(PACKAGENAME).zip : $(SOURCES) persbib.tds.zip $(PACKAGENAME).pdf
	-rm -f $@
	-mkdir $(PACKAGENAME)
	-install -m 644 $^ $(PACKAGENAME)
	zip -mr $@ $(PACKAGENAME)



## Remove everything generated by this makefile
maintainerclean: cleanall
	-rm $(BINARIES) $(PACKAGENAME).ins $(PACKAGENAME).install $(PACKAGENAME).zip $(PACKAGENAME).tds.zip $(EXSOURCES)

## Remove temporary files as well as typeset documentation
cleanall : clean
	-rm $(PACKAGENAME).dvi $(PACKAGENAME).pdf
	-rm $(PACKAGENAME)-example.dvi $(PACKAGENAME)-example.pdf

## Remove temporary files
clean : 
	-rm $(PACKAGENAME).aux $(PACKAGENAME).bcf $(PACKAGENAME).glo $(PACKAGENAME).hd $(PACKAGENAME).idx $(PACKAGENAME).log $(PACKAGENAME).out $(PACKAGENAME).run.xml $(PACKAGENAME).bbl $(PACKAGENAME).blg $(PACKAGENAME).ilg $(PACKAGENAME).ind
	-rm $(PACKAGENAME)-example.aux $(PACKAGENAME)-example.bcf $(PACKAGENAME)-example.glo $(PACKAGENAME)-example.hd $(PACKAGENAME)-example.idx $(PACKAGENAME)-example.log $(PACKAGENAME)-example.out $(PACKAGENAME)-example.run.xml $(PACKAGENAME)-example.bbl $(PACKAGENAME)-example.blg $(PACKAGENAME)-example.ilg $(PACKAGENAME)-example.ind

upload : $(PACKAGENAME).tds.zip $(PACKAGENAME).pdf $(PACKAGENAME).zip
	github-upload -m application/zip -f $(PACKAGENAME).zip
	github-upload -m application/pdf -d "Anleitung" -f $(PACKAGENAME).pdf
	github-upload -m application/zip -d "Alle Dateien in TDS-Struktur -- in $$HOMETEXMF entpacken" -f $(PACKAGENAME).tds.zip



## Extract the installer from the dtx file
%.preins :
	echo '\\input docstrip' > $@
	echo '\\askforoverwritefalse' >> $@
	echo '\\generate{\\file{$*.ins}{\\from{$*.dtx}{installer}}}' >> $@
	echo '\\endbatchfile' >> $@

%.ins : %.preins %.dtx
	tex $<

# Extract binaries from the bundle
$(BINARIES) $(EXSOURCES) : $(PACKAGENAME).ins $(PACKAGENAME).dtx
	latex $<

%.pdf : %.dtx
	pdflatex $<
	-[ -r $*.glo ] && makeindex $*.glo
	-[ -r $*.idx ] && makeindex $*.idx
	-[ -r $*.bcf ] && biber $*.bcf
	pdflatex $<


%.pdf : %.tex
	pdflatex $<
	-[ -r $*.glo ] && makeindex $*.glo
	-[ -r $*.idx ] && makeindex $*.idx
	-[ -r $*.bcf ] && biber $*.bcf
	pdflatex $<

%.dvi : %.dtx
	latex $<
	makeindex $*.glo
	makeindex $*.idx
	latex $<

