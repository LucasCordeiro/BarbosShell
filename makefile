all: compil

bison.tab.c bison.tab.h:	bison.y
	bison -d bison.y

lex.yy.c: flex.lex bison.tab.h
	flex flex.lex

compil: lex.yy.c bison.tab.c bison.tab.h
	gcc -o bharbosShell bison.tab.c lex.yy.c -lfl

clean:
	rm bharbosShell bison.tab.c lex.yy.c bison.tab.h