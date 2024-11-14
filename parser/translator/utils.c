#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include "utils.h"

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

char* create_assignment_code(const char* var, const char* expr, bool add_semicolon) {
    size_t length = strlen(var) + strlen(expr) + (add_semicolon ? 5 : 4);
    char* code = (char*)malloc(length);
    if (code == NULL) {
        perror("Error al reservar memoria");
        exit(EXIT_FAILURE);
    }
    if (add_semicolon) {
        sprintf(code, "%s = %s;", var, expr);
    } else {
        sprintf(code, "%s = %s", var, expr);
    }
    return code;
}

char* create_variable_declaration(const char* type, const char* code) {
    size_t length = strlen(type) + strlen(code) + 5; // Espacio para "let ", el tipo, y un terminador nulo
    char* declaration = (char*)malloc(length);
    if (declaration == NULL) {
        perror("Error al reservar memoria");
        exit(EXIT_FAILURE);
    }
    sprintf(declaration, "let %s", code); // Formatea la declaración
    return declaration;
}

