%option noyywrap
%option yylineno
%{
/* Libreria basica de C++ y manejar strings*/
#include<stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
/* Esta libreria es necesaria para el atoi() atof() */	
//#include <math.h>
int idC = 1;
char ids[100000];
int lexErrorsC = 1;
char lexErrors[100000];
int lines = 1;
int yaccErrorsC = 1;
char yaccErrors[100000];
// void yyerror(char *);
%}
	
ID 			[a-zA-Z][0-9a-zA-Z]*
CTE-ENTERA	[-+]?[0-9]+
CTE-REAL	[-+]?[0-9]+((".")[0-9]+)?([eE][-+]?[0-9]+((".")[0-9]+)?)?
ERROR 		[0-9]+[0-9a-zA-Z]+
%%

"\#"" "*"include"" "*"<".*">"    {fprintf(yyout, "INCLUIR-LIBRERIA:%s", yytext); return LIBRARY;}
"include"		{fprintf(yyout, "INCLUIR-LIBRERIA:%s", yytext); return INCLUDE;}
".h"				{fprintf(yyout, "EXTENSION-LIBRERI:%s",yytext); return LIBRARY_EXTENSION;}

"main"			{fprintf(yyout, "MAIN:%s", yytext); return MAIN;}
"void"			{fprintf(yyout, "VOID:%s", yytext); return VOID;}

"printf"		{fprintf(yyout, "INS-ESCRIBIR:%s", yytext); return PRINT;}
"scanf"			{fprintf(yyout, "INS-LEER:%s", yytext); return SCAN;}

"*"*"argc"			{fprintf(yyout, "CONT-ARGUMENTOS:%s", yytext); return ARGS;}

"*"*"argv"|"*"*"argv[]"				{fprintf(yyout, "ARGUMENTOS:%s", yytext); return ARGS;}

"return"		{fprintf(yyout, "INS-RETORNAR:%s", yytext); return RETURN;}

"if"			{fprintf(yyout, "SI:%s", yytext); return IF;}
"else"			{fprintf(yyout, "SINO:%s", yytext); return ELSE;}
"while"			{fprintf(yyout, "MIENTRAS-QUE:%s", yytext); return WHILE;}
"do"			{fprintf(yyout, "HACER:%s", yytext); return DO;}
"for"			{fprintf(yyout, "PARA:%s", yytext); return FOR;}
"switch"		{fprintf(yyout, "DEPENDIENDO-DE:%s", yytext); return SWITCH;}
"case"			{fprintf(yyout, "CASO-DEPENDIENDO-DE:%s", yytext); return CASE;}
"default"		{fprintf(yyout, "CASO-PREDETERMINADO-DEPENDIENDO-DE:%s", yytext); return DEFAULT;}
"break"			{fprintf(yyout, "INS-TERMINAR:%s", yytext); return BREAK;}

"int"|"double"|"float"|"char"|"string"|"String"			{fprintf(yyout, "TIPO:%s", yytext); return PRIMITIVE;}
"TRUE"|"True"|"true"			{fprintf(yyout, "CTE-BOOL:%s", yytext); return CTE_BOOL;}
"FALSE"|"False"|"false"			{fprintf(yyout, "CTE-BOOL:%s", yytext); return CTE_BOOL;}

{ID}			{
					fprintf(yyout, "ID:%s", yytext);	
					char *token;
				    char temp[9999];
				    strcpy(temp,ids);
				    int save = 1;
				    token = strtok(temp, ";");
				    while(token != NULL && save) 
				    {
				        if (strcmp(token,yytext) == 0)
				        {
				            save = 0;
				        }
				        token = strtok(NULL, ";");
				    }
				    if (save)
				    {
				        if (idC > 1)
				        {
				            strcat(ids,";");
				        }
				        strcat(ids,yytext);
				        idC = idC + 1;
				    }
					return ID;
				}

"<--"|"=" 		{fprintf(yyout, "OP-ASIGN:%s", yytext); return '=';}

{CTE-ENTERA}	{fprintf(yyout, "CTE-ENTERA:%s", yytext); return CTE_INT;}
{CTE-REAL}		{fprintf(yyout, "CTE-REAL:%s", yytext); return CTE_FLOAT;}
\".*\"|\'.*\'	{fprintf(yyout, "CTE-CADENA:%s", yytext); return CTE_STRING;}

"//".*\n?       				{fprintf(yyout, "");}
"/*"([^*]|\*+[^*/])*\*+"/"		{fprintf(yyout, "");} 

"(" 			{fprintf(yyout, "PARENT-A:%s", yytext); return '(';}
")" 			{fprintf(yyout, "PARENT-C:%s", yytext); return ')';}
\"				{fprintf(yyout, "QUOTE:%s", yytext); return '"';}
\#        {fprintf(yyout, "INSERT:%s", yytext); return '#';} 

