jso: jso.yacc.o jsojson.o
	clang++ -o jso jso.lex.o jso.yacc.o jsojson.o

jso.lex.c: jso.l
	lex -o jso.lex.c jso.l
jso.yacc.c: jso.y
	yacc -o jso.yacc.c jso.y
jso.yacc.o: jso.yacc.c jso.lex.c
	clang jso.yacc.c
jsojson.o: jsojson.c
	clang++ -std=c++11 jsojson.cpp

