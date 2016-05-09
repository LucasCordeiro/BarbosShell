%{
	 #include <stdio.h>
	 int yylex();
 	void yyerror(char *);
%}

%union {
	int l_int;
	float l_float;
	char l_char;
	char* l_string;
}

%token <l_string> WORD

%token <l_int> INTEGER
%token <l_float> FLOAT

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

%start inicio

%%
	inicio:
			|inicio line
	;

	line:
		|INTEGER		{printf("oi");}
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