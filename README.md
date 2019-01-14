# Java on \*nix

This is a small sample project that seeks to provide a template or starter kit
for java projects on unix.

With that in mind, it provides a ready-to-go Makefile, along with a complete
(dummy) java program as proof of concept that it works.

## Makefile

Using the Makefile requires editing just a few key lines, all of which are
variable definitions:

- `JAR_FILE` controls the name of the produced jar
- `MAIN` should be the path under `src` to a java file with the `main` method

Other variables can be changed in the Makefile or even set as environment
variables, but should "just work" by default.

It assumes the following project structure

- `src` contains `.java` source files
- `lib` contains `.jar` files (libraries) on which the source depends
- `bin` will contain generated `.class` files (and is automatically generated)
