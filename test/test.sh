#!/bin/bash

cd "`dirname $0`"

echo "[[start jso test]]"

echo "true must be true"
echo -n ">> "
echo true | ../jso
echo

echo "false must be false"
echo -n ">> "
echo false | ../jso
echo

echo "null must be null"
echo -n ">> "
echo "null" | ../jso
echo

echo "1 must be 1"
echo -n ">> "
echo 1 | ../jso
echo

echo "1.234 must be 1.234"
echo -n ">> "
echo 1.234 | ../jso
echo

echo "\"asdf\" must be \"asdf\""
echo -n ">> "
echo "\"asdf\"" | ../jso
echo
