%{
#include <stdio.h>
#include <string.h>
#include "utils.h"

extern int yylex();
int yyerror(const char *);

char* js_code = NULL;
%}

%define api.value.type { char* }


%token TOKEN_INT TOKEN_KFLOAT TOKEN_DOUBLE TOKEN_CHAR TOKEN_BOOL TOKEN_VOID TOKEN_PRINT
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
    variable_declaration { js_code = concat(2, js_code, $1, "\n"); }
    | function_declaration { js_code = concat(2, js_code, $1, "\n"); }
    | function_call { js_code = concat(2, js_code, $1, "\n"); }
    ;

variable_declaration:
    type TOKEN_IDENTIFIER TOKEN_END_SENTENCE { $$ = concat(3, NULL, "let ", $2, ";\n"); }
    | type assignation { $$ = concat(2, NULL, "let ", $2); }
    ;

function_declaration:
    type TOKEN_IDENTIFIER TOKEN_PARENTHESIS_OPEN parameters TOKEN_PARENTHESIS_CLOSE function_body { $$ = concat(6, NULL, "function ", $2, "(", $4, ")", $6); }
    ;

function_call:
    TOKEN_IDENTIFIER TOKEN_PARENTHESIS_OPEN expression_list TOKEN_PARENTHESIS_CLOSE TOKEN_END_SENTENCE { $$ = concat(4, NULL, $1, "(", $3, ");\n"); }
    | TOKEN_PRINT TOKEN_PARENTHESIS_OPEN expression_list TOKEN_PARENTHESIS_CLOSE TOKEN_END_SENTENCE { $$ = concat(3, NULL, "console.log(", $3, ");\n"); }
    ;
    

parameters:
    parameter_list
    | /* empty */
    ;

parameter_list:
    parameter_list ',' parameter { $$ = concat(3, NULL, $1, ", ", $3); }
    | parameter { $$ = $1; }
    ;

parameter:
    type TOKEN_IDENTIFIER { $$ = $2; }
    ;

expression_list:
    expression_list ',' expression { $$ = concat(3, NULL, $1, ", ", $3); }
    | expression { $$ = $1; }
    | /* empty */ { $$ = NULL; }
    ;

type:
    TOKEN_INT
    | TOKEN_KFLOAT
    | TOKEN_DOUBLE
    | TOKEN_CHAR
    | TOKEN_BOOL
    | TOKEN_VOID
    ;

function_body:
    TOKEN_BRACKET_OPEN instruction_list TOKEN_BRACKET_CLOSE { $$ = concat(3, NULL, "{\n", $2, "}\n"); }
    | TOKEN_BRACKET_OPEN TOKEN_BRACKET_CLOSE { $$ = concat(1, NULL, "{}\n"); }
    ;

instruction_list:
    instruction_list instruction { $$ = concat(2, NULL, $1, $2); }
    | instruction { $$ = $1; }
    ;

instruction:
    variable_declaration 
    | assignation
    | control_structure
    | return
    | function_call
    ;

assignation:
    TOKEN_IDENTIFIER TOKEN_OP_ASSIGNMENT expression TOKEN_END_SENTENCE { $$ = concat(4, NULL, $1, " = ", $3, ";\n"); }
    | TOKEN_IDENTIFIER TOKEN_OP_ASSIGNMENT expression { $$ = concat(3, NULL, $1, " = ", $3); }
    ;

control_structure:
    if_structure
    | for_structure
    | while_structure
    ;

if_structure:
    TOKEN_IF TOKEN_PARENTHESIS_OPEN expression TOKEN_PARENTHESIS_CLOSE function_body { $$ = concat(4, NULL, "if (", $3, ")", $5); }
    | TOKEN_IF TOKEN_PARENTHESIS_OPEN expression TOKEN_PARENTHESIS_CLOSE function_body TOKEN_ELSE if_structure { $$ = concat(6, NULL, "if (", $3, ")", $5, "else ", $7); }
    | TOKEN_IF TOKEN_PARENTHESIS_OPEN expression TOKEN_PARENTHESIS_CLOSE function_body TOKEN_ELSE function_body { $$ = concat(6, NULL, "if (", $3, ")", $5, "else ", $7); }
    ;

for_structure:
    TOKEN_FOR TOKEN_PARENTHESIS_OPEN variable_declaration expression TOKEN_END_SENTENCE assignation TOKEN_PARENTHESIS_CLOSE function_body { $$ = concat(7, NULL, "for (", $3, $4, ";", $6, ")", $8); }
    ;

while_structure:
    TOKEN_WHILE TOKEN_PARENTHESIS_OPEN expression TOKEN_PARENTHESIS_CLOSE function_body { $$ = concat(4, NULL, "while (", $3, ")", $5); }
    ;

return:
    TOKEN_RETURN expression TOKEN_END_SENTENCE { $$ = concat(3, NULL, "return ", $2, ";\n"); }
    ;

expression:
    comparison_expression
    ;

comparison_expression:
    arithmetic_expression TOKEN_OP_GREATER arithmetic_expression { $$ = concat(3, NULL, $1, " > ", $3); }
    | arithmetic_expression TOKEN_OP_GREATER_EQUAL arithmetic_expression { $$ = concat(3, NULL, $1, " >= ", $3); }
    | arithmetic_expression TOKEN_OP_LESS arithmetic_expression { $$ = concat(3, NULL, $1, " < ", $3); }
    | arithmetic_expression TOKEN_OP_LESS_EQUAL arithmetic_expression { $$ = concat(3, NULL, $1, " <= ", $3); }
    | arithmetic_expression TOKEN_OP_EQUAL arithmetic_expression { $$ = concat(3, NULL, $1, " == ", $3); }
    | arithmetic_expression TOKEN_OP_NOT_EQUAL arithmetic_expression { $$ = concat(3, NULL, $1, " != ", $3); }
    | arithmetic_expression
    ;

arithmetic_expression:
    arithmetic_expression TOKEN_OP_SUM term { $$ = concat(3, NULL, $1, " + ", $3); }
    | arithmetic_expression TOKEN_OP_SUB term { $$ = concat(3, NULL, $1, " - ", $3); }
    | term
    ;

term:
    term TOKEN_OP_MULTIPLIER factor { $$ = concat(3, NULL, $1, " * ", $3); }
    | term TOKEN_OP_DIVIDER factor { $$ = concat(3, NULL, $1, " / ", $3); }
    | factor
    ;

factor:
    TOKEN_PARENTHESIS_OPEN expression TOKEN_PARENTHESIS_CLOSE
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