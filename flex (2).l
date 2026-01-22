%{
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>

#include "bison.tab.h"

int column = 1;

#define YY_USER_ACTION \
    yylloc.first_line = yylloc.last_line = yylineno; \
    yylloc.first_column = column; \
    yylloc.last_column = column + yyleng - 1; \
    column += yyleng;
%}

%option noyywrap
%option yylineno

DIGIT [0-9]
LETTER [_a-zA-Z]
ID {LETTER}({LETTER}|{DIGIT})*
INT [-]?{DIGIT}+
REAL [-]?{DIGIT}+"."{DIGIT}+

%%
[ \t\r]+ {

}

\n+ {
    column = 1;
}

!.* {
    yylval.sval = strdup (yytext + 1);
    return COMMENT;
}

"(" {
    return OPEN_PAREN;
}

")" {
    return CLOSE_PAREN;
}

"::" {
    return IS;
}

"=="|"/="|"<="|">="|"<"|">" {
    yylval.sval = strdup (yytext);
    return OP;
}

{ID} {
    char buf[128];
    int i;
    
    for (i = 0; i < yyleng; i++) buf[i] = tolower((unsigned char)yytext[i]);
    buf[i] = '\0';
    
    if (strcmp(buf, "if") == 0) return IF;
    if (strcmp(buf, "else") == 0) return ELSE;
    if (strcmp(buf, "then") == 0) return THEN;
    if (strcmp(buf, "while") == 0) return WHILE;
    if (strcmp(buf, "do") == 0) return DO;
    if (strcmp(buf, "select") == 0) return SELECT;
    if (strcmp(buf, "case") == 0) return CASE;
    if (strcmp(buf, "write") == 0) return WRITE;
    if (strcmp(buf, "read") == 0) return READ;
    
    if (strcmp(buf, "and") == 0) return AND;
    if (strcmp(buf, "or") == 0) return OR;
    if (strcmp(buf, "not") == 0) return NOT;
    
    if (strcmp(buf, "module") == 0) return MODULE;
    if (strcmp(buf, "end") == 0) return END;
    if (strcmp(buf, "parameter") == 0) return CONST;
    if (strcmp(buf, "integer") == 0) return INT_T;
    if (strcmp(buf, "real") == 0) return DB_T;
    if (strcmp(buf, "character") == 0) return CHR_T;
    if (strcmp(buf, "logical") == 0) return CHR_T;
    
    if (strcmp(buf, "implicit") == 0) break;
    if (strcmp(buf, "none") == 0) break;
    if (strcmp(buf, "private") == 0) break;
    if (strcmp(buf, "public") == 0) break;
    
    if (strcmp(buf, "a") == 0) {
        yylval.sval = "%c";
        return FTYPE;
    }
    if (strcmp(buf, "i") == 0) {
        yylval.sval = "%d";
        return FTYPE;
    }
    if (strcmp(buf, "f") == 0) {
        yylval.sval = "%f";
        return FTYPE;
    }
    if (strcmp(buf, "l") == 0) {
        yylval.sval = "%c";
        return FTYPE;
    }
    
    yylval.sval = strdup (yytext);
    return ID;
}
    
{DIGIT}+ {
    yylval.ival = atoi (yytext);
    return NUMBER;
}

{REAL} {
    yylval.rval = atof (yytext);
    return REAL;
}
    
"**" {
    yylval.sval = strdup (yytext);
    return POWER;
}
    
[.,()'=;+*/-] {return yytext[0];}
    
%%
