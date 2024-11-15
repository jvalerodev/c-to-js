#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>

char* concat(int num, const char* existing_str, ...) {
    va_list args;
    va_start(args, existing_str);

    size_t total_length = 0;

    // Si se proporciona una cadena existente, consideramos su longitud
    if (existing_str != NULL) {
        total_length += strlen(existing_str);
    }

    // Calculamos la longitud total de las cadenas a concatenar
    for (int i = 0; i < num; i++) {
        const char* current_string = va_arg(args, const char*);
        if (current_string != NULL) {
            total_length += strlen(current_string);
        }
    }

    // Reservamos espacio para la cadena resultante
    char* result = (char*)malloc(total_length + 1);
    if (result == NULL) {
        perror("Error when reserving memory");
        exit(EXIT_FAILURE);
    }

    // Inicializamos la cadena resultante
    if (existing_str != NULL) {
        strcpy(result, existing_str);
    } else {
        result[0] = '\0';
    }

    // Concatenamos las cadenas adicionales
    va_start(args, existing_str);
    for (int i = 0; i < num; i++) {
        const char* current_string = va_arg(args, const char*);
        if (current_string != NULL) {
            strcat(result, current_string);
        }
    }

    va_end(args);

    return result;
}

int main() {
    // Ejemplo de uso
    char* result1 = concat(3, "Hello, ", "this ", "is a test");
    printf("%s\n", result1);
    free(result1);

    char* result2 = concat(2, NULL, "Just ", "testing");
    printf("%s\n", result2);
    free(result2);

    return 0;
}
