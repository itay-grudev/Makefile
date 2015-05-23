# The MIT License (MIT)

# Copyright (c) 2014 Itay Grudev <itay@grudev.com>

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# Based on a Makefile written by Ivan Tabashki, published under WTF Public
# License, with minor modifications and improvments.
#

# Basic Setup
EXECNAME = bin
BINDIR   = bin/
OBJDIR   = $(BINDIR)obj/

# List the source input directories
# Example: SRCDIRS = . lib1 lib2
SRCDIRS = .

# The source file types (headers excluded).
# .c indicates C source files, and others C++ ones.
SRCEXTS = .c .C .cc .cpp .CPP .c++ .cxx .cp

SOURCES = $(foreach d,$(SRCDIRS),$(wildcard $(addprefix $(d)/*,$(SRCEXTS))))
OBJECTS = $(addprefix $(OBJDIR), $(SOURCES:.cpp=.o))

# Default build
# Can be changed when invocating 'make' using the '-e BUILD=???' argument
BUILD = debug

# Compiler command
CC = g++

# Initial flags (are added to the compile command first)
# You might need CCFLAGS -I /usr/local/include/
CCFLAGS = -Wall -pedantic -std=c++11
# You might need LDFLAGS = -L /usr/local/lib/
LDFLAGS =

# Insert linker and compiler arguments here
# Example LDFLAGS += -lsomelib
CCFLAGS +=
LDFLAGS +=

EXECUTABLE = $(BINDIR)$(EXECNAME)

# Check for debug or not
ifeq ($(BUILD),debug)
	CCFLAGS += -g
else
	CCFLAGS += -O2
endif

# Check if we need to make a seperate bin folder
ifneq ($(BINDIR), )
	BINDIRCOMMAND = mkdir -p $(BINDIR)
else
	BINDIRCOMMAND =
endif

# Check if we need to make a seperate obj folder and its subfolder structure
ifneq ($(OBJDIR), )
	OBJDIRCOMMAND = mkdir -p $(OBJDIR)
	OBJDIRCOMMAND += $(foreach d,$(SRCDIRS), $(OBJDIR)$(d))
else
	OBJDIRCOMMAND =
endif

# Building recipies
all: $(SOURCES) $(EXECUTABLE)

run:
	$(EXECUTABLE)

$(EXECUTABLE): bindir objdir $(OBJECTS)
	$(CC) $(CCFLAGS) $(OBJECTS) -o $@ $(LDFLAGS)

bindir:
	$(BINDIRCOMMAND)

objdir:
	$(OBJDIRCOMMAND)

$(OBJECTS) : $(OBJDIR)%.o : $(SRCDIR)%.cpp
	$(CC) $(CCFLAGS) $(LDFLAGS) -c -o $@ $<

# Cleaning recipies
clean: clean-bin clean-obj

clean-bin:
	rm -rf $(BINDIR)

clean-obj:
	rm -rf $(OBJDIR)

.PHONY: all run clean clean-bin clean-obj bindir objdir
