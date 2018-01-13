jso: obj/jso.yacc.o obj/jsojson.o
	clang++ -o jso obj/jsojson.o obj/jso.yacc.o

obj/jso.lex.c: jso.l
	lex -o obj/jso.lex.c jso.l

obj/jso.yacc.c: jso.y
	yacc -o obj/jso.yacc.c jso.y

obj/jso.yacc.o: obj/jso.yacc.c obj/jso.lex.c obj/jsojson.h
	clang -c -o obj/jso.yacc.o obj/jso.yacc.c

obj/jsojson.o: jsojson.cpp
	clang++ -c -std=c++11 -o obj/jsojson.o jsojson.cpp

obj/jsojson.h: jsojson.h
	cp jsojson.h obj/jsojson.h
