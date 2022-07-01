TARGET=main

all: step0 step1 step2 step4

step0:
	make clean

step1:
	xelatex --no-pdf --shell-escape ${TARGET};

step2: ${TARGET}.aux
	biber ${TARGET};

step3: ${TARGET}.aux
	makeglossaries ${TARGET};

step4: ${TARGET}.bbl
	xelatex --no-pdf --shell-escape ${TARGET};
	xelatex --shell-escape ${TARGET};

clean:
	rm *.aux || true;
	rm *.bbl || true;
	rm *.bcf || true;
	rm *.blg || true;
	rm *.log || true;
	rm *.out || true;
	rm *.run.xml || true;
	rm *.xdv || true;
	rm *.toc || true;
	rm *.dvi || true;
	rm *.ps || true;
	rm *.tpt || true;
	rm *.gxg || true;
	rm *.gxs || true;
	rm *.ilg || true;
	rm *.glx || true;
	rm *.brf || true;
	rm *.lof || true;
	rm *.lot || true;
	rm *.lo? || true;
	rm *.ist || true;
	rm *.glsdefs || true;
	rm *.glo || true;
	rm *.acn || true;
	rm *.gdf || true;
	rm *.alg || true;
	rm *.glg || true;
	rm *.gls || true;
	rm *.acr || true;
