#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>

// Variable global que puede ser usada para concatenar strings
char* global_string = NULL;

// Función que concatena múltiples strings a una cadena existente
void safe_concat_global(char** dest, int num, ...) {
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

int main() {
    // Inicializar la cadena global con un valor
    global_string = (char*)malloc(1);
    if (global_string == NULL) {
        perror("Error al reservar memoria");
        return EXIT_FAILURE;
    }
    global_string[0] = '\0'; // Inicializar la cadena vacía

    // Usar la función para concatenar cadenas
    safe_concat_global(&global_string, 2, "Hello, ", "world!");
    printf("%s\n", global_string);

    // Concatenar más cadenas a la global existente
    safe_concat_global(&global_string, 1, " How are you?");
    printf("%s\n", global_string);

    // Liberar la memoria asignada
    free(global_string);
    return 0;
}
