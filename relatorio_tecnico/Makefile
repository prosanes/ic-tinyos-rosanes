relatorio.pdf: relatorio.tex ic.bib
	pdflatex relatorio.tex
	bibtex relatorio.aux
	pdflatex relatorio.tex
	pdflatex relatorio.tex

clean:
	rm *.aux
	rm *.blg
	rm *.out
	rm *.toc
	rm *.bbl
	rm *.log
