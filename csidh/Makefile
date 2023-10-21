####  Makefile for compilation on Unix-like operative systems  ####

CC=clang
ifeq "$(CC)" "gcc"
    COMPILER=gcc
else ifeq "$(CC)" "clang"
    COMPILER=clang
endif

ARCHITECTURE=_ARM64_
USE_OPT_LEVEL=_FAST_
ifeq "$(ARCH)" "x86"
    ARCHITECTURE=_X86_
    USE_OPT_LEVEL=_GENERIC_
else ifeq "$(ARCH)" "ARM"
    ARCHITECTURE=_ARM_
    USE_OPT_LEVEL=_GENERIC_
    ARM_TARGET=YES
else ifeq "$(ARCH)" "ARM64"
    ARCHITECTURE=_ARM64_
    USE_OPT_LEVEL=_FAST_
    ARM_TARGET=YES
else ifeq "$(ARCH)" "M1"
    ARCHITECTURE=_ARM64_
    USE_OPT_LEVEL=_FAST_
endif

ifeq "$(OPT_LEVEL)" "GENERIC"
    USE_OPT_LEVEL=_GENERIC_
endif

ifeq "$(ARM_TARGET)" "YES"
    ARM_SETTING=-lrt # librt library linking
endif


BITS?=512

.PHONY: main bench clean

ifeq "$(USE_OPT_LEVEL)" "_GENERIC_"
    UINT_IMPL=uint.c
    FP_IMPL=fp.c
else ifeq "$(ARCH)" "x86"
    UINT_IMPL=$(wildcard p${BITS}/X86/uint.*)
    FP_IMPL=$(wildcard p${BITS}/X86/fp.*)
    FP_IMPL+=$(wildcard p${BITS}/X86/inv/*.c p${BITS}/X86/inv/*.s)
else ifeq "$(ARCHITECTURE)" "_ARM64_"
    UINT_IMPL=$(wildcard p${BITS}/ARM64/uint.*)
    FP_IMPL=$(wildcard p${BITS}/ARM64/fp.*)
    FP_IMPL+=$(wildcard p${BITS}/ARM64/inv/*.c p${BITS}/ARM64/inv/*.s)
endif


sources = p${BITS}/constants.c
sources += rng.c
sources += ${UINT_IMPL} ${FP_IMPL}
sources += mont.c
sources += csidh.c

includes = $(wildcard *.h p${BITS}/*.h)

main: libcsidh.so
	@cc \
		-I ./ \
		-I p${BITS}/ \
		-std=c99 -pedantic \
		-Wall -Wextra \
		-march=native -O3 \
		-DNDEBUG \
		./libcsidh.so \
		main.c \
		-o main

libcsidh.so: ${includes} ${sources}
	@cc \
		-shared \
		-fPIC -fvisibility=hidden \
		-I ./ \
		-I p${BITS}/ \
		-std=c99 -pedantic \
		-Wall -Wextra \
		-march=native -O3 \
		-DNDEBUG \
		$(sources) \
		-o libcsidh.so


debug: ${includes} ${sources} main.c
	cc \
		-I ./ \
		-I p${BITS}/ \
		-std=c99 -pedantic \
		-Wall -Wextra \
		-g \
		$(sources) \
		main.c \
		-o debug


bench: ${includes} ${sources} bench.c
	@cc \
		$(if ${BENCH_ITS},-DBENCH_ITS=${BENCH_ITS}) \
		$(if ${BENCH_VERBOSE},-DBENCH_VERBOSE=${BENCH_VERBOSE}) \
		-I ./ \
		-I p${BITS}/ \
		-std=c99 -pedantic \
		-Wall -Wextra \
		-march=native -O3 \
		-DNDEBUG \
		$(sources) \
		bench.c \
		-o bench


clean:
	@rm -f main debug bench libcsidh.so





