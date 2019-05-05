%locations
%define parse.error verbose

%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <ctype.h>
// int idC = 1;
// char ids[];
// int lexErrorsC = 1;
// char lexErrors[];
// // int lines = 1;
// void yyerror(char *);
%}

%token LIBRARY
%token MAIN
%token VOID
%token PRINT
%token SCAN
%token ARGS
%token RETURN

%token IF
%token ELSE
%token WHILE
%token DO
%token FOR
%token SWITCH
%token CASE
%token DEFAULT
%token BREAK

%token PRIMITIVE
%token ID
%token CTE_INT
%token CTE_FLOAT
%token CTE_STRING
%token CTE_BOOL

%token OP_AND
%token OP_OR
%token OP_EQ
%token OP_NEQ
%token OP_LEQ
%token OP_GEQ
%token OP_INCREMENT 
%token OP_DECREMENT

%token JUMP_LINE

%token '='
%token '('
%token ')'
%token '\"'
%token '*'
%token '+'
%token '-'
%token '/'
%token '^'
%token '%'
%token '!'
%token '>'
%token '<'
%token '{'
%token '}'
%token ';'
%token ','

%start PROGRAM

%%

PROGRAM: 
    J LIBRARY J OPTIONAL_DECLARATION J BEGIN_FUNCTION J {printf("PROGRAM LEFT\n");}
  | J OPTIONAL_DECLARATION J BEGIN_FUNCTION J {printf("PROGRAM RIGHT\n");}
  ;

J:
    JUMP //{printf("JUMP EXISTS\n");}
  | /* NULL */ //{printf("JUMP NULL\n");}
  ;
  
JUMP:  
    JUMP_LINE
  | JUMP_LINE JUMP
  ;

DECLARATION:
    PRIMITIVE J ID J '=' J CTES J ';' J {printf("DECLARATION LEFT\n");}
  | PRIMITIVE J ID J '=' J CTES J DECLARATION_LIST ';' J {printf("DECLARATION RIGHT - ");}
  | PRIMITIVE J ID J ';' J
   ;

OPTIONAL_DECLARATION:
    J DECLARATION J {printf("DECLARATION EXISTS\n");}
  | /* NULL */ {printf("DECLARATION NULL\n");}
  ;

DECLARATION_LIST:
    J ID J '=' J EXPRESSION J {printf("DECLARATION_LIST LEFT\n");}
  | ',' J DECLARATION_LIST J {printf("DECLARATION_LIST RIGHT - ");}
  ;

CTES: 
    J ID J {printf("CTES ID\n");}
  | J CTE_INT J {printf("CTES INT\n");}  
  | J CTE_FLOAT J {printf("CTES FLOAT\n");}
  | J CTE_STRING J {printf("CTES STRING\n");}
  | J STRING_CHAIN J {printf("CTES STRING CHAIN\n");}
  ;

STRING_CHAIN:
  '"' J CHAIN J {printf("STRING_CHAIN - ");} ; 

CHAIN:
    J CTES J CHAIN J {printf("CHAIN LEFT - ");}
  | J '"' J {printf("CHAIN RIGHT\n");}
  ;

BEGIN_FUNCTION: 
  VOID_PRIMITIVE J MAIN J '(' J OPTIONAL_ARGS J ')' J '{' J STATEMENT_LIST J '}' J {printf("BEGIN_FUNCTION\n");} ; 

OPTIONAL_ARGS:
      J ARGS J {printf("OPTIONAL_ARGS EXISTS\n");}
    | /* NULL */ {printf("OPTIONAL_ARGS NULL\n");}
    ;

VOID_PRIMITIVE:
    J VOID J {printf("VOID\n");}
  | J PRIMITIVE J {printf("PRIMITIVE\n");}
  ;

