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
# File to run for testing
TEST ?= tests/Test.java

# Generate class name for CLI
# e.g. com/Main.java becomes com.Main
MAIN_CLASS := $(subst /,.,$(MAIN:.java=))
TEST_CLASS := $(subst /,.,$(TEST:.java=))

# Where to place the generated script
SCRIPTDIR ?= scripts
RUN := $(SCRIPTDIR)/run
DEBUG := $(SCRIPTDIR)/debug

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
.PHONY: all
all: $(BIN)

# Make a jar archive
.PHONY: jar
jar: $(JAR_FILE)

.PHONY: runners
runners: $(RUN) $(DEBUG)

.PHONY: test
test: MAIN_CLASS := $(TEST_CLASS)
test: $(BIN)
	$(run_java)

# How to build the program
$(BIN): $(SRC) | $(BINDIR)
	$(JC) $(JCFLAGS) $^

# Create the necessary directories
$(SCRIPTDIR) $(BINDIR): ;
	[ -d "$@" ] || mkdir $@

# How to make the jar archive
$(JAR_FILE): $(BIN)
	$(JR) $(JRFLAGS) $^

$(DEBUG): JVFLAGS += -ea
$(RUN) $(DEBUG): $(BIN) | $(SCRIPTDIR)
	printf '%s\n' '#! /bin/sh' '' 'exec $(run_java) "$$@"' > $@
	[ -x $@ ] || chmod u+x $@

# Cleanup
.PHONY: clean
clean:
	-rm -rf $(BINDIR) $(JAR_FILE) $(SCRIPTDIR)

# Run the debugger
.PHONY: jdb
jdb: $(BIN)
	$(JDB) $(JDBFLAGS)

# }}}
