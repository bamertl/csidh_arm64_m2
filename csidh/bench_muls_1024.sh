make clean 
make bench_muls ARCH=ARM64 MUL_TYPE=MONTE_MUL BITS=1024
echo Interleaved Radix
./bench_muls

make clean
make bench_muls BITS=1024
echo Generic
./bench_muls
