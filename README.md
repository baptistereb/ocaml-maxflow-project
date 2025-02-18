# OCaml Maxflow Project
This project implements a tool to solve problems of assignments, such as sport course scheduling, using a max flow algorithm. It processes input data like the one in `graphs/preferences*.txt`, where several examples are provided.

# How to Use
To use, you should install the *OCaml Platform* extension in VSCode.
Then open VSCode in the root directory of this repository (command line: `code path/to/ocaml-maxflow-project`).

A [`Makefile`](Makefile) provides some useful commands:

 - `make build` to compile. This creates an `ftest.exe` executable
 - `make demo` to run the `ftest` program with some arguments
 - `make format` to indent the entire project
 - `make edit` to open the project in VSCode
 - `make clean` to remove build artifacts

In case of trouble with the VSCode extension (e.g. the project does not build, there are strange mistakes), a common workaround is to (1) close vscode, (2) `make clean`, (3) `make build` and (4) reopen vscode (`make edit`).


# Input Format
The input file must first contain the possible choices and their capacities, separated by a `;`, like in CSV format. Then, a newline is required before listing the people and their choices (also separated by `;`).

Example input (`graphs/preferences.txt`):
```
Football;2;
Basketball;1;
Tennis;4;
Natation;3;

Alice;Football;Basketball;Tennis;
Bob;Basketball;Football;Natation;
Charlie;Natation;Tennis;Basketball;
Diana;Tennis;Natation;Football;
Eve;Football;Natation;Basketball;
Frank;Basketball;Football;Tennis;
Grace;Tennis;Basketball;Natation;
Hank;Natation;Tennis;Football;
```

# Running the Program
Use the following command to run the program:
```bash
./ftest.exe graphs/preferences3.txt outfile graphdepart graphfinal
```

Where:

- `input_file` : the first argument is the input file (e.g., `graphs/preferences3.txt`)
- `outfile` will contain the output of the program
- `graphdepart` and `graphfinal` are SVG files representing the input and output graphs of the algorithm : it will be generated by the program.

# Output
The program will output the time taken to process the assignment, the list of assigned (and possibly unassigned) individuals to their chosen activities, as well as the corresponding graphs showing the input and output, and the fill levels of each choice.