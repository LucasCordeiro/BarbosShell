%{
	 #include <stdio.h>
	 #include <stdlib.h>
	 #include <string.h>
	#include <sys/types.h>
	#include <unistd.h>

	 int yylex();
	 extern FILE* yyin;
 	void yyerror(char *);

 	void name(){
 		char root[2023];
		getcwd(root, sizeof(root));
		strcat(root,"$ ");
		printf("BharbosShell:~%s",root);
 	}
%}

%union {
	float flot;
	int integer;
	char* string;
	char xar;
}

%token <string> WORD

%token <integer> INTEGER
%token <flot> FLOAT

%token PLUS
%token MINUS
%token TIMES
%token SLASH
%token LPAREN
%token RPAREN
%token LS
%token PS
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

	line: FIM_LINHA				{name();}
		| calcFloat FIM_LINHA	{printf("= %f\n",$1);name();}
		| calc FIM_LINHA 		{printf("= %d\n",$1);name();}
		| command FIM_LINHA 	{name();}
	;
	
	calcFloat: FLOAT							{$$ = $1;}
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

	calc: INTEGER		 		{$$ = $1;}
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
			| QUIT 				{ printf("EXIT\n"); 
								exit(0); }
			| TOUCH WORD 		{ char touch[1024];
								strcpy(touch, "touch ");
								strcat(touch,$2);			 	
								$$ = system(touch); 
								}
			| MKDIR WORD 		{ char mkdir[1024];
								strcpy(mkdir, "mkdir ");
								strcat(mkdir,$2); 
							  	$$ = system(mkdir); 
								}
			| RMDIR WORD 		{ char rmdir[1024];
								strcpy(rmdir, "rmdir ");
								strcat(rmdir,$2); 
							  	$$ = system(rmdir); 
								}
			| START WORD 		{ char start[1024];
								strcpy(start, $2);
								strcat(start,"&"); 
							  	$$ = system(start); 
								}
			| CD 				{const char *homeDir = getenv("HOME");
								int error = chdir(homeDir);
								if(error != 0){
									printf("cd: no such file or directory\n");
								}
								}
			| CD WORD 			{char cd[2048];
							  	int error;
							  	int back = strcmp("..",$2);
			   				  	int root = strcmp("~",$2);
							  	if(back == 0){
								  	error = chdir($2);
							  	}else if(root == 0){
							  		const char *homeDir = getenv("HOME");
								  	error = chdir(homeDir);
							    }else{
								  	getcwd(cd, sizeof(cd));
								  	strcat(cd,"/");
								  	strcat(cd,$2);
								  	error = chdir(cd);
							  	}
							  	if(error != 0)
							  	{
									printf("cd: no such file or directory: %s\n",$2);
							  	}
								}
			| PS 				{ $$ = system("ps");}		

	;

%%


int main(int argc, char **argv)
{
	name();

	yyin = stdin;
	
  																											
	do { 
		yyparse();
	} while(!feof(yyin));
	return 0;
}

/* função usada pelo bison para dar mensagens de erro */
void yyerror(char *msg)
{
	//fprintf(stderr, "erro: %s\n", msg);
	printf("bsh: %s\n",msg);
}