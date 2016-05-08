

all : clean analisador
	
# Faz a compilacao do codigo em C, porem precisa que exista o output do flex
analisador: lex.yy.c byson.tab.c byson.tab.h
	@echo "\n==> Compilando...";
	gcc byson.tab.c lex.yy.c -o calculadora

# Gera codigo a partar da especificacao do flex
lex.yy.c:
	@echo "\n==> Executando FLEX para gerar código em linguagem C";
	analisador.lex; flex -l analisador.lex

byson.tab.c: byson.y
	@echo "\n==> Executando BISON para gerar código em linguagem C";
	bison -d byson.y

# regra util para limpar os arquivos que o make gera automaticamente
clean:
	@echo "\n==> Removendo arquivos desnecessários";
	rm -rf lex.yy.c byson.tab.h byson.tab.c calculadora lex.yy.o byson.tab.o
