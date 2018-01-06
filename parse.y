
%{
#define YYDEBUG 1
#define YYERROR_VERBOSE 1

#include <stdio.h>

static void yyerror(const char *s)
{
  fputs(s, stderr);
  fputs("\n", stderr);
}

static int yywrap(void)
{
  return 1;
}
%}

%union {
  double double_value;
  char * string_head;
}

%token <string_head> STRING
%token <double_value> DOUBLE
%token TRUE FALSE NUL

%%
jso : value
    ;

value : object
      | array
      | STRING
      | DOUBLE
      | TRUE
      | FALSE
      | NUL
      ;

object : '{' '}'
       | '{' pairs '}'
       | '{' pairs ',' '}'
       ;

pairs  : pairs ',' pair
       | pair
       ;

pair   : STRING ':' value
       ;

array  : '[' ']'
       | '[' values ']'
       | '[' values ',' ']'
       ;

values : values ',' value
       | value
       ;
%%

#include "lex.yy.c"

int main()
{
  yyparse();
}

