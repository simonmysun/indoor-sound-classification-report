#======================================================================
#	Makefile fuer LaTeX-Dokumente (PS, PDF)
#======================================================================
#	$Id$
#	Matthias Kupfer
#======================================================================

#======================================================================
#	Name des Dokumentes (ohne .tex)
#======================================================================
MAIN = Vorlage

#======================================================================
#	zusaetzliche Dateien
#======================================================================
OBJECTS =   	Makefile\
		user.sty\
		titel.tex\
		literatur.bib\
		Text/Danksagung.tex\
		Text/Grundlagen.tex\
		Anhang/AnhangA.tex\

#======================================================================
#	Abkuerzungen
#======================================================================
all: ps IMMER 

#======================================================================
#	PostScript erzeugen
#======================================================================
ps : $(MAIN).ps

#======================================================================
#	Literaturverzeichnis erstellen
#======================================================================
bib: $(MAIN).bbl
	rm -f $(MAIN).dvi
	make $(MAIN).dvi
	rm -f $(MAIN).dvi
	make $(MAIN).dvi
	touch $(MAIN).bbl
	make ps

#======================================================================
#	Glossar erstellen
#======================================================================
gloss: $(MAIN).glx

#======================================================================
#	PDF erzeugen
#======================================================================
pdf: $(MAIN).pdf IMMER 

#======================================================================
#	Thumbnails fuer PDF erzeugen
#======================================================================
pdfthumb: $(MAIN).tpt

#======================================================================
#	Literaturverzeichnis erstellen
#======================================================================
pdfbib: $(MAIN).bbl
	rm -f $(MAIN).pdf
	make pdf
	rm -f $(MAIN).pdf
	make pdf
	touch $(MAIN).bbl

#======================================================================
#	PostScript aus DVI erstellen Type1 Fonts verwenden
#======================================================================

$(MAIN).ps: $(MAIN).dvi
	@echo '---------------------------------------------------'
	@echo 'PostScript:  $(MAIN)'
	@echo '---------------------------------------------------'
	dvips -o $(MAIN).ps -Pcmz -Pamz $(MAIN).dvi

#======================================================================
#	DVI erstellen
#======================================================================
$(MAIN).dvi $(MAIN).aux: $(MAIN).tex $(OBJECTS)
	@echo '---------------------------------------------------'
	@echo 'LaTeX:  $(MAIN)'
	@echo '---------------------------------------------------'
	latex $(MAIN)
	latex $(MAIN)

#======================================================================
#	Literaturverzeichnis erstellen
#======================================================================

$(MAIN).bbl: literatur.bib user.bst $(MAIN).aux
	@echo '---------------------------------------------------'
	@echo 'Literaturverzeichnis:  $(MAIN)'
	@echo '---------------------------------------------------'
	bibtex $(MAIN)

user.bst: user.dbj
	@echo '---------------------------------------------------'
	@echo 'LaTeX:  user.dbj'
	@echo '---------------------------------------------------'
	latex user.dbj

#======================================================================
#	GlossTeX
#======================================================================

$(MAIN).glx: $(MAIN).aux  $(MAIN).gdf
	@echo '---------------------------------------------------'
	@echo 'GlossTeX:  $(MAIN)'
	@echo '---------------------------------------------------'
	glosstex $(MAIN).aux ./$(MAIN).gdf -v5
	makeindex $(MAIN).gxs -o $(MAIN).glx -s glosstex.ist
	rm -f $(MAIN).dvi
	make ps

#======================================================================
#	DVI -> PDF erstellen
#======================================================================
dvipdf: $(MAIN).dvi
	@echo '---------------------------------------------------'
	@echo 'dvips:  $(MAIN).dvi'
	@echo '---------------------------------------------------'
	dvips -Ppdf -o $(MAIN).ps $(MAIN).dvi
	@echo '---------------------------------------------------'
	@echo 'ps2pdf13:  $(MAIN).ps'
	@echo '---------------------------------------------------'
	ps2pdf13 $(MAIN).ps $(MAIN).pdf

