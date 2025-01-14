.PHONY: all build format edit demo clean

input?=preferences.txt

graphdot?=graphfinal

graphdepart?=graphdepart
graphfinal?=graphfinal

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
	@echo -e "\n   ⚡  EXECUTING  ⚡\n"
	./ftest.exe graphs/${input} outfile graphdepart graphfinal
	@echo -e "\n   🥁  RESULT (content of outfile)  🥁\n"
	@cat outfile
	@echo -e "\n\n\n\n"
	make dot graphdot="graphdepart"
	make dot graphdot="graphfinal"
clean:
	find -L . -name "*~" -delete
	rm -f *.exe
	dune clean

dot:
	dot -Tsvg $(graphdot) > /tmp/$(graphdot).svg
	xdg-open /tmp/$(graphdot).svg > /dev/null 2>&1 &
