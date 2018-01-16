
TARGET = jso

ifeq ($(OS), Windows_NT)
	detectedOS := Windows
else
	detectedOS := $(shell sh -c 'uname -s 2> /dev/null || echo not')
endif

LEX = flex
YACC = yacc

ifeq ($(detectedOS), Windows)
	# Supposed MinGW environment
	EXT = .exe
	CC = gcc
	CCFLAGS = -c -O3 -std=c99
	CPPC = g++
	CPPCFLAGS= -c -O3 -std=c++11
endif
ifeq ($(detectedOS), Darwin)
	EXT =
	CC = clang
	CCFLAGS = -c -O3
	CPPC = clang++
	CPPCFLAGS= -c -O3 -std=c++11
endif
ifeq ($(detectedOS), Linux)
	EXT =
	CC = gcc
	CCFLAGS = -c -O3 -std=c99
	CPPC = g++
	CPPCFLAGS= -c -O3 -std=c++11
endif

$(TARGET)$(EXT): obj/jso.yacc.o obj/jsojson.o
	$(CPPC) -o jso obj/jsojson.o obj/jso.yacc.o

obj/jso.lex.c: jso.l
	$(LEX) -o obj/jso.lex.c jso.l

obj/jso.yacc.c: jso.y
	$(YACC) -o obj/jso.yacc.c jso.y

obj/jso.yacc.o: obj/jso.yacc.c obj/jso.lex.c obj/jsojson.h
	$(CC) $(CCFLAGS) -o obj/jso.yacc.o obj/jso.yacc.c

obj/jsojson.o: jsojson.cpp
	$(CPPC) $(CPPCFLAGS) -o obj/jsojson.o jsojson.cpp

obj/jsojson.h: jsojson.h
	cp jsojson.h obj/jsojson.h

clean:
	rm -f obj/* $(TARGET)$(EXT)

all: clean $(TARGET)$(EXT)
