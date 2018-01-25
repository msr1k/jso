%{
#include <stdio.h>
#include <string.h>

void eat_comment(void);

// #define DEBUG

#ifdef DEBUG
void debug_print_double(double val)
{
  fprintf(stdout, "%lf", val);
}

void debug_print_itself(const char * val)
{
  fprintf(stdout, "%s", val);
}

void debug_print_int(long int val)
{
  fprintf(stdout, "%ld", val);
}

void debug_print_char(char val)
{
  fprintf(stdout, "%c", val);
}
#else
#  define debug_print_double(x)
#  define debug_print_itself(x)
#  define debug_print_int(x)
#  define debug_print_char(x)
#endif

%}

%option yylineno

utf8bom     \xEF\xBB\xBF
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
strictKey   ([0-9]+|[_a-zA-Z][_0-9a-zA-Z]*)

%%
"/*"       {
  debug_print_itself(yytext);
  eat_comment();
  /* no return for block comment */
};

"//"[^\n]* {
  debug_print_itself(yytext);
  /* no return for inline comment */
};

{octalOld} {
  long int temp;
  sscanf(yytext+1, "%lo", &temp);
  debug_print_int(temp);
  yylval.int_value = temp;
  return INT;
};

{octalNew} {
  long int temp;
  sscanf(yytext+2, "%lo", &temp);
  debug_print_int(temp);
  yylval.int_value = temp;
  return INT;
};

{hexadecimal} {
  long int temp;
  sscanf(yytext+2, "%lx", &temp);
  debug_print_int(temp);
  yylval.int_value = temp;
  return INT;
};

{binary} {
  long int temp = 0;
  for (int i = 2; i < yyleng; i++) {
    temp <<= 1;
    if (yytext[i] == '1') {
      temp |= 0x01;
    }
  }
  debug_print_int(temp);
  yylval.int_value = temp;
  return INT;
};

{double} {
  double temp;
  sscanf(yytext, "%lf", &temp);
  debug_print_itself(yytext);
  yylval.double_value = temp;
  return DOUBLE;
};

true     { debug_print_itself(yytext); return TRUE; };
false    { debug_print_itself(yytext); return FALSE; };
null     { debug_print_itself(yytext); return NUL; };

{dqString}|{sqString} {
  debug_print_itself(yytext);
  yytext[yyleng-1] = '\0';
  yylval.string_head = &yytext[1];
  /* yylval.string_head = "dummy"; */
  return STRING;
};

{strictKey} {
  debug_print_itself(yytext);
  yylval.key_head = yytext;
  /* yylval.string_head = "dummy"; */
  return KEY;
}


[\[\]{},:]  { debug_print_char(yytext[0]); return yytext[0]; };
[ \t\n]     { debug_print_char(yytext[0]); };

{utf8bom} {
  return UTF8BOM;
}

. {
  fprintf(stderr, "lexical error (line %d)\n", yylineno);
  exit(1);
}
%%

void eat_comment(void)
{
  int  start_line = yylineno;
  char c, prev = 0;

  while ((c = input()) != 0)
  {
    debug_print_char(c);
    if (c == '/' && prev == '*') {
      return;
    }
    prev = c;
  }
  fprintf(stderr, "lexical error: unterminated comment (line %d-%d)\n", start_line, yylineno);
  exit(1);
}
