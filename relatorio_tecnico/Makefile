relatorio.pdf: *.tex ic.bib srcs/*
	pdflatex main.tex
	bibtex main.aux
	pdflatex main.tex
	pdflatex main.tex

clean:
	rm *.aux
	rm *.blg
	rm *.out
	rm *.toc
	rm *.bbl
	rm *.log
