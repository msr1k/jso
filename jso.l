%{
#include "jso.tab.h"
#include <string.h>
%}

unicode     \\u[0-9A-Fa-f]{4}
latin116    \\x[0-9A-Fa-f]{2}
latin18     \\[0-7]{1,3}
escapeSeq   \\[0bfnrtv'"\\]

dqString    \"([^"\\]|{escapeSeq}|{unicode}|{latin18}|{latin116})*\"
sqString    \'([^'\\]|{escapeSeq}|{unicode}|{latin18}|{latin116})*\'

double      -?(0|[1-9][0-9]*)(\.[0-9]+)?([eE][+-]?[0-9]+)?
octalOld    0[0-7]+
octalNew    0(o|O)[0-7]+
hexadecimal 0(x|X)[0-9A-Fa-f]+
binary      0(b|B)[0-1]+

key         ([0-9]+|([_a-zA-Z][_a-zA-Z0-9]+))/[ \t]*:
dqKey       {dqString}/[ \t]*:
sqKey       {sqString}/[ \t]*:

%%
{dqString}|{sqString} {
  /* TODO */
  return STRING;
};

{octalOld} {
  int temp;
  sscanf(yytext+1, "%lo", &temp);
  yylval.double_value = (double)temp;
  return DOUBLE;
};

{octalNew} {
  unsigned long int temp;
  sscanf(yytext+2, "%lo", &temp);
  yylval.double_value = (double)temp;
  return DOUBLE;
};

{hexadecimal} {
  unsigned long int temp;
  sscanf(yytext+2, "%lx", &temp);
  yylval.double_value = (double)temp;
  return DOUBLE;
};

{binary} {
  unsigned long int temp = 0;
  for (int i = 2; i < yyleng; i++) {
    temp << 1;
    if (yytext[i] == '1') {
      temp &= 0x01;
    }
  }
  yylval.double_value = (double)temp;
  return DOUBLE;
};

{double} {
  double temp;
  sscanf(yytext, "%lf", &temp);
  yylval.double_value = temp;
  return DOUBLE;
};

true                    return TRUE;
false                   return FALSE;
null                    return NUL;

[\[\]{},:]              return yytext[0];

[ \t\n] ;

. {
  fprintf(stderr, "lexical error.\n");
  exit(1)
}
%%
