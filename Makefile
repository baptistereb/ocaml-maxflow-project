.PHONY: all build format edit demo clean

src?=0
dst?=5
graph?=graph1.txt
graphdot?=outfile
graphfinal?=final

all: build

build:
	@echo "\n   🚨  COMPILING  🚨 \n"
	dune build src/ftest.exe
	ls src/*.exe > /dev/null && ln -fs src/*.exe .

format:
	ocp-indent --inplace src/*

edit:
	code . -n

demo: build
	@echo "\n   ⚡  EXECUTING  ⚡\n"
	./ftest.exe graphs/${graph} $(src) $(dst) outfile graphdepart final
	@echo "\n   🥁  RESULT (content of outfile)  🥁\n"
	make dot graphdot="graphdepart"
	make dot graphdot="outfile"
	make dot graphdot="final"
clean:
	find -L . -name "*~" -delete
	rm -f *.exe
	dune clean

dot:
	dot -Tsvg $(graphdot) > /tmp/$(graphdot).svg
	xdg-open /tmp/$(graphdot).svg
