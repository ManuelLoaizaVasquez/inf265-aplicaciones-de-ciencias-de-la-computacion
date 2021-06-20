%{
void yyerror(char* s);
int yylex();
#include <stdio.h>
#include <ctype.h>
#include <string.h>
char lexema[100];
%}

%token DIGIT ID IF

%%
stmt: expr { printf("%d\n", $1); }

expr: expr '+' term { $$ = $1 + $3; }
    | expr '-' term { $$ = $1 - $3; }
    | term { $$ = $1; };

term: term '*' factor { $$ = $1 * $3; }
    | term '/' factor { $$ = $1 / $3; }
    | factor { $$ = $1; };

factor: DIGIT { $$ = $1; }
      | ID { $$ = $1; }
      | '(' expr ')' { $$ = $2; };
%%

int main(void) {
  if (!yyparse()) {
    printf("Valid string\n");
  } else {
    printf("Empty string\n");
  }
  return 0;
}

/* Lexical analysis */

int yylex(void) {
  char c;
  int i;

  while ((c = getchar()) == ' ');

  if (isdigit(c)) {
    ungetc(c, stdin);
    scanf("%d", &yylval);
    return DIGIT;
  }

  i = 0;
  if (isalpha(c) || c == '_') {
    do {
      lexema[i++] = c;
      c = getchar();
    } while (isalnum(c) || c == '_');
    ungetc(c, stdin);
    lexema[i] = '\0';
    if (strcmp(lexema, "if") == 0) return IF;
    return ID;
  }

  if (c == '\n') return 0;
  return c;
}

void yyerror(char* s) {
}
