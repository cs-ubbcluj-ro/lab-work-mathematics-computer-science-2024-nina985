%{
#include <stdio.h>
#include <stdlib.h>

int rule_index = 0; //track the rules used.
void yyerror(const char* s);
int yylex(void);

#define YYDEBUG 1
%}

%start program

/* token def from lexer */
%token INCLUDE IOSTREAM USING NAMESPACE STD MAINN INT CHAR STRUCT CIN COUT IF ELSE WHILE ENDL RETURN
%token SEMICOLON EQUAL LP RP COLON LBRACE RBRACE DOT
%token PLUS MINUS MULT DIV MOD
%token IDENTIFIER INTCONST CHARCONST STRING
%token LT LE GT GE EQ NE AND OR NOT HASH INOP OUTOP

%left PLUS MINUS
%left MULT DIV MOD
%left LT LE GT GE EQ NE
%left AND OR
%right NOT

%%

/* cfg rules */

program: preprocessor main_function
        { printf("Rule %d: program: preprocessor main_function\n", ++rule_index); }
        ;

preprocessor: HASH INCLUDE IOSTREAM ENDL USING NAMESPACE STD SEMICOLON ENDL
            { printf("Rule %d: preprocessor -> HASH INCLUDE IOSTREAM ENDL USING NAMESPACE STD SEMICOLON ENDL\n", ++rule_index); }
            ;

main_function: INT MAINN LP RP LBRACE ENDL script RBRACE
              { printf("Rule %d: main_function -> INT MAINN LP RP LBRACE ENDL script RBRACE\n", ++rule_index); }
              ;

script: declaration_list statement_list
       { printf("Rule %d: script -> declaration_list statement_list\n", ++rule_index); }
       ;

declaration_list: declaration
                { printf("Rule %d: declaration_list -> declaration\n", ++rule_index); }
                | declaration declaration_list
                { printf("Rule %d: declaration_list -> declaration declaration_list\n", ++rule_index); }
                | /* empty */
                { printf("Rule %d: declaration_list -> empty\n", ++rule_index); }
                ;

declaration: field
           { printf("Rule %d: declaration -> field\n", ++rule_index); }
           | STRUCT id LBRACE ENDL field_list RBRACE SEMICOLON ENDL
           { printf("Rule %d: declaration -> STRUCT id LBRACE ENDL field_list RBRACE SEMICOLON ENDL\n", ++rule_index); }
           ;

field_list: field
          { printf("Rule %d: field_list -> field\n", ++rule_index); }
          | field field_list
          { printf("Rule %d: field_list -> field field_list\n", ++rule_index); }
          ;

field: INT id SEMICOLON ENDL
     { printf("Rule %d: field -> INT id SEMICOLON ENDL\n", ++rule_index); }
     | INT id EQUAL expression SEMICOLON ENDL
     { printf("Rule %d: field -> INT id EQUAL expression SEMICOLON ENDL\n", ++rule_index); }
     | CHAR id SEMICOLON ENDL
     { printf("Rule %d: field -> CHAR id SEMICOLON ENDL\n", ++rule_index); }
     | CHAR id EQUAL CHARCONST SEMICOLON ENDL
     { printf("Rule %d: field -> id EQUAL CHARCONST SEMICOLON ENDL\n", ++rule_index); }
     ;

statement_list: statement
              { printf("Rule %d: statement_list -> statement\n", ++rule_index); }
              | statement ENDL
              { printf("Rule %d: statement_list -> statement ENDL\n", ++rule_index); }
              | statement statement_list
              { printf("Rule %d: statement_list -> statement statement_list\n", ++rule_index); }
              | /* empty */
              { printf("Rule %d: statement_list -> empty\n", ++rule_index); }
              ;

statement: assignment_stmt
         { printf("Rule %d: statement -> assignment_stmt\n", ++rule_index); }
         | input_stmt
         { printf("Rule %d: statement -> input_stmt\n", ++rule_index); }
         | output_stmt
         { printf("Rule %d: statement -> output_stmt\n", ++rule_index); }
         | cond_stmt
         { printf("Rule %d: statement -> cond_stmt\n", ++rule_index); }
         | loop_stmt_while
         { printf("Rule %d: statement -> loop_stmt_while\n", ++rule_index); }
         ;

