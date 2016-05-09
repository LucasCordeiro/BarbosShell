%{
	 #include <stdio.h>
	 int yylex();
 	void yyerror(char *);
%}

%token <symp> WORD

%token <int> INTEGER
%token <float> FLOAT

%token PLUS
%token MINUS
%token TIMES
%token SLASH
%token LPAREN
%token RPAREN

%token LS
%token KILL
%token MKDIR
%token RMDIR
%token CD
%token TOUCH
%token IFCONFIG
%token START
%token QUIT

%left '-' '+'
%left '*' '/'

%token FIM_LINHA
%type linha


%%
	linha: expressao FIM_LINHA { printf("valor: %d\n", $1); }
 	;
expressao: expressao '+' termo { $$ = $1 + $3; }
 | termo { $$ = $1; }
 ;
termo: INTEGER { $$ = $1; }
 ;					

%%

int main(int argc, char **argv)
{
	return yyparse();
}

/* função usada pelo bison para dar mensagens de erro */
void yyerror(char *msg)
{
	fprintf(stderr, "erro: %s\n", msg);
}