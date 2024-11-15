#ifndef UTILS_H
#define UTILS_H

void append_to_js_code(char** dest, int num, ...);
char* create_assignment_code(const char* var, const char* expr, bool add_semicolon);
char* create_variable_declaration(const char* type, const char* code);
char* create_formatted_code(const char* format, const char* str1, const char* str2);

char* concat(int num, ...);

#endif // CODE_UTILS_H
