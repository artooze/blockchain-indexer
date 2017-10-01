UNAME := $(shell uname)


ifeq ($(UNAME), Linux)
BINFLAGS   ?= -I. -L. -L/usr/local/lib -I/usr/local/include
PLATFORMCXXFLAGS ?= -fPIC
INDEXERBIN ?= vtc_indexer
CC = g++
C = gcc
endif
ifeq ($(UNAME), MINGW32_NT-6.2)
BINFLAGS   ?= -I. -L. 
INDEXERBIN ?= vtc_indexer.exe
CC = g++
C = gcc
endif
ifeq ($(UNAME), Darwin)
BINFLAGS   ?= -I. -L. 
INDEXERBIN ?= vtc_indexer
CC = clang++
C = clang
endif
ifeq ($(UNAME), Darwin-Cross)
BINFLAGS   ?= -I. -L. 
INDEXERBIN ?= vtc_indexer
CC = o64-clang++
C = o64-clang
endif

PLATFORMCXXFLAGS += -g -Wall -std=c++14 -O2 -Wl,-E 

INDEXERSRC = src/main.cpp src/blockscanner.cpp
INDEXEROBJS = $(INDEXERSRC:.cpp=.cpp.o)

INDEXERLDFLAGS = $(BINFLAGS) -lck

CXXFLAGS = $(PLATFORMCXXFLAGS)

all: indexer

indexer: $(INDEXERSRC) $(INDEXERBIN) 

clean:
	$(RM) -r  $(INDEXEROBJS)

$(INDEXERBIN): $(INDEXEROBJS) 
	$(CC) $(INDEXEROBJS) -o $@ $(INDEXERLDFLAGS)

%.c.o: %.c
	$(C) $(PLATFORMCXXFLAGS) -O3 -c $< -o $@

%.cpp.o: %.cpp
	$(CC) $(CXXFLAGS) -c $< -o $@