%locations

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

%token '='
%token '('
%token ')'
%token '"'
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
    LIBRARY OPTIONAL_DECLARATION BEGIN_FUNCTION
  | OPTIONAL_DECLARATION BEGIN_FUNCTION
  ;

DECLARATION:
    PRIMITIVE ID '=' CTES ';'
  | PRIMITIVE ID '=' CTES DECLARATION_LIST ';'
  ;

OPTIONAL_DECLARATION:
    DECLARATION
  | /* NULL */
  ;

DECLARATION_LIST:
    ID '=' CTES
  | ',' DECLARATION_LIST 
  ;

CTES: 
    ID               
  | CTE_INT
  | CTE_FLOAT
  | CTE_STRING
  | STRING_CHAIN
  ;

STRING_CHAIN:
  '"' CHAIN;

CHAIN:
    CTES CHAIN
  | '"'
  ;

BEGIN_FUNCTION: 
  VOID_PRIMITIVE MAIN '(' OPTIONAL_ARGS ')' '{' STATEMENT_LIST '}';

OPTIONAL_ARGS:
      ARGS 
    | /* NULL */
    ;

VOID_PRIMITIVE:
    VOID
  | PRIMITIVE
  ;

STATEMENT:
    ';'                            
  | EXPRESSION ';'                       
  | PRINT OPTIONAL_ARGS_EXPRESSION ';'                 
  | SCAN OPTIONAL_ARGS_EXPRESSION ';' 
  | ID '=' EXPRESSION ';'          
  | WHILE '(' EXPRESSION ')' STATEMENT        
  | IF '(' EXPRESSION ')' STATEMENT 
  | IF '(' EXPRESSION ')' STATEMENT ELSE STATEMENT 
  | '{' STATEMENT_LIST '}'
  | FOR_STATEMENT   
  // | error { printError(@$.last_column); }
  | DO_STATEMENT
  | SWITCH_STATEMENT        
  ;

STATEMENT_LIST:
    STATEMENT                 
  | STATEMENT_LIST STATEMENT        
  ;

FOR_STATEMENT:
  FOR 
  '(' ID '=' INT_CTES ';' 
  ASSIGN_LOGIC_EXPRESSION ';' 
  ASSIGN_MATH_EXPRESSION ')' 
  STATEMENT
  // | error {printError(@$.last_column);}
  ;       

DO_STATEMENT: 
  DO '{' STATEMENT '}' WHILE '(' EXPRESSION ')' ';';

SWITCH_STATEMENT:
  SWITCH '(' EXPRESSION ')' '{' 
  CASES
  DEFAULT_STATEMENT
  ;

CASES:
    CASE EXPRESSION ':' STATEMENT BREAK ';'
  | CASE EXPRESSION ':' STATEMENT BREAK ';' CASES
  ;

DEFAULT_STATEMENT:
    DEFAULT ':' STATEMENT '}' 
  | '}'
  ;

INT_CTES:
    ID 
  | CTE_INT
  ;     

EXPRESSION:
    CTES
	| ASSIGN_MATH_EXPRESSION
  | ASSIGN_LOGIC_EXPRESSION
  | '(' EXPRESSION ')'         
  ;

ASSIGN_MATH_EXPRESSION:
    ID '=' MATH_EXPRESSION
  | MATH_EXPRESSION
  ;

MATH_EXPRESSION:
    EXPRESSION MATH_OPS EXPRESSION 
  | OP_INCREMENT EXPRESSION
  | ID OP_INCREMENT  
  | OP_DECREMENT EXPRESSION
  | ID OP_DECREMENT
  ;

ASSIGN_LOGIC_EXPRESSION:
    ID '=' LOGIC_EXPRESSION
  | LOGIC_EXPRESSION
  ;

LOGIC_EXPRESSION:
    '!' EXPRESSION
  | EXPRESSION LOGIC_OPS EXPRESSION 
  | CTE_BOOL
  ;

MATH_OPS:
    '^' 
  | '+'   
  | '-'   
  | '*'   
  | '/'  
  | '%' 
  | '<'   
  | '>' 
  ;

LOGIC_OPS:   
    OP_AND
  | OP_OR    
  | OP_EQ 
  | OP_NEQ 
  | OP_LEQ 
  | OP_GEQ   
  ;

ARGS_EXPRESSION:
    EXPRESSION
  | ARGS_EXPRESSION ',' ARGS_EXPRESSION
  ;

OPTIONAL_ARGS_EXPRESSION:
    '(' ARGS_EXPRESSION ')' 
  | /* NULL */
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