%{
//def section
    #include <stdio.h>
    #include <string.h>
    #include "y.tab.h"
    
    #define YY_NO_MAIN

    int line_num = 1; //number of current line
    int position = 1; //pos in current line
    int error_found = 0;

    void print_errors(char* error_msg, int line, int position){
        fprintf(stderr, "Lexical error at line %d, position %d: %s\n", line, position, error_msg);
    }

%}

%option noyywrap

%%

"include"                   { printf("Token: INCLUDE\n"); return INCLUDE; }
"<iostream>"				        { printf("Token: LT IOSTREAM GT\n"); return IOSTREAM; }
"using"					            { printf("Token: USING\n"); return USING; }
"namespace"				          { printf("Token: NAMESPACE\n"); return NAMESPACE; }
"std"                       { printf("Token: STD\n"); return STD; }
"if"                        { printf("Token: IF\n"); return IF; }
"else"                      { printf("Token: ELSE\n"); return ELSE; }
"while"                     { printf("Token: WHILE\n"); return WHILE; }
"int"                       { printf("Token: INT\n"); return INT; }
"char"                      { printf("Token: CHAR\n"); return CHAR; }
"struct"                    { printf("Token: STRUCT\n"); return STRUCT; }
"cin"                       { printf("Token: CIN\n"); return CIN; }
"cout"                      { printf("Token: COUT\n"); return COUT; }
"main"                      { printf("Token: MAINN\n"); return MAINN; }
"return"                    { printf("Token: RETURN\n"); return RETURN; }

";"                         { printf("Token: SEMICOLON ;\n"); return SEMICOLON; }
"="                         { printf("Token: EQUAL =\n"); return EQUAL; }
"("                         { printf("Token: LP (\n"); return LP; }
")"                         { printf("Token: RP )\n"); return RP; }
","                         { printf("Token: COLON ,\n"); return COLON; }
"{"                         { printf("Token: LBRACE {\n"); return LBRACE; }
"}"                         { printf("Token: RBRACE }\n"); return RBRACE; }
"."                         { printf("Token: DOT .\n"); return DOT; }

"<<"                        { printf("Token: OUTOP <<\n"); return OUTOP; }
">>"                        { printf("Token: INOP >>\n"); return INOP; }

"+"                         { printf("Token: PLUS +\n"); return PLUS; }
"-"                         { printf("Token: MINUS -\n"); return MINUS; }
"*"                         { printf("Token: MULT *\n"); return MULT; }
"/"                         { printf("Token: DIV /\n"); return DIV; }
"%"                        	{ printf("Token: MOD %\n"); return MOD; }

">"                        	{ printf("Token: GT >\n"); return GT; }
"<"                        	{ printf("Token: LT <\n"); return LT; }
">="                        { printf("Token: GE >=\n"); return GE; }
"<="                        { printf("Token: LE <=\n"); return LE; }
"=="                        { printf("Token: EQ ==\n"); return EQ; }
"!="                        { printf("Token: NE !=\n"); return NE; }

"&&"                        { printf("Token: AND &&\n"); return AND; }
"||"                        { printf("Token: OR ||\n"); return OR; }
"!"                         { printf("Token: NOT !\n"); return NOT; }
"#"                         { printf("Token: HASH #\n"); return HASH; }


[a-zA-Z_][a-zA-Z0-9_]* { 
    printf("Token: IDENTIFIER %s\n", yytext);
    return IDENTIFIER;
}

[+-]?[1-9][0-9]*  { 
    printf("Token: INTCONST %s\n", yytext);
    return INTCONST;
}
"0" {
    printf("Token: INTCONST %s\n", yytext);
    return INTCONST;
}

'\''[a-zA-Z0-9 ]'\'' { 
    printf("Token: CHARCONST %s\n", yytext);
    return CHARCONST;
}

\"[^"]*\" {  
    printf("Token: STRING %s\n", yytext);
    return STRING;
}

\n            { printf("Token: ENDL at line %d\n", line_num); line_num++; position = 1; return ENDL; } //newline handling
\r\n          { printf("Token: ENDL at line %d\n", line_num); line_num++; position = 1; return ENDL; } //wimdows input newline handled separately (ask me how i know)
[ \t]+        { position += yyleng; } //ignore whitespaces

. {
    error_found = 1;
    print_errors("Unknown token", line_num, position);
    position += yyleng;
    exit(1);
} //catch-all for unknown tokens

%%

