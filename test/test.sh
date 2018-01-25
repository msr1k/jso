#!/bin/bash

cd "`dirname $0`"

echo "-- start jso test --"

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

echo "0b1 must be 1"
echo -n ">> "
echo 0b1 | ../jso
echo

echo "0o7 must be 7"
echo -n ">> "
echo 0o7 | ../jso
echo

echo "0xF must be 15"
echo -n ">> "
echo 0xF | ../jso
echo

echo "1.234 must be 1.234"
echo -n ">> "
echo 1.234 | ../jso
echo

echo "\"asdf\" must be \"asdf\""
echo -n ">> "
echo "\"asdf\"" | ../jso
echo

echo "{} must be {}"
echo -n ">> "
echo "{}" | ../jso
echo

echo "[] must be []"
echo -n ">> "
echo "[]" | ../jso
echo

echo "[ \"asdf\" ] must be [\"asdf\"]"
echo -n ">> "
echo "[ \"asdf\" ]" | ../jso
echo

echo "[ \"asdf\", 1, true ] must be [\"asdf\", 1, true]"
echo -n ">> "
echo "[ \"asdf\", 1, true ]" | ../jso
echo

echo "{ \"asdf\": 1 } must be {\"asdf\":1}"
echo -n ">> "
echo "{ \"asdf\": 1 }" | ../jso
echo

echo '{ "asdf": 1, qwer: 2.3 } must be {"asdf":1, "qwer": 2.3}'
echo -n ">> "
echo '{ "asdf": 1, qwer: 2.3}' | ../jso
echo

echo '[1,2,3,[4,5,6]] must be [1,2,3,[4,5,6]]'
echo -n ">> "
echo '[1,2,3,[4,5,6]]' | ../jso
echo

echo '{ "asdf": [1,2,3] } must be { "asdf": [1,2,3] }'
echo -n '>> '
echo '{"asdf": [1,2,3] }' | ../jso
echo

echo '{ "asdf": [1,2,3], "qwer": { "a": 2.3, "b": -987 } must be ...'
echo -n ">> "
echo '{"asdf": [1,2,3], "qwer": { "a": 2.3, "b": -987} }' | ../jso
echo

echo '{ "asdf": { "a": 2.3, "b": -987, }, } must be ...'
echo -n ">> "
echo '{"asdf": { "a": 2.3, "b": -987,}, }' | ../jso
echo

echo '{ "a": { "b": { "c": { "d": 1 } } } } must be...'
echo -n ">> "
echo '{ "a": { "b": { "c": { "d": 1 } } } }' | ../jso

echo '{ "a": { "b": { "c": { "d": 1 }, "e": {} } } } must be...'
echo -n ">> "
echo '{ "a": { "b": { "c": { "d": 1 }, "e": {} } } }' | ../jso

echo '{ a: { b: { c: { d: 1 }, e: {} } } } must be...'
echo -n ">> "
echo '{ a: { b: { c: { d: 1 }, e: {} } } }' | ../jso

echo '[[[[[1]]],[]]] must be...'
echo -n ">> "
echo '[[[[[1]]],[]]]' | ../jso

echo '{ "a": { "b": { "c": { "d": 1 } } } } must be...'
echo -n ">> "
echo '{ "a": { "b": { "c": { "d": 1 } } } }' | ../jso -p

echo '{ "a": { "b": { "c": { "d": 1 }, "e": {} } } } must be...'
echo -n ">> "
echo '{ "a": { "b": { "c": { "d": 1 }, "e": {} } } }' | ../jso -p

echo '{ a: { b: { c: { d: 1 }, e: {} } } } must be...'
echo -n ">> "
echo '{ a: { b: { c: { d: 1 }, e: {} } } }' | ../jso -p

echo '[[[[[1]]],[]]] must be...'
echo -n ">> "
echo '[[[[[1]]],[]]]' | ../jso -p

echo 'testee/jso_wrong_lexical_error.jso must be...'
echo -n ">> "
cat testee/jso_wrong_lexical_error.jso | ../jso

echo '{ a   :   5 }  must be...'
echo -n ">> "
echo '{ a   :   5 }' | ../jso -p

echo 'testee/jso_utf8bom.jso must be...'
echo -n ">> "
cat testee/jso_utf8bom.jso | ../jso

