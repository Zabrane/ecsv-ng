# Based on c_src.mk from erlang.mk by Loic Hoguin <essen@ninenines.eu>

CURDIR := $(shell pwd)
BASEDIR := $(abspath $(CURDIR)/..)

PROJECT ?= $(notdir $(BASEDIR))
PROJECT := $(strip $(PROJECT))

ERTS_INCLUDE_DIR ?= $(shell erl -noshell -eval "io:format(\"~s/erts-~s/include/\", [code:root_dir(), erlang:system_info(version)]), init:stop().")
ERL_INTERFACE_INCLUDE_DIR ?= $(shell erl -noshell -eval "io:format(\"~s\", [code:lib_dir(erl_interface, include)]), init:stop().")
ERL_INTERFACE_LIB_DIR ?= $(shell erl -noshell -eval "io:format(\"~s\", [code:lib_dir(erl_interface, lib)]), init:stop().")

C_SRC_DIR = $(CURDIR)
C_SRC_OUTPUT ?= $(CURDIR)/../priv/$(PROJECT).so

# System type and C compiler/flags.

UNAME_SYS := $(shell uname -s)
ifeq ($(UNAME_SYS), Darwin)
	CC ?= cc
	CFLAGS ?= -O3 -std=c99 -flto -finline-functions -Wall -Wextra -I/opt/homebrew/opt/libcsv/include #-fsanitize=address,memory
	CXXFLAGS ?= -O3 -flto -finline-functions -Wall -I/opt/homebrew/opt/libcsv/include
	LDFLAGS ?= -flat_namespace -undefined suppress -L/opt/homebrew/opt/libcsv/lib
else ifeq ($(UNAME_SYS), FreeBSD)
	CC ?= cc
	CFLAGS ?= -O3 -flto -std=c99 -finline-functions -Wall -Wextra
	CXXFLAGS ?= -O3 -flto -finline-functions -Wall
else ifeq ($(UNAME_SYS), Linux)
	CC ?= gcc
	CFLAGS ?= -O3 -std=c99 -finline-functions -Wall -Wextra
	CXXFLAGS ?= -O3 -finline-functions -Wall
endif

CFLAGS += -fvisibility=hidden -fPIC -I $(ERTS_INCLUDE_DIR) -I $(ERL_INTERFACE_INCLUDE_DIR)
CXXFLAGS += -fPIC -I $(ERTS_INCLUDE_DIR) -I $(ERL_INTERFACE_INCLUDE_DIR)

LDLIBS += -L $(ERL_INTERFACE_LIB_DIR) -lei -lcsv
LDFLAGS += -shared

# Verbosity.

c_verbose_0 = @echo " C     " $(?F);
c_verbose = $(c_verbose_$(V))

cpp_verbose_0 = @echo " CPP   " $(?F);
cpp_verbose = $(cpp_verbose_$(V))

link_verbose_0 = @echo " LD    " $(@F);
link_verbose = $(link_verbose_$(V))

SOURCES := $(shell find $(C_SRC_DIR) -type f \( -name "*.c" -o -name "*.C" -o -name "*.cc" -o -name "*.cpp" \))
OBJECTS = $(addsuffix .o, $(basename $(SOURCES)))

COMPILE_C = $(c_verbose) $(CC) $(CFLAGS) $(CPPFLAGS) -c
COMPILE_CPP = $(cpp_verbose) $(CXX) $(CXXFLAGS) $(CPPFLAGS) -c

all: $(C_SRC_OUTPUT)

# pull in dependency info for *existing* .o files
-include $(OBJECTS:.o=.d)

$(C_SRC_OUTPUT): $(OBJECTS)
	@mkdir -p $(BASEDIR)/priv/
	$(link_verbose) $(CC) $(OBJECTS) $(LDFLAGS) $(LDLIBS) -o $(C_SRC_OUTPUT)

%.o: %.c
	$(COMPILE_C) $(OUTPUT_OPTION) $<
	$(CC) -MM $(CFLAGS) $< > $*.d

%.o: %.cc
	$(COMPILE_CPP) $(OUTPUT_OPTION) $<
	$(CXX) -MM $(CFLAGS) $< > $*.d

%.o: %.C
	$(COMPILE_CPP) $(OUTPUT_OPTION) $<
	$(CXX) -MM $(CFLAGS) $< > $*.d

%.o: %.cpp
	$(COMPILE_CPP) $(OUTPUT_OPTION) $<
	$(CXX) -MM $(CFLAGS) $< > $*.d

clean:
	@rm -f $(C_SRC_OUTPUT) $(OBJECTS) $(OBJECTS:.o=.d)
