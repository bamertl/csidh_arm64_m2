echo Welcome to the Test Bench for CSIDH
echo This script will run the benchmark for the different algorithms
echo

echo First I will test with 512 bits
echo

make clean
make bench_custom ARCH=ARM64 MUL_TYPE=MONTE_REDUCTION_KARATSUBA
echo Karatsuba Normal
./bench_custom


make clean
make bench_custom ARCH=ARM64 MUL_TYPE=MONTE_REDUCTION_SUB_KARATSUBA
echo Karatsuba Subtractive
./bench_custom

make clean 
make bench_custom ARCH=ARM64 MUL_TYPE=MONTE_MUL
echo Interleaved Radix
./bench_custom

make clean
make bench_custom ARCH=ARM64 MUL_TYPE=MONTE_REDUCTION_SCHOOLBOOK
echo Schoolbook
./bench_custom

make clean
make bench_custom
echo Generic
./bench_custom

echo #############################################################
echo Happy? Now I will test with 1024

make clean 
make bench_custom ARCH=ARM64 MUL_TYPE=MONTE_MUL BITS=1024
echo Interleaved Radix
./bench_custom

make clean
make bench_custom BITS=1024
echo Generic
./bench_custom

echo #############################################################
echo Goodbye