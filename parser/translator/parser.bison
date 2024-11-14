%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

extern int yylex();
int yyerror(const char *);

char* js_code = NULL;

void append_to_js_code(char** dest, int num, ...) {
    // Inicialización de la lista de argumentos
    va_list args;
    va_start(args, num);

    // Calcular el tamaño total necesario
    size_t total_length = (*dest ? strlen(*dest) : 0); // Longitud de la cadena existente
    for (int i = 0; i < num; i++) {
        const char* current_string = va_arg(args, const char*);
        if (current_string != NULL) {
            total_length += strlen(current_string);
        }
    }

    // Reservar espacio para la cadena resultante (+1 para el terminador nulo)
    *dest = (char*)realloc(*dest, total_length + 1);
    if (*dest == NULL) {
        perror("Error al reservar memoria");
        exit(EXIT_FAILURE);
    }

    // Reiniciar la lista de argumentos para la segunda pasada
    va_start(args, num);

    // Concatenar todas las cadenas
    for (int i = 0; i < num; i++) {
        const char* current_string = va_arg(args, const char*);
        if (current_string != NULL) {
            strcat(*dest, current_string);
        }
    }

    // Finalizar la lista de argumentos
    va_end(args);
}

char* create_assignment_code(const char* var, const char* expr, int add_semicolon) {
    size_t length = strlen(var) + strlen(expr) + (add_semicolon ? 5 : 4);
    char* code = (char*)malloc(length);
    if (add_semicolon) {
        sprintf(code, "%s = %s;", var, expr);
    } else {
        sprintf(code, "%s = %s", var, expr);
    }
    return code;
}
%}

%define api.value.type { char* }


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
    type TOKEN_IDENTIFIER TOKEN_END_SENTENCE { append_to_js_code(&js_code, 3, "let ", $2, ";"); }
    | type assignation {
        printf("%s", $2);
        // Usa el valor retornado por `assignation` y prepende "let " al principio
        char* declaration = (char*)malloc(strlen($1) + strlen($2) + 5); // Espacio para "let " y un espacio adicional
        sprintf(declaration, "let %s", $2);
        append_to_js_code(&js_code, 1, declaration);
        free(declaration); // Liberar memoria temporal si es necesario
    }
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
    TOKEN_IDENTIFIER TOKEN_OP_ASSIGNMENT expression TOKEN_END_SENTENCE {
        $$ = create_assignment_code($1, $3, 1); // Retorna el código de asignación con `;`
    }
    | TOKEN_IDENTIFIER TOKEN_OP_ASSIGNMENT expression {
        $$ = create_assignment_code($1, $3, 0); // Retorna el código de asignación sin `;`
    }
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
    TOKEN_FOR TOKEN_PARENTHESIS_OPEN variable_declaration expression TOKEN_END_SENTENCE assignation TOKEN_PARENTHESIS_CLOSE function_body
    ;

while_structure:
    TOKEN_WHILE TOKEN_PARENTHESIS_OPEN expression TOKEN_PARENTHESIS_CLOSE function_body
    ;

return:
    TOKEN_RETURN expression TOKEN_END_SENTENCE
    ;

expression:
    comparison_expression
    ;

comparison_expression:
    arithmetic_expression TOKEN_OP_GREATER arithmetic_expression
    | arithmetic_expression TOKEN_OP_GREATER_EQUAL arithmetic_expression
    | arithmetic_expression TOKEN_OP_LESS arithmetic_expression
    | arithmetic_expression TOKEN_OP_LESS_EQUAL arithmetic_expression
    | arithmetic_expression TOKEN_OP_EQUAL arithmetic_expression
    | arithmetic_expression TOKEN_OP_NOT_EQUAL arithmetic_expression
    | arithmetic_expression
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