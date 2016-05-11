%{

 #include <stdio.h>
#include "bison.tab.h" 

%}

/* Yacc defs */
%option noyywrap

%%

[0-9]+\.[0-9]+ 		{
					 	/*Code*/
					 	yylval.flot = atof(yytext);
						return FLOAT;
					 }

[0-9]+ 				 {
					 	/*Code*/
					 	yylval.integer = atoi(yytext); 
						return INTEGER;
					 }

"+"                  { return PLUS;       }
"-"                  { return MINUS;      }
"*"                  { return TIMES;      }
"/"                  { return SLASH;      }
"("                  { return LPAREN;     }
")"                  { return RPAREN;     }


"ls"				{return LS;}
"ps"				{return PS;}
"kill"				{return KILL;}
"mkdir"				{return MKDIR;}
"rmdir"				{return RMDIR;}
"cd"				{return CD;}
"touch"				{return TOUCH;}
"ifconfig"			{return IFCONFIG;}
"start"				{return START;}
"quit"				{return QUIT;}



[ \t] ; /* ignora espaços e tabs (\t) */
 \n return FIM_LINHA;

[~a-zA-Z0-9\.()_/]+ {
						/*Code*/
						yylval.string = (yytext);
						return WORD;
					}
. 					{ return ERROR; }

%%

//int main(int i, char** c) 
//{
//	yylex();
//}