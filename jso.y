
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
%token TRUE FALSE NUL UTF8BOM

%%
jso    : value
       | UTF8BOM value
       ;

value  : object
       | array
       | STRING {
         struct JsoJsonPremitiveValue v;
         v.type = JSO_JSON_STRING;
         v.v.s = $1;
         JsoJsonAddValue(h, &v);
       }
       | DOUBLE {
         struct JsoJsonPremitiveValue v;
         v.type = JSO_JSON_DOUBLE;
         v.v.d = $1;
         JsoJsonAddValue(h, &v);
       }
       | INT {
         struct JsoJsonPremitiveValue v;
         v.type = JSO_JSON_INT;
         v.v.i = $1;
         JsoJsonAddValue(h, &v);
       }
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
       | NUL {
         struct JsoJsonPremitiveValue v;
         v.type = JSO_JSON_NULL;
         JsoJsonAddValue(h, &v);
       }
       ;

bs     : '{' {
         JsoJsonEnterObject(h);
       }
       ;
be     : '}' {
         JsoJsonLeaveObject(h);
       }
       ;

object : bs be
       | bs pairs be
       | bs pairs ',' be
       ;

pairs  : pairs ',' pair
       | pair
       ;

pair   : STRING ':' value {
         JsoJsonAddKey(h, $1);
       }
       | KEY    ':' value {
         JsoJsonAddKey2(h, $1);
       }
       ;

ps     : '[' {
         JsoJsonEnterArray(h);
       }
       ;
pe     : ']' {
         JsoJsonLeaveArray(h);
       }
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

int main(int argc, char const* argv[])
{
  int pretty_format = 0;
  if (argc >= 2) {
    if ( strcmp(argv[1], "-p") == 0 ) {
      pretty_format = 1;
    }
  }
  h = JsoJsonCreate();
  yyparse();
  JsoJsonGetJsonString(h, pretty_format);
  JsoJsonDestroy(h);
}

