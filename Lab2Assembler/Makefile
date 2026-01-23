

CXX      := g++
CXXFLAGS := -g -std=c++17 -O2 -Wall -Wextra -MMD
LDFLAGS :=  
TARGET   := main

SRCS := main.cpp \
		register.cpp \
		immediate.cpp \
		line_vec.cpp \
		stb_ds.cpp \
		jump.cpp \
		memory.cpp \
		mnemonic.cpp

OBJS := $(SRCS:.cpp=.o)

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) -o $@ $^

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(TARGET)