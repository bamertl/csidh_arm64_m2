make clean
make bench_muls ARCH=ARM64 MUL_TYPE=MONTE_REDUCTION_KARATSUBA
echo Karatsuba Normal
./bench_muls


make clean
make bench_muls ARCH=ARM64 MUL_TYPE=MONTE_REDUCTION_SUB_KARATSUBA
echo Karatsuba Subtractive
./bench_muls

make clean 
make bench_muls ARCH=ARM64 MUL_TYPE=MONTE_MUL
echo Interleaved Radix
./bench_muls

make clean
make bench_muls ARCH=ARM64 MUL_TYPE=MONTE_REDUCTION_SCHOOLBOOK
echo Schoolbook
./bench_muls