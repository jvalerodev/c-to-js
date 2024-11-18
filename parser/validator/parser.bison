%{
#include <stdio.h>

extern int yylex();
int yyerror(const char *);
%}

%token TOKEN_INT TOKEN_KFLOAT TOKEN_DOUBLE TOKEN_CHAR TOKEN_BOOL TOKEN_VOID
%token TOKEN_IF TOKEN_ELSE TOKEN_FOR TOKEN_WHILE TOKEN_RETURN
%token TOKEN_IDENTIFIER TOKEN_INTEGER TOKEN_STRING TOKEN_FLOAT
%token TOKEN_OP_SUM TOKEN_OP_SUB TOKEN_OP_MULTIPLIER TOKEN_OP_DIVIDER
%token TOKEN_OP_ASSIGNMENT TOKEN_OP_EQUAL TOKEN_OP_NOT_EQUAL TOKEN_OP_NOT
%token TOKEN_OP_GREATER TOKEN_OP_LESS TOKEN_OP_GREATER_EQUAL TOKEN_OP_LESS_EQUAL
%token TOKEN_BRACKET_OPEN TOKEN_BRACKET_CLOSE
%token TOKEN_PARENTHESIS_OPEN TOKEN_PARENTHESIS_CLOSE
%token TOKEN_END_SENTENCE

%left TOKEN_OP_SUM TOKEN_OP_SUB
%left TOKEN_OP_MULTIPLIER TOKEN_OP_DIVIDER
%nonassoc TOKEN_OP_GREATER TOKEN_OP_LESS TOKEN_OP_GREATER_EQUAL TOKEN_OP_LESS_EQUAL
%nonassoc TOKEN_OP_EQUAL TOKEN_OP_NOT_EQUAL

%%
program:
    declaration_list
    ;

declaration_list:
    declaration_list declaration
    | declaration
    ;

declaration:
    variable_declaration
    | function_declaration
    | function_call
    ;

variable_declaration:
    type TOKEN_IDENTIFIER optional_initialization TOKEN_END_SENTENCE
    ;

optional_initialization:
    /* empty */
    | TOKEN_OP_ASSIGNMENT expression
    ;

function_declaration:
    type TOKEN_IDENTIFIER TOKEN_PARENTHESIS_OPEN parameters TOKEN_PARENTHESIS_CLOSE function_body
    | TOKEN_VOID TOKEN_IDENTIFIER TOKEN_PARENTHESIS_OPEN parameters TOKEN_PARENTHESIS_CLOSE function_body
    ;

function_call:
    TOKEN_IDENTIFIER TOKEN_PARENTHESIS_OPEN expression_list TOKEN_PARENTHESIS_CLOSE TOKEN_END_SENTENCE
    | TOKEN_IDENTIFIER TOKEN_PARENTHESIS_OPEN TOKEN_PARENTHESIS_CLOSE TOKEN_END_SENTENCE

parameters:
    parameter_list
    | /* empty */
    ;

parameter_list:
    parameter_list ',' parameter
    | parameter
    ;

parameter:
    type TOKEN_IDENTIFIER
    ;

expression_list:
    expression_list ',' expression
    | expression
    ;

type:
    TOKEN_INT
    | TOKEN_KFLOAT
    | TOKEN_DOUBLE
    | TOKEN_CHAR
    | TOKEN_BOOL
    ;

function_body:
    TOKEN_BRACKET_OPEN instruction_list TOKEN_BRACKET_CLOSE
    | TOKEN_BRACKET_OPEN TOKEN_BRACKET_CLOSE
    ;

instruction_list:
    instruction_list instruction
    | instruction
    ;

instruction:
    variable_declaration
    | assignation
    | control_structure
    | return
    | function_call
    ;

assignation:
    TOKEN_IDENTIFIER TOKEN_OP_ASSIGNMENT expression TOKEN_END_SENTENCE
    | TOKEN_IDENTIFIER TOKEN_OP_ASSIGNMENT expression
    ;

control_structure:
    if_structure
    | for_structure
    | while_structure
    ;

if_structure:
    TOKEN_IF TOKEN_PARENTHESIS_OPEN expression TOKEN_PARENTHESIS_CLOSE function_body
    | TOKEN_IF TOKEN_PARENTHESIS_OPEN expression TOKEN_PARENTHESIS_CLOSE function_body TOKEN_ELSE function_body
    ;

for_structure:
    TOKEN_FOR TOKEN_PARENTHESIS_OPEN variable_declaration comparison_expression TOKEN_END_SENTENCE assignation TOKEN_PARENTHESIS_CLOSE function_body
    ;

while_structure:
    TOKEN_WHILE TOKEN_PARENTHESIS_OPEN expression TOKEN_PARENTHESIS_CLOSE function_body
    ;

return:
    TOKEN_RETURN expression TOKEN_END_SENTENCE
    | TOKEN_RETURN TOKEN_END_SENTENCE
    ;

expression:
    comparison_expression
    ;

comparison_expression:
    arithmetic_expression comparison_operator arithmetic_expression
    | arithmetic_expression
    ;

comparison_operator:
    TOKEN_OP_GREATER
    | TOKEN_OP_GREATER_EQUAL
    | TOKEN_OP_LESS
    | TOKEN_OP_LESS_EQUAL
    | TOKEN_OP_EQUAL
    | TOKEN_OP_NOT_EQUAL
    ;

arithmetic_expression:
    arithmetic_expression TOKEN_OP_SUM term
    | arithmetic_expression TOKEN_OP_SUB term
    | term
    ;

term:
    term TOKEN_OP_MULTIPLIER factor
    | term TOKEN_OP_DIVIDER factor
    | factor
    ;

factor:
    TOKEN_PARENTHESIS_OPEN expression TOKEN_PARENTHESIS_CLOSE
    | TOKEN_IDENTIFIER TOKEN_PARENTHESIS_OPEN expression_list TOKEN_PARENTHESIS_CLOSE
    | TOKEN_IDENTIFIER TOKEN_PARENTHESIS_OPEN TOKEN_PARENTHESIS_CLOSE
    | TOKEN_IDENTIFIER
    | TOKEN_INTEGER
    | TOKEN_FLOAT
    | TOKEN_STRING
    ;

%%

int yyerror(const char* s)
{
    extern int line_count;
    extern char* yytext;

    printf("Parse error: %s in line %d near: '%s'\n", s, line_count, yytext);
    
    return 1;
}
