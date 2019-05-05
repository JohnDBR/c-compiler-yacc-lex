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
    LIBRARY OPTIONAL_DECLARATION BEGIN_FUNCTION {printf("PROGRAM LEFT\n");}
  | OPTIONAL_DECLARATION BEGIN_FUNCTION {printf("PROGRAM RIGHT\n");}
  ;

DECLARATION:
    PRIMITIVE ID '=' CTES ';' {printf("DECLARATION LEFT\n");}
  | PRIMITIVE ID '=' CTES DECLARATION_LIST ';' {printf("DECLARATION RIGHT - ");}
  | PRIMITIVE ID ';'
   ;

OPTIONAL_DECLARATION:
    DECLARATION {printf("DECLARATION EXISTS\n");}
  | /* NULL */ {printf("DECLARATION NULL\n");}
  ;

DECLARATION_LIST:
    ID '=' CTES {printf("DECLARATION_LIST LEFT\n");}
  | ',' DECLARATION_LIST {printf("DECLARATION_LIST RIGHT - ");}
  ;

CTES: 
    ID {printf("CTES ID\n");}
  | CTE_INT {printf("CTES INT\n");}  
  | CTE_FLOAT {printf("CTES FLOAT\n");}
  | CTE_STRING {printf("CTES STRING\n");}
  | STRING_CHAIN {printf("CTES STRING CHAIN\n");}
  ;

STRING_CHAIN:
  '"' CHAIN {printf("STRING_CHAIN - ");} ; 

CHAIN:
    CTES CHAIN {printf("CHAIN LEFT - ");}
  | '"' {printf("CHAIN RIGHT\n");}
  ;

BEGIN_FUNCTION: 
  VOID_PRIMITIVE MAIN '(' OPTIONAL_ARGS ')' '{' STATEMENT_LIST '}' {printf("BEGIN_FUNCTION\n");} ; 

OPTIONAL_ARGS:
      ARGS {printf("OPTIONAL_ARGS EXISTS\n");}
    | /* NULL */ {printf("OPTIONAL_ARGS NULL\n");}
    ;

VOID_PRIMITIVE:
    VOID {printf("VOID\n");}
  | PRIMITIVE {printf("PRIMITIVE\n");}
  ;

STATEMENT:
    ';' {printf("STATEMENT ;\n");}  
  | DECLARATION {printf("DECLARATION\n");}                         
  | EXPRESSION ';' {printf("EXPRESSION ;\n");}                    
  | PRINT OPTIONAL_ARGS_EXPRESSION ';' {printf("PRINT OPTIONAL_ARGS_EXPRESSION ;\n");}               
  | SCAN OPTIONAL_ARGS_EXPRESSION ';' {printf("SCAN OPTIONAL_ARGS_EXPRESSION ;\n");} 
  | ID '=' EXPRESSION ';' {printf("ID = EXPRESSION\n");} 
  | WHILE '(' EXPRESSION ')' STATEMENT {printf("WHILE (EXPRESSION)\n");}         
  | IF '(' EXPRESSION ')' STATEMENT {printf("IF (EXPRESSION) STATEMENT\n");} 
  | IF '(' EXPRESSION ')' STATEMENT ELSE STATEMENT {printf("IF (EXPRESSION) STATEMENT ELSE STATEMENT\n");} 
  | '{' STATEMENT_LIST '}' {printf("{STATEMENSTATEMENT_LISTT_LIST\n");} 
  | FOR_STATEMENT {printf("FOR_STATEMENT\n");} 
  // | error { printError(@$.last_column); }
  | DO_STATEMENT {printf("DO_STATEMENT\n");} 
  | SWITCH_STATEMENT {printf("SWITCH_STATEMENT\n");} 
  ;

STATEMENT_LIST:
    STATEMENT {printf("STATEMENT_LIST LEFT\n");}
  | STATEMENT STATEMENT_LIST {printf("STATEMENT_LIST RIGHT\n");}   
  ;

