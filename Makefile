
PDFS := $(patsubst %.md,%.md.pdf,$(wildcard *.md))
LATEX := $(patsubst %.md,%.md.latex,$(wildcard *.md))

all : $(LATEX) $(PDFS)

%.md.latex : %.md default.latex
	pandoc --template default.latex -o $@ $<

	# Reformat the company/job title/location/years
	perl -0777 -pi -e 's|\\subsubsection\{\\texorpdfstring\{\\textbf\{(.*?)}(.*?--.*?)}\{.*?}\\label\{.*?}\n\n(.*?)--(.*?)\n|\\jobtitle{$$3}{$$2}{$$1}{$$4}}\n|gms;' $@

	# Reformat the address at the beginning
	perl -0777 -pi -e 's|\\begin\{verbatim}(.*?)\n\n(.*?)\n(.*?)\\end\{verbatim}|\\rAddress\{$$1}\\rEmail\{$$2}\\rPhone\{$$3}|sm;' $@

	# Style the word LaTeX properly
	perl -0777 -pi -e 's|LaTeX|\\LaTeX{}|g;' $@

	# Make the list of technical skills two columns
	perl -0777 -pi -e 's|(\\subsection\{Technical Skills}\\label\{.*?})(.*?)(\\end\{itemize})|\1\n\\begin{multicols}{2}\n\2\3\\end{multicols}|sm;' $@

%.md.pdf : %.md.latex default.latex
	pdflatex -interaction=nonstopmode $<

clean :
	rm $(PDFS) $(LATEX)

rebuild : clean all