"*"				{fprintf(yyout, "OP-MULT:%s", yytext); return '*';}
"+"				{fprintf(yyout, "OP-SUMA:%s", yytext); return '+';}
"-"				{fprintf(yyout, "OP-SUST:%s", yytext); return '-';}
"/"				{fprintf(yyout, "OP-DIV:%s", yytext); return '/';}
"++"			{fprintf(yyout, "OP-INCREMENT:%s", yytext); return OP_INCREMENT;}
"--"			{fprintf(yyout, "OP-DECREMENT:%s", yytext); return OP_DECREMENT;}
"^"				{fprintf(yyout, "OP-EXP:%s", yytext); return '^';}
"%"				{fprintf(yyout, "OP-MOD:%s", yytext); return '%';}
"&&"			{fprintf(yyout, "OP-Y:%s", yytext); return OP_AND;}
"||"			{fprintf(yyout, "OP-O:%s", yytext); return OP_OR;}
"~"|"!"			{fprintf(yyout, "OP-NO:%s", yytext); return '!';}

"=="			{fprintf(yyout, "IGUAL-QUE:%s", yytext); return OP_EQ;}
">"				{fprintf(yyout, "MAYOR-QUE:%s", yytext); return '>';}
"<"				{fprintf(yyout, "MENOR-QUE:%s", yytext); return '<';}
"<>"|"!="		{fprintf(yyout, "DIFERENTE-DE:%s", yytext); return OP_NEQ;}
"<="			{fprintf(yyout, "MENOR-O-IGUAL-QUE:%s", yytext); return OP_LEQ;}
">="			{fprintf(yyout, "MAYOR-O-IGUAL-QUE:%s", yytext); return OP_GEQ;}

"{" 			{fprintf(yyout, "INICIO:%s", yytext); return '{';}
"}"				{fprintf(yyout, "FIN:%s", yytext); return '}';}

" "				{fprintf(yyout, " ");}	
\t 				{fprintf(yyout, "\t");}
\n				{fprintf(yyout, "\n");++lines;}
\r				{fprintf(yyout, "\r");}

";"				{fprintf(yyout, "PUNTO-COMA:%s", yytext); return ';';}
":"				{fprintf(yyout, "DOS-PUNTOS:%s", yytext); return ':';}
","				{fprintf(yyout, "COMA:%s", yytext); return ',';}

{ERROR}			{
					fprintf(yyout, "CARACTER-NO-RECONOCIDO:%s", yytext);
					char *token;
				    char temp[9999];
				    strcpy(temp,lexErrors);
				    int save = 1;
				    token = strtok(temp, ";");
				    while(token != NULL && save) 
				    {
				        if (strcmp(token,yytext) == 0)
				        {
				            save = 0;
				        }
				        token = strtok(NULL, ";");
				    }
				    if (save)
				    {
				        if (lexErrorsC > 1)
				        {
				            strcat(lexErrors,";");
				        }
				        strcat(lexErrors,yytext);
				        lexErrorsC = lexErrorsC + 1;
				    }
					saveError(1, "");
					// yyerror("Unknown character");
				}
.           	{fprintf(yyout, "CARACTER-NO-RECONOCIDO:%s", yytext);
					if (!strstr(lexErrors, yytext))
					{
						if (lexErrorsC > 1)
						{
							strcat(lexErrors,";");
						}
						strcat(lexErrors,yytext);
						lexErrorsC = lexErrorsC + 1;
					}
					saveError(1, "");
					// yyerror("Unknown character!");
				}

%%

void printError() {
  fprintf(stdout, "Error in line %d Syntax Error\n", (yylineno-1));
}

void saveError(int lex, char *s) {
	char *token;
	char temp[1000];
	char error_word[1000];
	if (lex) {
		snprintf(error_word, 20, "%d Lex", lines);
	} else {
		snprintf(error_word, 20, "%d Syntax", lines);
	}
	strcpy(temp,yaccErrors);
	int save = 1;
	token = strtok(temp, ";");
	while(token != NULL && save) 
	{
		if (strcmp(token,error_word) == 0)
		{
			save = 0;
		}
		token = strtok(NULL, ";");
	}
	if (save)
	{
		if (yaccErrorsC > 1)
		{
			strcat(yaccErrors,";");
		}
		sprintf(yaccErrors, "%s%s", yaccErrors, error_word);
		yaccErrorsC = yaccErrorsC + 1;
	}
}

void printTables() {
  fprintf(yyout,"\n\nTABLA DE INDENTIFICADORES\n");
	fprintf(yyout, "Hay %d identificadores\n", idC-1);
	if (idC>1)
	{
	  int i=0;
	  fprintf(yyout, "Id=");
	  while (i < strlen(ids)) 
	  {    
	    fprintf(yyout, "%c", ids[i]);
	    if (ids[i] == ';')
	    {
	      fprintf(yyout, " Id=");
	    }
	    i = i + 1;
	  }
	}
	fprintf(yyout, "\n");

	fprintf(yyout,"\n\nERRORES LEXICOS\n");
	fprintf(yyout, "Hay %d errores lexicos\n", lexErrorsC-1);
	fprintf(yyout, "%s", lexErrors);
	
	fprintf(yyout, "\n");
	fprintf(yyout,"\nHay %d lineas de codigo\n", lines);

	fprintf(yyout, "Hay %d errores\n", yaccErrorsC-1);
	if (yaccErrorsC>1)
	{
	  int i=0;
	  fprintf(yyout, "Error in line ");
	  while (i < strlen(yaccErrors)) 
	  {    
	    fprintf(yyout, "%c", yaccErrors[i]);
	    if (yaccErrors[i] == ';')
	    {
	      fprintf(yyout, "\nError in line ");
	    }
	    i = i + 1;
	  }
	  fprintf(yyout,";\n");
	}
}
