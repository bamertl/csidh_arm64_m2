####  Makefile for compilation on Unix-like operative systems  ####

BITS?=512

.PHONY: main bench clean tests


$(info CC: $(CC))
$(info BITS: $(BITS))

ifndef ARCH
    ARCH = GENERIC
endif

ifndef MUL_TYPE
	MUL_TYPE = MONTE_MUL
endif

ifeq "$(MUL_TYPE)" "MONTE_MUL"
	MUL_FILE = fp_mul_small.s
else ifeq "$(MUL_TYPE)" "MONTE_REDUCTION_SUB_KARATSUBA"
	MUL_FILE = fp_mul_big.s
endif

$(info ARCHITECTURE: $(ARCH))

ifeq "$(ARCH)" "GENERIC"
    UINT_IMPL=src/uint.c
    FP_IMPL=src/fp.c
else ifeq "$(ARCH)" "x86"
    UINT_IMPL=$(wildcard src/p${BITS}/X86/uint.*)
    FP_IMPL=$(wildcard src/p${BITS}/X86/fp.*)
    FP_IMPL+=$(wildcard src/p${BITS}/X86/inv/*.c src/p${BITS}/X86/inv/*.s)
else ifeq "$(ARCH)" "ARM64"
    UINT_IMPL=$(wildcard src/p${BITS}/ARM64/uint.*)
    FP_IMPL=$(wildcard src/p${BITS}/ARM64/fp.*)
    FP_IMPL+=$(wildcard  src/p${BITS}/ARM64/inv/*.s)
	FP_IMPL+= ./src/p${BITS}/ARM64/mul/${MUL_FILE}
endif


sources = ./src/p${BITS}/constants.c
sources += src/rng.c
sources += ${UINT_IMPL} ${FP_IMPL}
sources += src/mont.c
sources += src/csidh.c

includes = $(wildcard src/*.h src/p${BITS}/*.h)


TEST_SRC = $(wildcard tests/*.c)
TEST_OUT = $(TEST_SRC:.c=)

$(info SOURCES: $(sources))

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
		-I ./src \
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

test_fp: src/p${BITS}/params.h ${includes} ${sources} tests/test_fp.c
	cc -I ./src/ -I ./src/p${BITS}/ -I ./tests/ -std=c99 -pedantic -g $(sources) tests/test_fp.c -o tests/test_fp
	./tests/test_fp

test_bigmul: src/p${BITS}/params.h ${includes} ${sources} tests/test_bigmul.c
	@cc -I ./src/ -I ./src/p${BITS}/ -I ./tests/ -std=c99 -pedantic -g $(sources) tests/test_bigmul.c -o tests/test_bigmul
	./tests/test_bigmul

clean:
	@rm -f main debug bench libcsidh.so $(TEST_OUT)
	@rm -rf ./tests/test_uint.DSYM
	@rm -rf ./tests/test_fp.DSYM
	@rm -rf ./tests/test_bigmul.DSYM





