%{
	 #include <stdio.h>
	 #include <stdlib.h>
	 int yylex();
 	void yyerror(char *);
%}

%union {
	float flot;
	int integer;
	char* string;
	char xar;
}

%token <char*> WORD

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
%token ERROR

%left '-' '+'
%left '*' '/'

%token FIM_LINHA

%type<flot>calcFloat
%type<integer>calc
%type<xar>command

%start inicio

%%
	inicio: 
			| inicio line
	;

	line: FIM_LINHA
		| calcFloat FIM_LINHA	{printf("= %f\n",$1);}
		| calc FIM_LINHA 		{printf("= %d\n",$1);}
		| command FIM_LINHA 
	;
	
	calcFloat: FLOAT							{}
			| calcFloat PLUS calcFloat 			{$$ = $1 + $3;}
			| calcFloat MINUS calcFloat 		{$$ = $1 - $3;}
			| calcFloat TIMES calcFloat 		{$$ = $1 * $3;}
			| calcFloat SLASH calcFloat 		{$$ = $1 / $3;}
			| LPAREN calcFloat RPAREN			{$$ = $2;}
			| calc PLUS calcFloat 				{$$ = $1 + $3;}
			| calc MINUS calcFloat 				{$$ = $1 - $3;}
			| calc TIMES calcFloat 				{$$ = $1 * $3;}
			| calc SLASH calcFloat 				{$$ = $1 / $3;}
			| calcFloat PLUS calc 				{$$ = $1 + $3;}
			| calcFloat MINUS calc 				{$$ = $1 - $3;}
			| calcFloat TIMES calc 				{$$ = $1 * $3;}
			| calcFloat SLASH calc 				{$$ = $1 / (float)$3;}
	;

	calc: INTEGER		 		{}
		| calc PLUS calc 		{$$ = $1 + $3;}
		| calc MINUS calc 		{$$ = $1 - $3;}
		| calc TIMES calc 		{$$ = $1 * $3;}
		| calc SLASH calc 		{$$ = $1 / $3;}
		| LPAREN calc RPAREN	{$$ = $2;}
	;
	

	command:  LS				{$$ = system("ls");}
 			| KILL calc			{char kill[1024]; 
								snprintf (kill, sizeof(kill), "kill %d\n", $2);
								$$ = system(kill);
								}
			| IFCONFIG			{$$ = system("ifconfig");}
	;

%%

int main(int argc, char **argv)
{
	return yyparse();
}

/* função usada pelo bison para dar mensagens de erro */
void yyerror(char *msg)
{
	//fprintf(stderr, "erro: %s\n", msg);
	printf("Comando desconhecido\n");
}