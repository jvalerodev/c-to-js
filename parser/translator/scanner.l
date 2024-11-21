%{
  #include "token.h"
  
  int line_count = 1;

  int yyerror();
%}

/* TOKENS */
DIGIT                         [0-9]
LETTER                        [a-zA-Z]
SPACE                         [" "]
END_OF_LINE                   [\n]
TABULATION                    [\t]
COMMENT_START                 ["/*"]
COMMENT_END                   ["*/"]
COMMENT_INLINE                "//"(.*)\n
UNDERSCORE                    ["_"]
CHAR_POINT                    ["."]
CHAR_COLON                    [":"]
HEADER                        ^"#include"[ \t]+[\"<][^\">]+[\">][ \t]*\n

IDENTIFIER                    ({UNDERSCORE}|{LETTER})({LETTER}|{DIGIT}|{UNDERSCORE})*
INTEGER                       (-?[1-9]{DIGIT}*)|0
FLOAT                         (-?{DIGIT}{0,8}{CHAR_POINT}{DIGIT}{1,8})
STRING                        \"[^\n"]*\"

OP_SUM                        ["+"]
OP_SUB                        "-"
OP_MULTIPLIER                 ["*"]
OP_DIVIDER                    ["/"]
OP_ASSIGNMENT                 ["="]
OP_GREATER                    [">"]
OP_LESS                       ["<"]
OP_GREATER_EQUAL              ">="
OP_LESS_EQUAL                 "<="
OP_EQUAL                      "=="
OP_NOT                        "!"
OP_NOT_EQUAL                  "!="
OP_AND                        "&&"
OP_OR                         "||"

BRACKET_OPEN                  ["{"]
BRACKET_CLOSE                 ["}"]
PARENTHESIS_OPEN              ["("]
PARENTHESIS_CLOSE             [")"]
END_SENTENCE                  [";"]
COMMA                         [","]

/* KEYWORDS */
INT                           "int"
KFLOAT                        "float"
DOUBLE                        "double"
CHAR                          "char"
BOOL                          "bool"
RETURN                        "return"
VOID                          "void"
PRINT                         "printf"

IF                            "if"
ELSE                          "else"
FOR                           "for"
WHILE                         "while"

%%

{SPACE}                       {}
{TABULATION}                  {}
{COMMENT_INLINE}              {}
{HEADER}                      {}

{END_OF_LINE}                 { line_count++; }
{END_SENTENCE}                { return TOKEN_END_SENTENCE; }
{INTEGER}                     { yylval = strdup(yytext); return TOKEN_INTEGER; }
{FLOAT}                       { yylval = strdup(yytext); return TOKEN_FLOAT; }
{STRING}                      { yylval = strdup(yytext); return TOKEN_STRING; }

{OP_SUM}                      { return TOKEN_OP_SUM; }
{OP_SUB}                      { return TOKEN_OP_SUB; }
{OP_MULTIPLIER}               { return TOKEN_OP_MULTIPLIER; }
{OP_DIVIDER}                  { return TOKEN_OP_DIVIDER; }
{OP_ASSIGNMENT}               { return TOKEN_OP_ASSIGNMENT; }
{OP_GREATER}                  { return TOKEN_OP_GREATER; }
{OP_LESS}                     { return TOKEN_OP_LESS; }
{OP_GREATER_EQUAL}            { return TOKEN_OP_GREATER_EQUAL; }
{OP_LESS_EQUAL}               { return TOKEN_OP_LESS_EQUAL; }
{OP_EQUAL}                    { return TOKEN_OP_EQUAL; }
{OP_NOT}                      { return TOKEN_OP_NOT; }
{OP_NOT_EQUAL}                { return TOKEN_OP_NOT_EQUAL; }
{OP_AND}                      { return TOKEN_OP_AND; }
{OP_OR}                       { return TOKEN_OP_OR; }

{BRACKET_OPEN}                { return TOKEN_BRACKET_OPEN; }
{BRACKET_CLOSE}               { return TOKEN_BRACKET_CLOSE; }
{PARENTHESIS_OPEN}            { return TOKEN_PARENTHESIS_OPEN; }
{PARENTHESIS_CLOSE}           { return TOKEN_PARENTHESIS_CLOSE; }

{INT}                         { return TOKEN_INT; }
{KFLOAT}                      { return TOKEN_KFLOAT; }
{DOUBLE}                      { return TOKEN_DOUBLE; }
{CHAR}                        { return TOKEN_CHAR; }
{BOOL}                        { return TOKEN_BOOL; }
{RETURN}                      { return TOKEN_RETURN; }
{VOID}                        { return TOKEN_VOID; }
{PRINT}                       { return TOKEN_PRINT; }

{IF}                          { return TOKEN_IF; }
{ELSE}                        { return TOKEN_ELSE; }
{FOR}                         { return TOKEN_FOR; }
{WHILE}                       { return TOKEN_WHILE; }

{IDENTIFIER}                  { yylval = strdup(yytext); return TOKEN_IDENTIFIER; }
{COMMA}                       { return ','; }

.                             yyerror(); 

%%

int yywrap() {
  return 1;
}

int yyerror() {
  printf("Unexpected token '%s' in line %d", yytext, line_count);
  exit(1);
}