assignment_stmt: id EQUAL expression SEMICOLON ENDL
               { printf("Rule %d: assignment_stmt -> id EQUAL expression SEMICOLON ENDL\n", ++rule_index); }
               | id EQUAL CHARCONST SEMICOLON ENDL
               { printf("Rule %d: assignment_stmt -> id EQUAL CHARCONST SEMICOLON ENDL\n", ++rule_index); }
               ;

input_stmt: CIN inputs SEMICOLON ENDL
          { printf("Rule %d: input_stmt -> CIN inputs SEMICOLON ENDL\n", ++rule_index); }
          ;

inputs: INOP id
      { printf("Rule %d: inputs -> INOP id\n", ++rule_index); }
      | INOP id inputs
      { printf("Rule %d: inputs -> INOP id inputs\n", ++rule_index); }
      ;

output_stmt: COUT outputs SEMICOLON ENDL
           { printf("Rule %d: output_stmt -> COUT outputs SEMICOLON ENDL\n", ++rule_index); }
           ;

outputs: OUTOP output
       { printf("Rule %d: outputs -> OUTOP output\n", ++rule_index); }
       | OUTOP output outputs
       { printf("Rule %d: outputs -> OUTOP output outputs\n", ++rule_index); }
       ;

output: STRING
      { printf("Rule %d: output -> STRING\n", ++rule_index); }
      | expression
      { printf("Rule %d: output -> expression\n", ++rule_index); }
      ;

cond_stmt: IF LP conditional_expression RP LBRACE ENDL statement_list RBRACE ENDL
         { printf("Rule %d: cond_stmt -> IF LP conditional_expression RP LBRACE ENDL statement_list RBRACE ENDL\n", ++rule_index); }
         | IF LP conditional_expression RP LBRACE ENDL statement_list RBRACE ENDL ELSE LBRACE ENDL statement_list RBRACE ENDL
         { printf("Rule %d: cond_stmt -> IF LP conditional_expression RP LBRACE ENDL statement_list RBRACE ENDL ELSE LBRACE ENDL statement_list RBRACE ENDL\n", ++rule_index); }
         ;

loop_stmt_while: WHILE LP conditional_expression RP LBRACE ENDL statement_list RBRACE ENDL
               { printf("Rule %d: loop_stmt_while -> WHILE LP conditional_expression RP LBRACE ENDL statement_list RBRACE ENDL\n", ++rule_index); }
               ;

expression: term
          { printf("Rule %d: expression -> term\n", ++rule_index); }
          | expression add_op term
          { printf("Rule %d: expression -> expression add_op term\n", ++rule_index); }
          ;

term: factor
    { printf("Rule %d: term -> factor\n", ++rule_index); }
    | term mul_op factor
    { printf("Rule %d: term -> term mul_op factor\n", ++rule_index); }
    ;

factor: LP expression RP
      { printf("Rule %d: factor -> LP expression RP\n", ++rule_index); }
      | id
      { printf("Rule %d: factor -> id\n", ++rule_index); }
      | INTCONST
      { printf("Rule %d: factor -> INTCONST\n", ++rule_index); }
      ;

conditional_expression: expression rel_op expression
                      { printf("Rule %d: conditional_expression -> expression rel_op expression\n", ++rule_index); }
                      | conditional_expression logic_op conditional_expression
                      { printf("Rule %d: conditional_expression -> conditional_expression logic_op conditional_expression\n", ++rule_index); }
                      | LP conditional_expression RP
                      { printf("Rule %d: conditional_expression -> LP conditional_expression RP\n", ++rule_index); }
                      | NOT conditional_expression
                      { printf("Rule %d: conditional_expression -> NOT conditional_expression\n", ++rule_index); }
                      ;

id: IDENTIFIER
  | IDENTIFIER DOT IDENTIFIER
  ;

add_op: PLUS
      | MINUS
      ;

mul_op: MULT
      | DIV
      | MOD
      ;

rel_op: EQ
      | LT
      | LE
      | GT
      | GE
      | NE
      ;

logic_op: AND
        | OR
        ;

%%

/* error handler */
void yyerror(const char* s) {
    fprintf(stderr, "Error: %s at rule %d\n", s, rule_index);
    exit(1);
}

int main() {
  
    printf("Parsing started...\n");
    
    if (yyparse() == 0) {  // parse successfully
        printf("Program syntactically correct\n");
    } else {
        printf("Program contains errors\n");
    }
    return 0;
}
