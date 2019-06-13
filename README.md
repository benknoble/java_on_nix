# Java on \*nix

[![This project is considered finished](https://img.shields.io/badge/status-finished-success.svg)](https://benknoble.github.io/status/finished/)

This is a small sample project that seeks to provide a template or starter kit
for java projects on \*nix.

With that in mind, it provides a ready-to-go Makefile, along with a complete
(dummy) java program as proof of concept that it works. The Makefile is
commented and should prove fairly straightforward; I recommend [reading the
docs][make] if there are questions.

Also check the `.gitignore` for some suggestions.

## Makefile

Using the Makefile requires editing just a few key lines, all of which are
variable definitions:

- `JAR_FILE` controls the name of the produced jar
- `MAIN` should be the path under `src` to a java file with the `main` method
- `TEST` should be the path under `src` to a java file with a `main` method that
  invokes whatever test setup you have

Other variables can be changed in the Makefile or even set as environment
variables, but should "just work" by default.

It assumes the following project structure

- `src` contains `.java` source files
- `lib` contains `.jar` files (libraries) on which the source depends
- `bin` will contain generated `.class` files (and is automatically generated)
- `scripts` will contain generated files that can be executed to run the program
  as if it were a regular CLI binary, passing along all arguments

### Key Targets

- `all`: the default. Builds the class files
- `jar`: make the 'jarchive'
- `runners`: make the scripts
- `test`: run the tests
- `clean`: delete any generated files
- `jdb`: run the debugger (jdb)

### Related

I've got a script to download the newest version of the Makefile [here][script];
it will even save and restore your changes to `JAR_FILE` and `MAIN`. If you
change lots of things, though, I wouldn't recommend using it. This is a place
where it's good to have things in version control.

__Vim User?__

See my [Dotfiles][Dotfiles] for some examples of ways I make coding Java in Vim
easier. Of particular relevance is my [`javamake` compiler plugin][compiler].

[make]: https://www.gnu.org/software/make/manual/html_node/index.html#Top
[Dotfiles]: https://github.com/benknoble/Dotfiles/tree/master/links/vim
[compiler]: https://github.com/benknoble/Dotfiles/blob/master/links/vim/compiler/javamake.vim
[script]: https://github.com/benknoble/Dotfiles/blob/master/links/bin/java-update-mfile
