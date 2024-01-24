echo Welcome to the Test Bench for CSIDH
echo This script will run the benchmark for the different algorithms
echo

echo First I will test with a hardcoded inverse function given the prime for all the algorithms I have available
echo

make clean
make bench ARCH=ARM64 MUL_TYPE=MONTE_REDUCTION_KARATSUBA
echo Karatsuba Normal
./bench


make clean
make bench ARCH=ARM64 MUL_TYPE=MONTE_REDUCTION_SUB_KARATSUBA
echo Karatsuba Subtractive
./bench

make clean 
make bench ARCH=ARM64 MUL_TYPE=MONTE_MUL
echo Interleaved Radix
./bench

make clean
make bench ARCH=ARM64 MUL_TYPE=MONTE_REDUCTION_SCHOOLBOOK
echo Schoolbook
./bench

make clean
make bench
echo Generic
./bench

echo #############################################################
echo Happy? Now I will test with a dynamic inverse function given the prime for all the algorithms I have available
make clean
make bench ARCH=ARM64 MUL_TYPE=MONTE_REDUCTION_KARATSUBA INV_TYPE=CALCULATED
echo Karatsuba Normal
./bench


make clean
make bench ARCH=ARM64 MUL_TYPE=MONTE_REDUCTION_SUB_KARATSUBA INV_TYPE=CALCULATED
echo Karatsuba Subtractive
./bench

make clean 
make bench ARCH=ARM64 MUL_TYPE=MONTE_MUL INV_TYPE=CALCULATED
echo Interleaved Radix
./bench

make clean
make bench ARCH=ARM64 MUL_TYPE=MONTE_REDUCTION_SCHOOLBOOK INV_TYPE=CALCULATED
echo Schoolbook
./bench

make clean
make bench
echo Generic
./bench

echo #############################################################
echo Goodbye