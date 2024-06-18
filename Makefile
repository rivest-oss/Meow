RM			= rm -f
MKDIR		= mkdir -p

CXX			= g++
CXXFLAGS	= -std=c++17 -Wall -Wextra -Wpedantic
LDFLAGS		= 

CPPCHECK	= cppcheck
CLANGXX		= clang++
VALGRIND	= valgrind

ifeq ($(origin DEBUG), environment)
	CXXFLAGS += -Og -g -DMEOW_DEBUG
else
	CXXFLAGS += -O2
endif

all: meow

clean:
	$(RM) ./out/meow

check:
	$(CPPCHECK) --language=c++ --std=c++17 ./src/main.c++
	$(CLANGXX) --analyze -Xclang -analyzer-output=html $(CXXFLAGS) \
		-o ./out/analysis \
		./src/main.c++ \
		$(LDFLAGS)

meow:
	$(MKDIR) ./out/
	$(CXX) $(CXXFLAGS) -o ./out/meow ./src/main.c++ $(LDFLAGS)

test:
	$(VALGRIND) \
		--leak-check=full \
		--show-leak-kinds=all \
		--track-origins=yes \
		./out/meow
