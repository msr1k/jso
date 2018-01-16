JSO
===

Description
-----------

This is JavaScript object like data format.

Supported data type is just same as JSON.
But JSO notation, against JSON, is almost same as JavaScript.

Dependency
----------

- flex (lexical analyzer)
- bison (grammatival analyzer)

Purpose
-------

- To create converter JSO to JSON or replace JSON with JSO in some place

    JSON sometimes hard to apply for, for example, setting file at least to me.
    Beacause it does not allow comment, trailing comma and so on.

### Notice

Since this format gives writer various way of writing and it can also include meta information as comment, this is impure data format.

For example, saving after loading JSO file by some program, in the future, may loose some kind of information, comment or format of number or something.

Current status
--------------

For the time being, this program can convert JSO formatted string into JSON.

### Build

You can build this program by following command

    $ make

On Windows, MinGW environment is supposed.

#### Another way of build (obsolete)

macOS (Use clang, clang++)

    $ make -f make_mac.mak

Linux (Use gcc, g++)

    $ make -f make_linux.mak

Windows MinGW (Use gcc, g++)

    > make -f make_mingw.mak

### Usage

On macOS, Linux

    $ cat jso_file | ./jso > json_file

On Windows

    > type jso_file | ./jso > json_file

Details
-------

Unlike JSON, JSO allows following notations.

### Trailing comma of array or object.

```javascript
  [
    1,
    2,
    3, // <-
  ]
```

```javascript
  {
    "a": 1,
    "b": 2,
    "c": 3, // <-
    }
```

### Hexadecimal, Octal and Binary formatted number

```javascript
  0x0F
  0X0E
  007
  0o06
  0O05
  0b01
  0B10
```

### Single quoted string

```javascript
  {
    'asdf': 'qwer'
  }
```

### None-string type object key

```javascript
  {
    a: 1
  }
```

### Comment

```javascript
  {
     "a": 1, // This is inline style comment
     /*
      * This is block type comment
      */
     "b": 2,
   }
```

LICENSE
-------

See LICENSE file.

