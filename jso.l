%{
#include <stdio.h>
#include <string.h>

void print_double(double val)
{
  fprintf(stdout, "%lf", val);
}

void print_itself(const char * val)
{
  fprintf(stdout, "%s", val);
}

void print_int(int val)
{
  fprintf(stdout, "%d", val);
}

void print_char(char val)
{
  fprintf(stdout, "%c", val);
}
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
  print_itself(yytext);
  yytext[yyleng-1] = '\0';
  yylval.string_head = &yytext[1];
  /* yylval.string_head = "dummy"; */
  return STRING;
};

{octalOld} {
  unsigned long int temp;
  sscanf(yytext+1, "%lo", &temp);
  print_int(temp);
  yylval.double_value = (double)temp;
  /* yylval.double_value = 0.0; */
  return DOUBLE;
};

{octalNew} {
  unsigned long int temp;
  sscanf(yytext+2, "%lo", &temp);
  print_int(temp);
  yylval.double_value = (double)temp;
  /* yylval.double_value = 0.0; */
  return DOUBLE;
};

{hexadecimal} {
  unsigned long int temp;
  sscanf(yytext+2, "%lx", &temp);
  print_int(temp);
  yylval.double_value = (double)temp;
  /* yylval.double_value = 0.0; */
  return DOUBLE;
};

{binary} {
  unsigned long int temp = 0;
  for (int i = 2; i < yyleng; i++) {
  temp <<= 1;
  if (yytext[i] == '1') {
  temp &= 0x01;
  }
  }
  print_int(temp);
  /* yylval.double_value = 0.0; */
  return DOUBLE;
};

{double} {
  double temp;
  sscanf(yytext, "%lf", &temp);
  yylval.double_value = temp;
  /* yylval.double_value = 0.0; */
  print_itself(yytext);
  return DOUBLE;
};
true     { print_itself(yytext); return TRUE; };
false    { print_itself(yytext); return FALSE; };
null     { print_itself(yytext); return NUL; };

[\[\]{},:]  { print_char(yytext[0]); return yytext[0]; };
[ \t\n]     { print_char(yytext[0]); };

. {
  fprintf(stderr, "lexical error.\n");
  exit(1);
}
%%

