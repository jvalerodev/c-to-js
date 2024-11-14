#include <stdio.h>
#include <stdlib.h>
#include <string.h>


extern FILE* yyin;
extern int yyparse();
extern char* js_code;  // Variable definida en parser.bison para almacenar el código JS generado}

void usage(char* argv[]) {
    printf("Usage: %s input_file\n", argv[0]);
    exit(1);
}

int main(int argc, char* argv[]) {
    js_code = (char*)malloc(1);

    if (argc != 2) {
        usage(argv);
    }

    yyin = fopen(argv[1], "r");

    if (!yyin) {
        printf("Could not open %s\n", argv[1]);
        exit(1);
    }

    int result = yyparse();

    if (result == 0) {
        printf("Parse successful!\n");
        printf("Generated JavaScript code:\n%s\n", js_code);  // Imprime el código JavaScript generado
    } else {
        printf("Parse failed!\n");
    }

    free(js_code);
    fclose(yyin);
    return 0;
}