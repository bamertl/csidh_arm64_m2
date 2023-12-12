# Implementation for CSIDH in ARM64 for Apple M2 Chips


## BUILD MAIN
```bash
make ARCH=ARM64
make ARCH=GENERIC BITS=512
make ARCH=x86 BITS=512
make ARCH=ARM64 MUL_TYPE=MONTE_MUL
make ARCH=ARM64 MUL_TYPE=MONTE_REDUCTION_SUB_KARATSUBA
make ARCH=ARM64 MUL_TYPE=MONTE_REDUCTION_KARATSUBA
make ARCH=ARM64 MUL_TYPE=MONTE_REDUCTION_SCHOOLBOOK

./main
```
## Different Multiplication Variants
MUL_TYPE = MONTE_MUL | MONTE_REDUCTION_SUB_KARATSUBA | MONTE_REDUCTION_KARATSUBA | MONTE_REDUCTION_SCHOOLBOOK
### Monte_MUL
Normal Montgommery Multiplication
### MONTE_REDUCTION_SUB_KARATSUBA
Subtractive Karatsuba Multiplication and after that montgommery reduction
### MONTE_REDUCTION_KARATSUBA
Karatsuba Multiplication followed by montgomery reduction
### MONTE_REDUCTION_SCHOOLBOOK
Schoolbook multiplication followed by montgomery reduction 

## Bench Cycles
for benching the cycles use:
hint: you need to make the bench_lib library and add it to sources.
```
make clean; make ARCH=ARM64 MUL_TYPE=MONTE_MUL  bench_cycles; sudo ./bench_cycles
```

## Test
```bash
make test_uint
make ARCH=ARM64 MUL_TYPE=MONTE_MUL test_uint
make ARCH=ARM64 MUL_TYPE=MONTE_REDUCTION_SUB_KARATSUBA | MONTE_MUL | MONTE_REDUCTION_SCHOOLBOOK | MONTE_REDUCTION_KARATSUBA test_fp
make ARCH=ARM64 MUL_TYPE=MONTE_REDUCTION_SUB_KARATSUBA test_bigmul
```

## Bench pipelining
```bash

```

## Bench muls
```bash
make bench_muls ARCH=ARM64 MUL_TYPE=MONTE_MUL
make bench_muls ARCH=ARM64 MUL_TYPE=MONTE_REDUCTION_SUB_KARATSUBA
make bench_muls ARCH=ARM64 MUL_TYPE=MONTE_REDUCTION_KARATSUBA
make bench_muls ARCH=ARM64 MUL_TYPE=MONTE_REDUCTION_SCHOOLBOOK
./bench_muls
```

# 1024 Bit

## Autogens
```bash
./src/p1024/ARM64/autogen_uint
```



## Important Information for Apple M2
    Do not use x18 and x29 registers. 
[ARM64 Apple](https://developer.apple.com/documentation/xcode/writing-arm64-code-for-apple-platforms)



## Pass arguments to functions correctly

The stack pointer on Apple platforms follows the ARM64 standard ABI and requires 16-byte alignment. When passing arguments to functions, Apple platforms diverge from the ARM64 standard ABI in the following ways:

    Function arguments may consume slots on the stack that are not multiples of 8 bytes. If the total number of bytes for stack-based arguments is not a multiple of 8 bytes, insert padding on the stack to maintain the 8-byte alignment requirements.

    When passing an argument with 16-byte alignment in integer registers, Apple platforms allow the argument to start in an odd-numbered xN register. The standard ABI requires it to begin in an even-numbered xN register.

    The caller of a function is responsible for signing or zero-extending any argument with fewer than 32 bits. The standard ABI expects the callee to sign or zero-extend those arguments.

    Functions may ignore parameters that contain empty struct types. This behavior applies to the GNU extension in C and, where permitted by the language, in C++. The AArch64 documentation doesn’t address the issue of empty structures as parameters, but Apple chose this path for its implementation.

