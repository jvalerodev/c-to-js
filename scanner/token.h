#pragma once

typedef enum
{
  TOKEN_END_OF_LINE = 0,
  TOKEN_END_SENTENCE = 258,
  TOKEN_INTEGER = 259,
  TOKEN_FLOAT = 260,
  TOKEN_STRING = 261,
  TOKEN_OP_SUM = 262,
  TOKEN_OP_SUB = 263,
  TOKEN_OP_MULTIPLIER = 264,
  TOKEN_OP_DIVIDER = 265,
  TOKEN_OP_ASSIGNMENT = 266,
  TOKEN_OP_GREATER = 267,
  TOKEN_OP_LESS = 268,
  TOKEN_OP_GREATER_EQUAL = 269,
  TOKEN_OP_LESS_EQUAL = 270,
  TOKEN_OP_EQUAL = 271,
  TOKEN_OP_NOT = 272,
  TOKEN_OP_NOT_EQUAL = 273,
  TOKEN_BRACKET_OPEN = 274,
  TOKEN_BRACKET_CLOSE = 275,
  TOKEN_PARENTHESIS_OPEN = 276,
  TOKEN_PARENTHESIS_CLOSE = 277,
  TOKEN_INT = 278,
  TOKEN_KFLOAT = 279,
  TOKEN_DOUBLE = 280,
  TOKEN_CHAR = 281,
  TOKEN_BOOL = 282,
  TOKEN_RETURN = 283,
  TOKEN_IF = 284,
  TOKEN_ELSE = 285,
  TOKEN_FOR = 286,
  TOKEN_WHILE = 287,
  TOKEN_IDENTIFIER = 288
  TOKEN_VOID = 289
} token_t;

inline const char *token_str(token_t t)
{
  switch (t)
  {
  case TOKEN_END_OF_LINE:
    return "<END_OF_FILE>";
  case TOKEN_END_SENTENCE:
    return "<END_SENTENCE>";
  case TOKEN_INTEGER:
    return "<INTEGER>";
  case TOKEN_FLOAT:
    return "<FLOAT>";
  case TOKEN_STRING:
    return "<STRING>";
  case TOKEN_OP_SUM:
    return "<SUM>";
  case TOKEN_OP_SUB:
    return "<SUB>";
  case TOKEN_OP_MULTIPLIER:
    return "<MULTIPLIER>";
  case TOKEN_OP_DIVIDER:
    return "<DIVIDER>";
  case TOKEN_OP_ASSIGNMENT:
    return "<ASSIGNMENT>";
  case TOKEN_OP_GREATER:
    return "<GREATER>";
  case TOKEN_OP_LESS:
    return "<LESS>";
  case TOKEN_OP_GREATER_EQUAL:
    return "<GREATER_EQUAL>";
  case TOKEN_OP_LESS_EQUAL:
    return "<LESS_EQUAL>";
  case TOKEN_OP_EQUAL:
    return "<EQUAL>";
  case TOKEN_OP_NOT:
    return "<NOT>";
  case TOKEN_OP_NOT_EQUAL:
    return "<NOT_EQUAL>";
  case TOKEN_BRACKET_OPEN:
    return "<BRACKET_OPEN>";
  case TOKEN_BRACKET_CLOSE:
    return "<BRACKET_CLOSE>";
  case TOKEN_PARENTHESIS_OPEN:
    return "<PARENTHESIS_OPEN>";
  case TOKEN_PARENTHESIS_CLOSE:
    return "<PARENTHESIS_CLOSE>";
  case TOKEN_INT:
    return "<INT>";
  case TOKEN_KFLOAT:
    return "<KFLOAT>";
  case TOKEN_DOUBLE:
    return "<DOUBLE>";
  case TOKEN_CHAR:
    return "<CHAR>";
  case TOKEN_BOOL:
    return "<BOOL>";
  case TOKEN_RETURN:
    return "<RETURN>";
  case TOKEN_IF:
    return "<IF>";
  case TOKEN_ELSE:
    return "<ELSE>";
  case TOKEN_FOR:
    return "<FOR>";
  case TOKEN_WHILE:
    return "<WHILE>";
  case TOKEN_IDENTIFIER:
    return "<IDENTIFIER>";
  case TOKEN_VOID:
    return "<VOID>";
  default:
    return "<UNKNOWN>";
  }
}