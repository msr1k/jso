
%{
#define YYDEBUG 1
#define YYERROR_VERBOSE 1

#include <stdio.h>
#include "jsojson.h"

static struct JsoJsonHandle* h;

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
  char * key_head;
  char * string_head;
  double double_value;
  long int int_value;
}

%token <key_head>     KEY
%token <string_head>  STRING
%token <double_value> DOUBLE
%token <int_value>    INT
%token TRUE FALSE NUL

%%
jso    : value
       ;

value  : object
       | array
       | STRING
       | DOUBLE
       | TRUE   {
         struct JsoJsonPremitiveValue v;
         v.type = JSO_JSON_BOOL;
         v.v.b = JSO_JSON_TRUE;
         JsoJsonAddValue(h, &v);
       }
       | FALSE {
         struct JsoJsonPremitiveValue v;
         v.type = JSO_JSON_BOOL;
         v.v.b = JSO_JSON_FALSE;
         JsoJsonAddValue(h, &v);
       }
       | NUL
       ;

bs     : '{' {}
       ;
be     : '}' {}
       ;

object : bs be
       | bs pairs be
       | bs pairs ',' be
       ;

pairs  : pairs ',' pair
       | pair
       ;

pair   : STRING ':' value
       | KEY    ':' value
       ;

ps     : '[' {}
       ;
pe     : ']' {}
       ;

array  : ps pe
       | ps values pe
       | ps values ',' pe
       ;

values : values ',' value
       | value
       ;
%%

#include "jso.lex.c"

int main()
{
  h = JsoJsonCreate();
  yyparse();
  JsoJsonGetJsonString(h);
  JsoJsonDestroy(h);
}