FOR_STATEMENT:
  FOR 
  '(' ID '=' INT_CTES ';'
  ASSIGN_LOGIC_EXPRESSION ';'
  ASSIGN_MATH_EXPRESSION ')' 
  STATEMENT
  {printf("FOR\n");}
  // | error {printError(@$.last_column);}
  ;       

DO_STATEMENT: 
  DO '{' STATEMENT '}' WHILE '(' EXPRESSION ')' ';' {printf("DO\n");} ;

SWITCH_STATEMENT:
  SWITCH '(' EXPRESSION ')' '{' 
  CASES
  DEFAULT_STATEMENT
  {printf("SWITCH\n");}
  ;

CASES:
    CASE EXPRESSION ':' STATEMENT BREAK ';' {printf("CASES LEFT\n");}
  | CASE EXPRESSION ':' STATEMENT BREAK ';' CASES {printf("CASES RIGHT - ");}
  ;

DEFAULT_STATEMENT:
    DEFAULT ':' STATEMENT '}' {printf("DEFAULT_STATEMENT LEFT\n");}
  | '}' {printf("DEFAULT_STATEMENT RIGHT\n");}
  ;

INT_CTES:
    ID {printf("INT_CTES LEFT\n");}
  | CTE_INT {printf("INTE_CTES RIGHT\n");}
  ;     

EXPRESSION:
    CTES {printf("CTES\n");}
	| ASSIGN_MATH_EXPRESSION {printf("ASSIGN_MATH_EXPRESSION\n");}
  | ASSIGN_LOGIC_EXPRESSION {printf("ASSIGN_LOGIC_EXPRESSION\n");}
  | '(' EXPRESSION ')' {printf("EXPRESSION\n");}   
  ;

ASSIGN_MATH_EXPRESSION:
    ID '=' MATH_EXPRESSION {printf("ASSIGN_MATH_EXPRESSION LEFT\n");}
  | MATH_EXPRESSION {printf("ASSIGN_MATH_EXPRESSION RIGHT\n");}
  ;

MATH_EXPRESSION:
    EXPRESSION MATH_OPS EXPRESSION {printf("EXPRESSION MATH_OPS EXPRESSION\n");}
  | OP_INCREMENT ID {printf("OP_INCREMENT EXPRESSION\n");}
  | ID OP_INCREMENT {printf("ID OP_INCREMENT\n");}
  | OP_DECREMENT ID {printf("OP_DECREMENT EXPRESSION\n");}
  | ID OP_DECREMENT {printf("ID OP_DECREMENT\n");}
  ;

ASSIGN_LOGIC_EXPRESSION:
    ID '=' LOGIC_EXPRESSION {printf("LOGIC_EXPRESSION LEFT\n");}
  | LOGIC_EXPRESSION {printf("LOGIC_EXPRESSION RIGHT - ");}
  ;

LOGIC_EXPRESSION:
    '!' EXPRESSION {printf("!EXPRESSION\n");}
  | EXPRESSION LOGIC_OPS EXPRESSION {printf("EXPRESSION LOGIC_OPS EXPRESSION\n");}
  | CTE_BOOL {printf("CTE_BOOL\n");}
  ;

MATH_OPS:
    '^' {printf("^\n");}
  | '+' {printf("+\n");}
  | '-' {printf("-\n");}
  | '*' {printf("*\n");}
  | '/' {printf("/\n");}
  | '%' {printf("% \n");}
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
    EXPRESSION {printf("ARGS_EXPRESSION LEFT - ");}
  | ARGS_EXPRESSION ',' ARGS_EXPRESSION {printf("ARGS_EXPRESSION RIGHT\n");}
  ;

OPTIONAL_ARGS_EXPRESSION:
    '(' ARGS_EXPRESSION ')' {printf("OPTIONAL_ARGS_EXPRESSION EXISTS\n");}
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