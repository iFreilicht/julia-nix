# This file is a part of Julia. License is MIT: https://julialang.org/license

# This Makefile template requires the following variables to be set
# in the environment or on the command-line:
#   JULIA: path to julia[.exe] executable
#   BIN:   binary build directory

ifndef JULIA
  $(error "Please pass JULIA=[path of target julia binary], or set as environment variable!")
endif
ifndef BIN
  $(error "Please pass BIN=[path of build directory], or set as environment variable!")
endif

#=============================================================================
# this source directory where gcext.c is located
SRCDIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

# get the executable suffix, if any
EXE := $(suffix $(abspath $(JULIA)))

OS := $(shell uname)
ifeq ($(OS), Darwin)
  DYLIB := .dylib
else
  DYLIB := .so
endif

# get compiler and linker flags. (see: `contrib/julia-config.jl`)
JULIA_CONFIG := $(JULIA) -e 'include(joinpath(Sys.BINDIR, Base.DATAROOTDIR, "julia", "julia-config.jl"))' --
CPPFLAGS_ADD :=
CFLAGS_ADD = $(shell $(JULIA_CONFIG) --cflags)
LDFLAGS_ADD = -lm $(shell $(JULIA_CONFIG) --ldflags --ldlibs)
DYLIBFLAGS := --shared -fPIC

DEBUGFLAGS += -g

#=============================================================================

release: $(BIN)/gcext$(EXE) $(BIN)/Foreign/deps/foreignlib$(DYLIB)
debug:   $(BIN)/gcext-debug$(EXE) $(BIN)/Foreign/deps/foreignlib-debug$(DYLIB)

$(BIN)/gcext$(EXE): $(SRCDIR)/gcext.c
	$(CC) $^ -o $@ $(CPPFLAGS_ADD) $(CPPFLAGS) $(CFLAGS_ADD) $(CFLAGS) $(LDFLAGS_ADD) $(LDFLAGS)

$(BIN)/gcext-debug$(EXE): $(SRCDIR)/gcext.c
	$(CC) $^ -o $@ $(CPPFLAGS_ADD) $(CPPFLAGS) $(CFLAGS_ADD) $(CFLAGS) $(LDFLAGS_ADD) $(LDFLAGS) $(DEBUGFLAGS)

$(BIN)/foreignlib$(DYLIB): $(SRCDIR)/Foreign/deps/foreignlib.c
	$(CC) $^ -o $@ $(DYLIBFLAGS) $(CPPFLAGS_ADD) $(CPPFLAGS) $(CFLAGS_ADD) $(CFLAGS) $(LDFLAGS_ADD) $(LDFLAGS)

$(BIN)/foreignlib-debug$(DYLIB): $(SRCDIR)/Foreign/deps/foreignlib.c
	$(CC) $^ -o $@ $(DYLIBFLAGS) $(CPPFLAGS_ADD) $(CPPFLAGS) $(CFLAGS_ADD) $(CFLAGS) $(LDFLAGS_ADD) $(LDFLAGS) $(DEBUGFLAGS)

ifneq ($(abspath $(BIN)),$(abspath $(SRCDIR)))
# for demonstration purposes, our demo code is also installed
# in $BIN, although this would likely not be typical
$(BIN)/LocalTest.jl: $(SRCDIR)/LocalTest.jl
	cp $< $@
endif

check: $(BIN)/gcext$(EXE) $(BIN)/LocalTest.jl $(BIN)/foreignlib$(DYLIB)
	BINDIR=$(BIN) $(JULIA) --depwarn=error $(SRCDIR)/gcext-test.jl $<
	@echo SUCCESS

clean:
	-rm -f $(BIN)/gcext-debug$(EXE) $(BIN)/gcext$(EXE)
	-rm -f $(BIN)/foreignlib$(DYLIB)
	-rm -f $(BIN)/foreignlib-debug$(DYLIB)

.PHONY: release debug clean check

# Makefile debugging trick:
# call print-VARIABLE to see the runtime value of any variable
print-%:
	@echo '$*=$($*)'
