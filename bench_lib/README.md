C++ libary to do cycle counts on M2

code from 
see also: https://lemire.me/blog/2023/03/ 
Usage: https://github.com/lemire/Code-used-on-Daniel-Lemire-s-blog/tree/master/2023/03/21 
```
make
copy libbenchmark_lib_csidh.so to your project (you need sudo afterwards)
```

Requirements:

- Apple ARM system or Linux.
- Complete compiler system pre-installed.


## How to use the ARM instruction counter

### Requirements
- [LLDB](https://lldb.llvm.org/) needs to be installed
- a running python version should be available

### How to run
1. go to the csidh or the ctidh folder
2. add the unrealistic stack subtraction and addition to recognize in the code to mark the end of your desired instruction command (at the end of the function you want to count)
```
sub sp, sp, #113 
add sp, sp, #113
```
3. create a debug version of the configuration you want to run & move it the bench_lib & cd into bench_lib
```
make clean; make debug ARCH=ARM64 MUL_TYPE=MONTE_REDUCTION_SCHOOLBOOK;
cp debug ../bench_lib
cd ../bench_lib
```
4. adjust the file name in [debugger_help.py](debugger_help.py) to a place and name as desired
5. start the lldb-debugger
```
lldb ./debug
```
6. in the lldb-debugger import the debugger_help tool
```
command script import debugger_help
```
7. set the breakpoint at the function you want (here: fp_mul3)
```
b -n fp_mul3
```
8. run the programm
```
run
```
9. call the write_commands function
```
write_commands
```
10. take the file and change the filenames in the [counter_tool.py](counter_tool.py) to the respective filename and call the counter_tool
```
python counter_tool.py
```
