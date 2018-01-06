%{
#include <stdio.h>
#include <string.h>

void eat_comment(void);

void print_double(double val)
{
  fprintf(stdout, "%lf", val);
}

void print_itself(const char * val)
{
  fprintf(stdout, "%s", val);
}

void print_int(long int val)
{
  fprintf(stdout, "%ld", val);
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

white       ' \t\n'
marks       '\"\'\\\[\]{},\.:;!#\$%&\(\)\-=~^\|`@\*\+_\?><'
extendedKey ([0-9]+|([^{marks}{white}]|{unicode}|{latin18}|{latin116})+)
strictKey   ([0-9]+|[_a-zA-Z][_0-9a-zA-Z]+)

%%
"/*"       {
  print_itself(yytext);
  eat_comment();
  /* no return for block comment */
};

"//"[^\n]* {
  print_itself(yytext);
  /* no return for inline comment */
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
  long int temp;
  sscanf(yytext+2, "%lo", &temp);
  print_int(temp);
  yylval.double_value = (double)temp;
  /* yylval.double_value = 0.0; */
  return DOUBLE;
};

{hexadecimal} {
  long int temp;
  sscanf(yytext+2, "%lx", &temp);
  print_int(temp);
  yylval.double_value = (double)temp;
  /* yylval.double_value = 0.0; */
  return DOUBLE;
};

{binary} {
  long int temp = 0;
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

{dqString}|{sqString} {
  print_itself(yytext);
  yytext[yyleng-1] = '\0';
  yylval.string_head = &yytext[1];
  /* yylval.string_head = "dummy"; */
  return STRING;
};

{strictKey} {
  print_itself(yytext);
  yylval.string_head = yytext;
  /* yylval.string_head = "dummy"; */
  return KEY;
}


[\[\]{},:]  { print_char(yytext[0]); return yytext[0]; };
[ \t\n]     { print_char(yytext[0]); };

. {
  fprintf(stderr, "lexical error.\n");
  exit(1);
}
%%

void eat_comment(void)
{
  char c, prev = 0;

  while ((c = input()) != 0)
  {
    print_char(c);
    if (c == '/' && prev == '*') {
      return;
    }
    prev = c;
  }
  fprintf(stderr, "lexical error: unterminated comment\n");
}
