.PHONY: all build format edit demo clean

src?=0
dst?=5
graph?=graph1.txt
graphdot?=outfile

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
	./ftest.exe graphs/${graph} $(src) $(dst) outfile
	@echo "\n   🥁  RESULT (content of outfile)  🥁\n"
	@cat outfile
	make dot
clean:
	find -L . -name "*~" -delete
	rm -f *.exe
	dune clean

dot:
	dot -Tsvg $(graphdot) > /tmp/imgdot.svg
	xdg-open /tmp/imgdot.svg

