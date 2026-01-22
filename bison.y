%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char* s);
%}

%code requires {
#include <stdio.h>
}

%code {
    FILE *out;
}

%union {
    int ival;
    char* sval;
    double rval;
}

%token <ival> NUMBER
%token <sval> MATHSIGN
%token <sval> STRING
%token <rval> REAL
%token <sval> ID
%token <sval> COMMENT
%token <sval> POWER
%token <sval> OP
%token <sval> FTYPE

%token IF ELSE WHILE DO MODULE END CONST END_OF_THE_LINE IS INT_T DB_T CHR_T OPEN_PAREN CLOSE_PAREN THEN AND OR NOT SELECT CASE WRITE READ

%type <sval> expression
%type <sval> statement
%type <sval> statement_list
%type <sval> compound_statement
%type <sval> type_spec
%type <sval> attr_list_opt
%type <sval> attr_list
%type <sval> attr
%type <sval> declaration
%type <sval> statement_tail
%type <sval> switchcase_tail
%type <sval> format_types
%type <sval> equation
%type <sval> var_enum
%type        cond_ending_opt
%type start

%left '+' '-'
%left '*' '/'

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE


%start start

%define parse.error detailed
%locations

%%
    start:
    program YYEOF
    ;
    
    program:
    statement_list
    {
        fprintf (out, "%s", $1);
        free ($1);
    }
    ;
    
    statement_list:
    statement_list statement
    {
        asprintf (&$$, "%s%s\n", $1, $2);
        free ($1);
        free ($2);
    }
    | statement
    {
        asprintf (&$$, "%s\n", $1);
        free ($1);
    }
    ;
    
    compound_statement:
    DO ID '=' NUMBER ',' NUMBER statement_list END DO
    {
        asprintf (&$$, "for (int %s = %d; %s <= %d; %s++)\n{\n%s}", $2, $4, $2, $6, $2, $7);
        free ($2);
        free ($7);
    }
    | DO ID '=' NUMBER ',' NUMBER ',' NUMBER statement_list END DO
    {
        asprintf (&$$, "for (int %s = %d; %s <= %d; %s += %d)\n{\n%s}", $2, $4, $2, $6, $2, $8, $9);
        free ($2);
        free ($9);
    }
    | DO WHILE OPEN_PAREN equation CLOSE_PAREN statement_list END DO
    {
        asprintf (&$$, "while (%s)\n{\n%s}", $4, $6);
        free ($4);
        free ($6);
    }
    | SELECT CASE OPEN_PAREN equation CLOSE_PAREN switchcase_tail END SELECT
    {
        asprintf (&$$, "switch (%s)\n{\n%s}", $4, $6);
        free ($4);
        free ($6);
    }
    ;
    
    switchcase_tail:
    {
        asprintf (&$$, "%s", $$);
    }
    | switchcase_tail CASE OPEN_PAREN equation CLOSE_PAREN statement_list
    {
        asprintf (&$$, "%s\tcase (%s):\n{\n%sbreak;\n}\n", $1, $4, $6);
        free ($1);
        free ($4);
        free ($6);
    }
    ;
    
    statement:
    declaration statement_tail
    {
        asprintf (&$$, "%s%s;", $1, $2);
        free ($1);
        free ($2);
    }
    | expression statement_tail
    {
        asprintf (&$$, "%s%s;", $1, $2);
        free ($1);
        free ($2);
    }
    | IF OPEN_PAREN equation CLOSE_PAREN THEN statement cond_ending_opt %prec LOWER_THAN_ELSE
    {
        asprintf (&$$, "if (%s)\n\t%s", $3, $6);
        free ($3);
        free ($6);
    }
    | IF OPEN_PAREN equation CLOSE_PAREN THEN statement ELSE statement cond_ending_opt
    {
        asprintf (&$$, "if (%s)\n\t%s\nelse\n\t%s", $3, $6, $8);
        free ($3);
        free ($6);
        free ($8);
    }
    | COMMENT
    {
        asprintf (&$$, "//%s", $1);
        free ($1);
    }
    | compound_statement
    {
        asprintf (&$$, "%s", $1);
        free ($1);
    }
    | WRITE OPEN_PAREN '*' ',' '\'' OPEN_PAREN format_types CLOSE_PAREN '\'' CLOSE_PAREN var_enum
    {
        asprintf (&$$, "printf (\"%s\", %s);", $7, $11);
        free ($7);
        free ($11);
    }
    | READ OPEN_PAREN '*' ',' '\'' OPEN_PAREN format_types CLOSE_PAREN '\'' CLOSE_PAREN var_enum
    {
        asprintf (&$$, "scanf (\"%s\", %s);", $7, $11);
        free ($7);
        free ($11);
    }
    ;
    
    format_types:
    FTYPE
    {
        asprintf (&$$, "%s", $1);
        
    }
    | format_types ',' FTYPE
    {
        asprintf (&$$, "%s %s", $1, $3);
        
    }
    ;
    
    var_enum:
    ID
    {
        asprintf (&$$, "%s", $1);
        free ($1);
    }
    | var_enum ',' ID
    {
        asprintf (&$$, "%s, %s", $1, $3);
        free ($1);
        free ($3);
    }
    ;
    
    statement_tail:
    {
        asprintf (&$$, "");
    }
    | '=' expression
    {
        asprintf (&$$, " = %s", $2);
        free ($2);
    }
    ;
    
    declaration:
    type_spec attr_list_opt IS ID
    {
        asprintf (&$$, "%s%s %s", $1, $2, $4);
        free ($1);
        free ($2);
        free ($4);
    }
    ;
    
    type_spec:
    INT_T
    {
        asprintf (&$$, "int");
    }
    | DB_T
    {
        asprintf (&$$, "double");
    }
    | CHR_T
    {
        asprintf (&$$, "char");
    }
    ;
    
    attr_list_opt:
    {
        asprintf (&$$, "");
    }
    | ',' attr_list
    {
        asprintf (&$$, " %s", $2);
        free ($2);
    }
    ;
    
    cond_ending_opt:
    
    | END IF
    ;
    
    attr_list:
    attr
    {
        asprintf (&$$, "%s", $1);
        free ($1);
    }
    | attr_list ',' attr
    {
        asprintf (&$$, "%s %s", $$, $3);
        free ($3);
    }
    ;
    
    attr:
    CONST
    {
        asprintf (&$$, "const");
    }
    ;
    
    equation:
    expression OP expression
    {
        asprintf (&$$, "%s %s %s", $1, $2, $3);
        free ($1);
        free ($2);
        free ($3);
    }
    | expression
    {
        asprintf (&$$, "%s", $1);
        free ($1);
    }
    ;
    
    
    expression:
    OPEN_PAREN expression CLOSE_PAREN
    {
        asprintf (&$$, "(%s)", $2);
        free ($2);
    }
    | expression '+' expression
    {
        asprintf (&$$, "%s + %s", $1, $3);
        free ($1);
        free ($3);
    }
    | expression '-' expression
    {
        asprintf (&$$, "%s - %s", $1, $3);
        free ($1);
        free ($3);
    }
    | expression '*' expression
    {
        asprintf (&$$, "%s * %s", $1, $3);
        free ($1);
        free ($3);
    }
    | expression '/' expression
    {
        asprintf (&$$, "%s / %s", $1, $3);
        free ($1);
        free ($3);
    }
    | expression '.' AND '.' expression
    {
        asprintf (&$$, "%s && %s", $1, $5);
        free ($1);
        free ($5);
    }
    | expression '.' OR '.' expression
    {
        asprintf (&$$, "%s || %s", $1, $5);
        free ($1);
        free ($5);
    }
    | '.' NOT '.' expression
    {
        asprintf (&$$, "!%s", $4);
        free ($4);
    }
    | ID
    {
        asprintf (&$$, "%s", $1);
        free ($1);
    }
    | NUMBER
    {
        asprintf (&$$, "%d", $1);
    }
    | REAL
    {
        asprintf (&$$, "%f", $1);
    }
    ;
%%
    
void yyerror(const char* s)
{
    extern char *yytext;
    fprintf(stderr, "Ошибка при парсинге:\n%s\n", s);
    fprintf(stderr, "На токене: %s\n", yytext);
    fprintf(stderr, "В строке: %d\n", yylloc.first_line);
    fprintf(stderr, "В столбце: %d\n", yylloc.first_column);
}

extern FILE *yyin;
FILE *out;

int main (int argc, char** argv)
{
    yyin = fopen(argv[1], "r");
    if (!yyin)
    {
        perror ("couldnt open the input file");
        return -1;
    }
    
    out = fopen ("out.c", "w");
    if (!out)
    {
        perror ("couldnt create the output file");
        return -1;
    }
    
    yyparse(); //Собсна парсинг
    
    fclose(out);
    fclose(yyin);
    
    return 0;
}