STATEMENT:
    J ';' J {printf("STATEMENT ;\n");}  
  | J DECLARATION J {printf("DECLARATION\n");}        
  | J ID J '=' J EXPRESSION J ';' J {printf("ID = EXPRESSION\n");}                  
  | J EXPRESSION J ';' J {printf("EXPRESSION ;\n");}                    
  | J PRINT J OPTIONAL_ARGS_EXPRESSION J ';' J {printf("PRINT OPTIONAL_ARGS_EXPRESSION ;\n");}               
  | J SCAN J OPTIONAL_ARGS_EXPRESSION J ';' J {printf("SCAN OPTIONAL_ARGS_EXPRESSION ;\n");} 
  | J WHILE J '(' J EXPRESSION J ')' J STATEMENT J {printf("WHILE (EXPRESSION)\n");}         
  | J IF J '(' J EXPRESSION J ')' J STATEMENT J {printf("IF (EXPRESSION) STATEMENT\n");} 
  | J IF J '(' J EXPRESSION J ')' J STATEMENT ELSE J STATEMENT J {printf("IF (EXPRESSION) STATEMENT ELSE STATEMENT\n");} 
  | J '{' J STATEMENT_LIST J '}' J {printf("{STATEMENT_LISTT_LIST\n");} 
  | J FOR_STATEMENT J {printf("FOR_STATEMENT\n");} 
  // | error { printError(@$.last_column); }
  | J DO_STATEMENT J {printf("DO_STATEMENT\n");} 
  | J SWITCH_STATEMENT J {printf("SWITCH_STATEMENT\n");} 
  ;

STATEMENT_LIST:
    J STATEMENT J {printf("STATEMENT_LIST LEFT\n");}
  | J STATEMENT J STATEMENT_LIST J {printf("STATEMENT_LIST RIGHT\n");}   
  ;

FOR_STATEMENT:
  J FOR J
  '(' J ID J '=' J INT_CTES J ';' J
  ASSIGN_LOGIC_EXPRESSION J ';' J
  ASSIGN_MATH_EXPRESSION J ')' J
  STATEMENT J
  {printf("FOR\n");}
  // | error {printError(@$.last_column);}
  ;       

DO_STATEMENT: 
  J DO J '{' J STATEMENT J '}' J WHILE  J'(' J EXPRESSION J ')' J ';' J {printf("DO\n");} ;

SWITCH_STATEMENT:
  J SWITCH J '(' J EXPRESSION J ')' J '{' J 
  CASES J 
  DEFAULT_STATEMENT J 
  {printf("SWITCH\n");}
  ;

CASES:
    J CASE J EXPRESSION J ':' J STATEMENT BREAK J ';' J {printf("CASES LEFT\n");}
  | J CASE J EXPRESSION J ':' J STATEMENT BREAK J ';' J CASES J {printf("CASES RIGHT - ");}
  ;

DEFAULT_STATEMENT:
    J DEFAULT J ':' J STATEMENT J '}' J {printf("DEFAULT_STATEMENT LEFT\n");}
  | J '}' J {printf("DEFAULT_STATEMENT RIGHT\n");}
  ;

INT_CTES:
    J ID J {printf("INT_CTES LEFT\n");}
  | J CTE_INT J {printf("INTE_CTES RIGHT\n");}
  ;     

EXPRESSION:
    J CTES J {printf("CTES\n");}
	| J ASSIGN_MATH_EXPRESSION J {printf("ASSIGN_MATH_EXPRESSION\n");}
  | J ASSIGN_LOGIC_EXPRESSION J {printf("ASSIGN_LOGIC_EXPRESSION\n");}
  | J '(' J EXPRESSION J ')' J {printf("EXPRESSION\n");}   
  ;

ASSIGN_MATH_EXPRESSION:
    J ID J '=' J MATH_EXPRESSION J {printf("ASSIGN_MATH_EXPRESSION LEFT\n");}
  | J MATH_EXPRESSION J {printf("ASSIGN_MATH_EXPRESSION RIGHT\n");}
  ;

MATH_EXPRESSION:
    J EXPRESSION J MATH_OPS J EXPRESSION J {printf("EXPRESSION MATH_OPS EXPRESSION\n");}
  | J OP_INCREMENT J ID J {printf("OP_INCREMENT EXPRESSION\n");}
  | J ID J OP_INCREMENT J {printf("ID OP_INCREMENT\n");}
  | J OP_DECREMENT J ID J {printf("OP_DECREMENT EXPRESSION\n");}
  | J ID J OP_DECREMENT J {printf("ID OP_DECREMENT\n");}
  ;

