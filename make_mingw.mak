jso.exe: obj/jso.yacc.o obj/jsojson.o
	g++ -o jso obj/jsojson.o obj/jso.yacc.o

obj/jso.lex.c: jso.l
	flex -o obj/jso.lex.c jso.l

obj/jso.yacc.c: jso.y
	yacc -o obj/jso.yacc.c jso.y

obj/jso.yacc.o: obj/jso.yacc.c obj/jso.lex.c obj/jsojson.h
	gcc -c -O3 -std=c99 -o obj/jso.yacc.o obj/jso.yacc.c

obj/jsojson.o: jsojson.cpp
	g++ -c -O3 -std=c++11 -o obj/jsojson.o jsojson.cpp

obj/jsojson.h: jsojson.h
	cp jsojson.h obj/jsojson.h

clean:
	rm -f obj/* jso.exe

all: clean jso.exe
