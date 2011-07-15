relatorio.pdf: main.tex resumo.tex introducao.tex rssf-TinyOS-Nesc.tex escalonamento-de-tarefas.tex sequencia-inicializacao.tex modelo-concorrencia.tex escalonador-padrao.tex escalonadores-propostos.tex modelo-threads-teoria.tex conclusoes.tex co-rotinas-implementacao.tex experimentos-escalonadores.tex modelo-threads-implementacao.tex sequencia-inicializacao.tex ic.bib srcs/BlinkC.nc srcs/BlinkAppC.nc srcs/aplicacaoTesteAppC.nc srcs/aplicacaoTesteC.nc
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
