CXX = g++
FLEX = flex
BISON = bison -Wcounterexamples --defines=token.h

all: translator

translator: parser.o scanner.o main.o utils.o
	$(CXX) scanner.o parser.o main.o utils.o -o translator

parser.o: parser.c
	$(CXX) -c parser.c

parser.c: parser.bison
	$(BISON) -v --output parser.c parser.bison

scanner.o: token.h scanner.c
	$(CXX) -c scanner.c

scanner.c: scanner.l
	$(FLEX) -o scanner.c scanner.l

main.o: token.h main.c
	$(CXX) -c main.c

utils.o: utils.c utils.h
	$(CXX) -c utils.c

.PHONY:
clean:
	$(RM) *.o parser.c parser.output token.h scanner.c translator