ASSIGN_LOGIC_EXPRESSION:
    J ID J '=' J LOGIC_EXPRESSION J {printf("LOGIC_EXPRESSION LEFT\n");}
  | J LOGIC_EXPRESSION J {printf("LOGIC_EXPRESSION RIGHT - ");}
  ;

LOGIC_EXPRESSION:
    J '!' J EXPRESSION J {printf("!EXPRESSION\n");}
  | J EXPRESSION J LOGIC_OPS J EXPRESSION J {printf("EXPRESSION LOGIC_OPS EXPRESSION\n");}
  | J CTE_BOOL J {printf("CTE_BOOL\n");}
  ;

MATH_OPS:
    '^' {printf("^\n");}
  | '+' {printf("+\n");}
  | '-' {printf("-\n");}
  | '*' {printf("*\n");}
  | '/' {printf("/\n");}
  | '%' {printf("%\n");}
  ;

LOGIC_OPS:   
    OP_AND {printf("OP_AND\n");}
  | OP_OR  {printf("OP_OR\n");}
  | OP_EQ  {printf("OP_EQ\n");}
  | OP_NEQ {printf("OP_NEQ\n");}
  | OP_LEQ {printf("OP_LEQ\n");}
  | OP_GEQ {printf("OP_GEQ\n");}
  | '<' {printf("<\n");}
  | '>' {printf(">\n");}
  ;

ARGS_EXPRESSION:
    J EXPRESSION J {printf("ARGS_EXPRESSION LEFT - ");}
  | J ARGS_EXPRESSION ',' J ARGS_EXPRESSION J {printf("ARGS_EXPRESSION RIGHT\n");}
  ;

OPTIONAL_ARGS_EXPRESSION:
    J '(' J ARGS_EXPRESSION J ')' J {printf("OPTIONAL_ARGS_EXPRESSION EXISTS\n");}
  | /* NULL */ {printf("OPTIONAL_ARGS_EXPRESSION NULL\n");}
  ;

%%

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern FILE *yyout;
extern int yylineno;

void yyerror(char *s) {
  fprintf(stdout, "Error in line %d: %s\n", (yylineno-1), s);
}

void printError(int a) {
  fprintf(stdout, "Error in line %d:%d Syntax Error\n", (yylineno-1), a);
}

int main(int argc, char *argv[]) {
	printf("Lo que has recibido en el argv[1] es: %s\n", argv[1]);
	FILE *fp = fopen(argv[1], "r");
	FILE *out_file = fopen("salida.txt", "w"); // write only
	if (!fp) {
		fprintf(out_file,"\nNo se encuentra el archivo...\n");
		return(-1);
	}
	yyin = fp;
	yyout = out_file;

	// yylex();
	// do {
	// 	yyparse();
	// } while (!feof(yyin));
	yyparse();

	// fprintf(out_file,"\n\nTABLA DE INDENTIFICADORES\n");
	// fprintf(out_file, "Hay %d identificadores\n", idC-1);
	// // fprintf(out_file, "%s", ids);
	// if (idC>1)
	// {
	//   int i=0;
	//   fprintf(out_file, "Id=");
	//   while (i < strlen(ids)) 
	//   {    
	//     fprintf(out_file, "%c", ids[i]);
	//     if (ids[i] == ';')
	//     {
	//       fprintf(out_file, " Id=");
	//     }
	//     i = i + 1;
	//   }
	// }
	// fprintf(out_file, "\n");

	// fprintf(out_file,"\n\nERRORES LEXICOS\n");
	// fprintf(out_file, "Hay %d errores lexicos\n", lexErrorsC-1);
	// fprintf(out_file, "%s", lexErrors);
	
	// fprintf(out_file, "\n");
	// fprintf(out_file,"\n\nHay %d lineas de codigo\n", lines);
	fclose(out_file);
	fclose(fp);

	return(0);
}