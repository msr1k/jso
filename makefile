jso: jso.yacc.o jsojson.o
	clang++ -o jso jsojson.o jso.yacc.o

jso.lex.c: jso.l
	lex -o jso.lex.c jso.l

jso.yacc.c: jso.y
	yacc -o jso.yacc.c jso.y

jso.yacc.o: jso.yacc.c jso.lex.c
	clang -c -o jso.yacc.o jso.yacc.c

jsojson.o: jsojson.cpp
	clang++ -c -std=c++11 jsojson.cpp

