%{
	 #include <stdio.h>
 	void yyerror(char *);
%}

%token <symp> WORD

%token <dval> INTEGER
%token <dval> FLOAT

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

%type <dval> calc

%start calc

%%

	calc: INTEGER				{$$ = $1;}
		|calc PLUS calc 		{$$ = $1 + $3;}
		|calc MINUS calc 		{$$ = $1 - $3;}
		|calc TIMES calc 		{$$ = $1 * $3;}
		|calc SLASH calc 		{$$ = $1 / $3;}
		|LPAREN calc RPAREN 	{$$ = ($2)}

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