#======================================================================
#	TeX -> PDF erstellen
#======================================================================
$(MAIN).pdf: $(MAIN).tex $(OBJECTS) IMMER
	@echo '---------------------------------------------------'
	@echo 'PDF-LaTeX:  $(MAIN).tex'
	@echo '---------------------------------------------------'
	pdflatex $(MAIN).tex

#======================================================================
#	nachfolgende Teile nur bei Verfuegbarkeit TODO
#======================================================================
$(MAIN).tpt: $(MAIN).tex $(OBJECTS) $(MAIN).pdf
	@echo '---------------------------------------------------'
	@echo 'Thumbnails:  $(MAIN)'
	@echo '---------------------------------------------------'
	thumbpdf $(MAIN)
	rm -f $(MAIN).pdf
	make pdf
	touch $(MAIN).tpt

#======================================================================
#	aufraeumen
#======================================================================
clean:
	@echo '---------------------------------------------------'
	@echo 'loesche erstellten Dateien'
	@echo '---------------------------------------------------'
	@rm -f *.aux # LaTeX Zwischendateien
	@rm -f *.log
	@rm -f *.toc
	@rm -f *.out
	@rm -f *.dvi
	@rm -f *.blg
	@rm -f *.bbl
	@rm -f $(MAIN).ps  # Postscript-Dokument
	@rm -f $(MAIN).pdf # PDF-Dokument
	@rm -f $(MAIN).tpt # Thumbnails von ThumbPDF
	@rm -f *.gxg # Log-Datei von GlossTeX
	@rm -f *.gxs # Indexdatei von GlossTeX
	@rm -f $(MAIN).ilg # Log-Datei von Makeindex
	@rm -f $(MAIN).glx # das fertige Glossar
	@rm -f $(MAIN).brf # backref
	@rm -f *.lof # List of figures
	@rm -f *.lot # List of tables
#	@rm -f *.lo? # List of <any> and Log-Dateien löschen 
#			(z.B. loa -> List of Algorithms)

#======================================================================
#	Hilfe
#======================================================================
help:
	@echo '----------------------------------------------------------------'
	@echo 'Hilfe'
	@echo -e '----------------------------------------------------------------\n'
	@echo 'make [ps]     :  latex + dvips                   -> ps'
	@echo 'make bib      :  latex + bibtex + 2*latex        -> ps'
	@echo -e 'make gloss    :  latex + glosstex + makeindex +..-> ps\n'
	@echo 'make pdf      :  pdflatex                        -> pdf'
	@echo 'make pdfbib   :  pdflatex + bibtex + 2*pdflatex  -> pdf'
	@echo -e 'make pdfthumb :  pdflatex + thumbpdf + pdflatex  -> pdf\n'
	@echo 'make help     :  Diese Hilfe'
	@echo -e 'make file     :  Erläuterung zu den Dateien\n'
	@echo '----------------------------------------------------------------'

file:
	@echo '----------------------------------------------------------------'
	@echo 'Dateien'
	@echo -e '----------------------------------------------------------------\n'
	@echo -e 'Makefile - "make help" für Hilfe\n'
	@echo '$(MAIN).tex - die zentrale LaTeX-Datei'
	@echo 'metadaten.tex - Autor, Titel, Keywords ...'
	@echo -e 'titel.tex - Titelseite etc.\n'
	@echo -e '*.tex - Inhalt\n'
	@echo 'user.sty - Paket mit Tools'
	@echo 'user.dbj - Batchfile für user.bst'
	@echo 'user.bst - aktuelle Bib-Styles'
	@echo -e 'literatur.bib - Literaturdatenbank für Referenzen\n'
	@echo -e 'hyperref.cfg - Einstellungen für hyperref\n'
	@echo -e '$(MAIN).gdf - Glossar zum Dokument\n'
	@echo '----------------------------------------------------------------'

# Sonstiges
IMMER:          # Pseudotarget

