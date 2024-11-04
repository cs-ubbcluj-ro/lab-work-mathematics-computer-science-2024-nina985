%{
//def section
    #include <stdio.h>
    #include <string.h>

//PIF and ST data structures
    typedef struct {
        char token[100];
        int codeST;   //position in the ST
    } PIFEntry;

    typedef struct {
        char identifier[100];
        int index;
    } STEntry;

    PIFEntry PIF[1000];
    STEntry ST[1000];
    int index_PIF = 0; //current indexes in PIF and ST as they are being added to
    int index_ST = 0;

    int line_num = 1; //number of current line
    int position = 1; //pos in current line
    int error_found = 0;

    int add_to_ST(char* identifier){
        for (int i = 0; i < index_ST; i++) {
            if (strcmp(ST[i].identifier, identifier) == 0) {
                return i; //return existing index if identifier already in ST
            }
        }
        //add new identifier if not found
        strcpy(ST[index_ST].identifier, identifier);
        ST[index_ST].index = index_ST;
        return index_ST++;
    }

    void add_to_PIF(char* token, int codeST){
        strcpy(PIF[index_PIF].token, token);
        PIF[index_PIF].codeST = codeST;
        index_PIF++;
        position += yyleng;
    }

    void print_errors(char* error_msg, int line, int position){
        fprintf(stderr, "Lexical error at line %d, position %d: %s\n", line, position, error_msg);
    }

%}

%option noyywrap

%%

"#include"                   { add_to_PIF(yytext, -1); }
"iostream"				    { add_to_PIF(yytext, -1); }
"using"					    { add_to_PIF(yytext, -1); }
"namespace"				    { add_to_PIF(yytext, -1); }
"std"                       { add_to_PIF(yytext, -1); }
"if"                        { add_to_PIF(yytext, -1); }
"else"                      { add_to_PIF(yytext, -1); }
"while"                     { add_to_PIF(yytext, -1); }
"int"                       { add_to_PIF(yytext, -1); }
"char"                      { add_to_PIF(yytext, -1); }
"struct"                    { add_to_PIF(yytext, -1); }
"cin"                       { add_to_PIF(yytext, -1); }
"cout"                      { add_to_PIF(yytext, -1); }
"main"                      { add_to_PIF(yytext, -1); }
"return"                    { add_to_PIF(yytext, -1); }

";"                          { add_to_PIF(yytext, -1); }
"="                         { add_to_PIF(yytext, -1); }
"("                         { add_to_PIF(yytext, -1); }
")"                          { add_to_PIF(yytext, -1); }
","                                    	{ add_to_PIF(yytext, -1); }
"{"                         { add_to_PIF(yytext, -1); }
"}"                          { add_to_PIF(yytext, -1); }
"."                                    	{ add_to_PIF(yytext, -1); }

"<<"                         { add_to_PIF(yytext, -1); }
">>"                          { add_to_PIF(yytext, -1); }

"+"                                    	{ add_to_PIF(yytext, -1); }
"-"                                    	{ add_to_PIF(yytext, -1); }
"*"                                    	{ add_to_PIF(yytext, -1); }
"/"                                    	{ add_to_PIF(yytext, -1); }
"%"                                    	{ add_to_PIF(yytext, -1); }

">"                                    	{ add_to_PIF(yytext, -1); }
"<"                                    	{ add_to_PIF(yytext, -1); }
">="                                    	{ add_to_PIF(yytext, -1); }
"<="                                    	{ add_to_PIF(yytext, -1); }
"=="                                    	{ add_to_PIF(yytext, -1); }
"!="                                    	{ add_to_PIF(yytext, -1); }

"&&"                                    { add_to_PIF(yytext, -1); }
"||"                                   	{ add_to_PIF(yytext, -1); }
"!"                                   	{ add_to_PIF(yytext, -1); }


[a-zA-Z][a-zA-Z0-9_]* { 
    int index = add_to_ST(yytext);
    add_to_PIF(yytext, index);
}//IDENTIFIER

[+-]?[1-9][0-9]*  { 
    int index = add_to_ST(yytext);
    add_to_PIF(yytext, index);
}//INT constant
"0" {
    int index = add_to_ST(yytext);
    add_to_PIF(yytext, index);
}

'\''[a-zA-Z0-9 ]'\'' { 
    int index = add_to_ST(yytext);
    add_to_PIF(yytext, index);
}//CHAR constant

\"[^"]*\" {  
    int index = add_to_ST(yytext);
    add_to_PIF(yytext, index);
}//STRING literals

\n            { line_num++; position = 1; } //newline handling
\r\n          { line_num++; position = 1; } //wimdows input newline handled separately (ask me how i know)
[ \t]+        { position += yyleng; } //ignore whitespaces

. {
    error_found = 1;
    print_errors("Unknown token", line_num, position);
    position += yyleng;
} //catch-all for unknown tokens

%%

int main(int argc, char** argv) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <input file>\n", argv[0]);
        return 1;
    }

    FILE *input_file = fopen(argv[1], "r");
    if (!input_file) {
        perror("Failed to open file");
        return 1;
    }
    yyin = input_file;

    yylex(); //scan file

    //if there are no lexical errors, display tables
    if (error_found == 0){
        
        printf("~~~ Symbol Table (ST) ~~~\n");
        for (int i = 0; i < index_ST; i++) {
            printf("%s - %d\n", ST[i].identifier, ST[i].index);
        }

        printf("\n~~~ Program Internal Form (PIF) ~~~\n");
        for (int i = 0; i < index_PIF; i++) {
            printf("%s - %d\n", PIF[i].token, PIF[i].codeST);
        }
    }
    
    fclose(input_file);
    return 0;
}
