####  Makefile for compilation on Unix-like operative systems  ####

BITS?=512

.PHONY: main bench clean tests


$(info CC: $(CC))
$(info BITS: $(BITS))

ifndef ARCH
    ARCH = GENERIC
endif

$(info ARCHITECTURE: $(ARCH))

ifeq "$(ARCH)" "GENERIC"
    UINT_IMPL=src/uint.c
    FP_IMPL=src/fp.c
else ifeq "$(ARCH)" "x86"
    UINT_IMPL=$(wildcard src/p${BITS}/X86/uint.*)
    FP_IMPL=$(wildcard src/p${BITS}/X86/fp.*)
    FP_IMPL+=$(wildcard src/p${BITS}/X86/inv/*.c p${BITS}/X86/inv/*.s)
else ifeq "$(ARCH)" "ARM64"
    UINT_IMPL=$(wildcard src/p${BITS}/ARM64/uint.*)
    FP_IMPL=$(wildcard src/p${BITS}/ARM64/fp.*)
    FP_IMPL+=$(wildcard src/p${BITS}/ARM64/inv/*.c p${BITS}/ARM64/inv/*.s)
endif


sources = ./src/p${BITS}/constants.c
sources += src/rng.c
sources += ${UINT_IMPL} ${FP_IMPL}
sources += src/mont.c
sources += src/csidh.c

includes = $(wildcard src/*.h src/p${BITS}/*.h)


TEST_SRC = $(wildcard tests/*.c)
TEST_OUT = $(TEST_SRC:.c=)


main: ${includes} ${sources} src/main.c
	@cc \
		-I ./src/ \
		-I src/p${BITS}/ \
		-std=c99 -pedantic \
		-Wall -Wextra \
		-march=native -O3 \
		-DNDEBUG \
		$(sources) \
		src/main.c \
		-o main

debug: ${includes} ${sources} src/main.c
	@cc \
		-I ./src/ \
		-I src/p${BITS}/ \
		-std=c99 -pedantic \
		-Wall -Wextra \
		-g \
		$(sources) \
		src/main.c \
		-o debug

bench: ${includes} ${sources} src/bench.c
	@cc \
		$(if ${BENCH_ITS},-DBENCH_ITS=${BENCH_ITS}) \
		$(if ${BENCH_VERBOSE},-DBENCH_VERBOSE=${BENCH_VERBOSE}) \
		-I ./ \
		-I src/p${BITS}/ \
		-std=c99 -pedantic \
		-Wall -Wextra \
		-march=native -O3 \
		-DNDEBUG \
		$(sources) \
		src/bench.c \
		-o bench


test_uint: src/p${BITS}/params.h ${includes} ${sources} tests/test_uint.c
	cc -I ./src/ -I ./src/p${BITS}/ -I ./tests/ -std=c99 -pedantic -g $(sources) tests/test_uint.c -o tests/test_uint
	./tests/test_uint

clean:
	@rm -f main debug bench libcsidh.so $(TEST_OUT)
	@rm -rf ./tests/test_uint.DSYM





