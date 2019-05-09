%locations
%define parse.error verbose

%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <ctype.h>
%}

%token LIBRARY
%token INCLUDE
%token LIBRARY_EXTENSION
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
%token '#'

%start PROGRAM

%%

PROGRAM: 
  //  BOOKSTORE BEGIN_FUNCTION 
    BOOKSTORE OPTIONAL_DECLARATION
  | error OPTIONAL_LIST_ASSIGN_EXPRESSION '{' STATEMENT_LIST '}'
  // | error //{ saveError(0); }
  ;

BOOKSTORE:
    BOOKSHELVE BOOKSTORE
  | /* NULL */
  ;

BOOKSHELVE:
    LIBRARY
  | '#' INCLUDE '<' ID LIBRARY_EXTENSION '>'
  | error
  ;

DECLARATION:
    PRIMITIVE ID '=' CTES ';' 
  | PRIMITIVE ID '=' CTES DECLARATION_LIST ';' 
  | PRIMITIVE ASSIGN_EXPRESSIONS ';' 
  | PRIMITIVE ASSIGN_EXPRESSIONS ASSIGN_EXPRESSIONS_LIST ';' 
  | PRIMITIVE ID DECLARATION_LIST ';'
  | PRIMITIVE ID ';'
  ;

OPTIONAL_DECLARATION:
    // BEGIN_FUNCTION
    INIT
  | DECLARATION
  | DECLARATION OPTIONAL_DECLARATION
  | error
  // | error OPTIONAL_LIST_ASSIGN_EXPRESSION '{' STATEMENT_LIST '}'
  ;

INIT:
    BEGIN_FUNCTION
  | error OPTIONAL_LIST_ASSIGN_EXPRESSION '{' STATEMENT_LIST '}'
  ;

DECLARATION_LIST:
    ',' ID  
  | ',' ID '=' CTES
  | ',' ID ',' DECLARATION_LIST
  | ',' ID '=' CTES ',' DECLARATION_LIST 
  ;

ASSIGN_EXPRESSIONS_LIST:
    ',' ASSIGN_EXPRESSIONS 
  | ',' ASSIGN_EXPRESSIONS ',' ASSIGN_EXPRESSIONS_LIST 
  ;

BEGIN_FUNCTION: 
    VOID_PRIMITIVE MAIN '(' OPTIONAL_ARGS ')' '{' STATEMENT_LIST '}'
  | error '{' STATEMENT_LIST '}'
  // | error //{ saveError(0); }
  ; 

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
  | DECLARATION                   
  | EXPRESSION ';'   
  | ASSIGN_EXPRESSIONS ';'                
  | PRINT OPTIONAL_ARGS_EXPRESSION ';'               
  | SCAN OPTIONAL_ARGS_EXPRESSION ';' 
  | ID '=' EXPRESSION ';' 
  | WHILE '(' EXPRESSION ')' STATEMENT          
  | IF '(' EXPRESSION ')' STATEMENT 
  | IF '(' EXPRESSION ')' STATEMENT ELSE STATEMENT  
  | '{' STATEMENT_LIST '}' 
  | FOR_STATEMENT 
  | DO_STATEMENT 
  | SWITCH_STATEMENT
  | error //{ saveError(0); }
  ;

STATEMENT_LIST:
    STATEMENT 
  | STATEMENT STATEMENT_LIST 
  | /* NULL */
  ;

FOR_STATEMENT:
  FOR 
  '(' ID '=' INT_CTES ';'
  ASSIGN_LOGIC_EXPRESSION ';'
  ASSIGN_MATH_EXPRESSION ')' 
  STATEMENT
  | FOR 
    '(' PRIMITIVE ID '=' INT_CTES ';'
    ASSIGN_LOGIC_EXPRESSION ';'
    ASSIGN_MATH_EXPRESSION ')' 
    STATEMENT
  ;       

DO_STATEMENT: 
  DO '{' STATEMENT_LIST '}' WHILE '(' EXPRESSION ')' ';';

SWITCH_STATEMENT:
  SWITCH '(' EXPRESSION ')' '{' 
  CASES
  DEFAULT_STATEMENT
  ;

CASES:
    CASE EXPRESSION ':' STATEMENT_LIST BREAK ';' 
  | CASE EXPRESSION ':' STATEMENT_LIST BREAK ';' CASES
  | CASE EXPRESSION ':' STATEMENT_LIST error CASES
  | error 
  ;

DEFAULT_STATEMENT:
    DEFAULT ':' STATEMENT_LIST '}' 
  | '}' 
  ;

INT_CTES:
    ID 
  | CTE_INT 
  ;     

ASSIGN_EXPRESSIONS:
    ID '=' LOGIC_EXPRESSION 
  | ID '=' MATH_EXPRESSION 
  ;

OPTIONAL_LIST_ASSIGN_EXPRESSION:
    ASSIGN_EXPRESSIONS
  | ASSIGN_EXPRESSIONS ';' LIST_ASSIGN_EXPRESSION
  | /* NULL */
  ;

LIST_ASSIGN_EXPRESSION:
    ASSIGN_EXPRESSIONS
  | ASSIGN_EXPRESSIONS ';' LIST_ASSIGN_EXPRESSION
  ; 

MATH_EXPRESSION:
    EXPRESSION MATH_OPS EXPRESSION 
  | OP_INCREMENT ID 
  | ID OP_INCREMENT 
  | OP_DECREMENT ID 
  | ID OP_DECREMENT 
  | CLOSE_MATH_EXPRESSION
  ;

CLOSE_MATH_EXPRESSION:
    CTE_INT
  | CTE_INT CLOSE_MATH_EXPRESSION
  ;

ASSIGN_MATH_EXPRESSION:
    ID '=' MATH_EXPRESSION 
  | MATH_EXPRESSION 
  ;

LOGIC_EXPRESSION:
    '!' EXPRESSION 
  | EXPRESSION LOGIC_OPS EXPRESSION 
  | CTE_BOOL 
  ;

ASSIGN_LOGIC_EXPRESSION:
    ID '=' LOGIC_EXPRESSION 
  | LOGIC_EXPRESSION 
  ;

EXPRESSION:
    CTES 
	| MATH_EXPRESSION 
  | LOGIC_EXPRESSION 
  | '(' EXPRESSION ')'   
  ;

CTES: 
    ID 
  | CTE_INT 
  | CTE_FLOAT 
  | CTE_STRING 
  | CTE_BOOL 
  | STRING_CHAIN 
  ;

STRING_CHAIN:
  '"' CHAIN; 

CHAIN:
    CTES CHAIN 
  | '"' 
  ;

MATH_OPS:
    '^' 
  | '+' 
  | '-' 
  | '*' 
  | '/'
  | '%' 
  | '+' '='
  | '-' '='
  | '*' '='
  | '/' '='
  ;

LOGIC_OPS:   
    OP_AND 
  | OP_OR  
  | OP_EQ  
  | OP_NEQ 
  | OP_LEQ 
  | OP_GEQ 
  | '<' 
  | '>' 
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
  saveError(0, s);
}

int main(int argc, char *argv[]) {
	printf("Lo que has recibido en el argv[1] es: %s\n", argv[1]);
	FILE *fp = fopen(argv[1], "r");
	FILE *out_file = fopen("salida.txt", "w"); 
	if (!fp) {
		fprintf(out_file,"\nNo se encuentra el archivo...\n");
		return(-1);
	}
	yyin = fp;
	yyout = out_file;

	yyparse();
  printTables();
	fclose(out_file);
	fclose(fp);

	return(0);
}