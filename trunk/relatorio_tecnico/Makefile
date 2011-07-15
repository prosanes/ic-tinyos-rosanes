relatorio.pdf: relatorio.tex ic.bib srcs/BlinkC.nc srcs/BlinkAppC.nc srcs/aplicacaoTesteAppC.nc srcs/aplicacaoTesteC.nc
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
