%{

 #include <stdio.h>

%}

%option noyywrap
%%


"+"                  { return PLUS;       }
"-"                  { return MINUS;      }
"*"                  { return TIMES;      }
"/"                  { return SLASH;      }
"("                  { return LPAREN;     }
")"                  { return RPAREN;     }

[0-9]+\.[0-9]+ 		{
					 	/*Code*/
						yylval.dval = atof(yytext);
						return FLOAT;
					 }

[0-9]+ 				 {
					 	/*Code*/
						yylval.dval = atof(yytext);
						return INTEGER;
					 }

[A-Za-z]+ 			{
						/*Code*/
						struct symtab *sp = symlook(yytext);
						yylval.symp = sp;
						return WORD;
					}

"ls"				{return LS;}
"kill"				{return KILL;}
"mkdir"				{return MKDIR;}
"rmdir"				{return RMDIR;}
"cd"				{return CD;}
"touch"				{return TOUCH;}
"ifconfig"			{return IFCONFIG;}
"start"				{return START;}
"quit"				{return QUIT;}

. 					{ return yytext[0]; } 

[ \t\n];

%%

int main(int i, char** c) 
{
	yylex();
}