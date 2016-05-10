all: shell

bison.tab.c bison.tab.h:	bison.y
	bison -d bison.y

lex.yy.c: flex.lex bison.tab.h
	flex flex.lex

shell: lex.yy.c bison.tab.c bison.tab.h
	gcc bison.tab.c lex.yy.c -ll -o automa
	./automa

clean:
	rm automa bison.tab.c lex.yy.c bison.tab.h