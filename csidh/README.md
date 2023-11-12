make -> at the moment build it generic with p512
make ARCH=GENERIC BITS=512
make ARCH=x86 BITS=512
make ARCH=ARM64

MUL_TYPE = MONTE_MUL | MONTE_REDUCTION_SUB_KARATSUBA

## Test
make test_uint
make ARCH=ARM64 MUL=MONTE_MUL test_uint


lldb ...
br set -n name
register

## Montgomery Multiplication vs Montgomery Recution with Subtractive Karatsuba Multiplication
make ARCH=ARM64 MUL_TYPE=MONTE_MUL (standard)
make ARCH=ARM64 MUL_TYPE=MONTE_REDUCTION_SUB_KARATSUBA




## Pass arguments to functions correctly

The stack pointer on Apple platforms follows the ARM64 standard ABI and requires 16-byte alignment. When passing arguments to functions, Apple platforms diverge from the ARM64 standard ABI in the following ways:

    Function arguments may consume slots on the stack that are not multiples of 8 bytes. If the total number of bytes for stack-based arguments is not a multiple of 8 bytes, insert padding on the stack to maintain the 8-byte alignment requirements.

    When passing an argument with 16-byte alignment in integer registers, Apple platforms allow the argument to start in an odd-numbered xN register. The standard ABI requires it to begin in an even-numbered xN register.

    The caller of a function is responsible for signing or zero-extending any argument with fewer than 32 bits. The standard ABI expects the callee to sign or zero-extend those arguments.

    Functions may ignore parameters that contain empty struct types. This behavior applies to the GNU extension in C and, where permitted by the language, in C++. The AArch64 documentation doesn’t address the issue of empty structures as parameters, but Apple chose this path for its implementation.

