# Simple Makefile for a C++ project (WSL / g++)
# Builds all .cpp files in the current directory into an executable named "main"

CXX      := g++
CXXFLAGS := -g -std=c++17 -O2 -Wall -Wextra -MMD
LDFLAGS :=  
TARGET   := main

SRCS := $(wildcard *.cpp)
OBJS := $(SRCS:.cpp=.o)

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) -o $@ $^

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(TARGET)