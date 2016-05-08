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

%type<int> calc

%start calc

%%

	calc: INTEGER				{$$ = $1;}

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