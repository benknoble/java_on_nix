#! /usr/bin/env make -f

# VARS {{{

# CONVENTIONS {{{

# Ensure we use sh
SHELL = /bin/sh
# Make sure SUFFIXES only contains what we want (so sneaky implicit rules don't
# catch us off guard)
.SUFFIXES:
.SUFFIXES: .java .class

# }}}

# PROJECT STRUCTURE {{{

# Where the source lives (.java)
SOURCEPATH ?= src
# Where to find libraries (.jar)
LIBDIR ?= lib
# Find them, and set them up for -classpath usage
LIBS := $(shell printf '%s:' $(wildcard $(LIBDIR)/*.jar))
# Where to place binaries (.class)
BINDIR ?= bin

# Find all the java files
SRC := $(shell find $(SOURCEPATH) -iname '*.java')
# Generate names of class files (this is a very naïve conversion, but works well
# enough)
BIN := $(subst $(SOURCEPATH),$(BINDIR),$(SRC:.java=.class))

# Jar to create
JAR_FILE ?= Nix.jar
# File under $(SOURCEPATH) containing a declaration of
# public static void main(String[] args)
MAIN ?= nix/Main.java

# Generate class name for CLI
# e.g. com/Main.java becomes com.Main
MAIN_CLASS := $(subst /,.,$(MAIN:.java=))

# Where to place the generated script
SCRIPTDIR ?= scripts
SCRIPT := $(SCRIPTDIR)/run

# }}}

# COMPILERS & FLAGS {{{

JC := javac
JCFLAGS := -g -cp $(LIBS) -sourcepath $(SOURCEPATH) -d $(BINDIR)
JV := java
JVFLAGS := -cp $(LIBS):$(BINDIR)
JR := jar
JRFLAGS := cf $(JAR_FILE)
JDB := jdb
JDBFLAGS := -classpath $(LIBS):$(BINDIR) -sourcepath $(SOURCEPATH) $(MAIN_CLASS)

# Canned recipe for running java program
define run_java
$(JV) $(JVFLAGS) $(MAIN_CLASS)
endef

# }}}

# }}}

# TARGETS {{{

# Build the program
# This is the default
all: $(BIN)

# Make a jar archive
jar: $(JAR_FILE)

# Make a runner script
script: $(SCRIPT)

# How to build the program
$(BIN): $(SRC) | $(BINDIR)
	$(JC) $(JCFLAGS) $(SRC)

# Create the necessary directories
$(SCRIPTDIR) $(BINDIR): ;
	mkdir $@

# How to make the jar archive
$(JAR_FILE): $(BIN)
	$(JR) $(JRFLAGS) $(BIN)

$(SCRIPT): $(BIN) | $(SCRIPTDIR)
	printf '%s\n' '#! /bin/sh' '' 'exec $(run_java) "$$@"' > $@
	[ -x $@ ] || chmod u+x $@

# Cleanup
.PHONY: clean
clean:
	-rm -rf $(BINDIR) $(JAR_FILE) $(SCRIPTDIR)

# Run the java program
.PHONY: run
run: $(BIN)
	-$(run_java)

# Run the java program with assertions enabled
.PHONY: debug_run
debug_run: JVFLAGS += -ea
debug_run: run

# Run the debugger
.PHONY: jdb
jdb: $(BIN)
	$(JDB) $(JDBFLAGS)

# }}}
