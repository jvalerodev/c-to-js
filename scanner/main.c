#include <stdio.h>
#include <stdlib.h>
#include "token.h"

extern FILE *yyin;
extern char *yytext;

int yylex();

const char *token_str(token_t t);

void usage(char *argv[])
{
  printf("Usage: %s input_file\n", argv[0]);
  exit(1);
}

int main(int argc, char *argv[])
{
  if (argc != 2)
  {
    usage(argv);
  }

  yyin = fopen(argv[1], "r");

  if (!yyin)
  {
    printf("Could not open %s\n", argv[1]);
    exit(1);
  }

  while (1)
  {
    token_t t = yylex();

    if (t == TOKEN_END_OF_LINE)
    {
      printf("End of file\n");
      break;
    }

    printf("Token: %s value: %s\n", token_str(t), yytext);
  }

  return 0;
}