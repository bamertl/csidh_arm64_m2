SCC=gcc
CC=clang -O3 -Os -g -march=native -mtune=native -std=gnu99 -pedantic -Wall -Wextra -Wno-language-extension-token -fwrapv 

test: test_uintbig test_fp


libhighctidh_512.a: uintbig512_arm64.o fp512_arm64.o Makefile
	@ar cr libhighctidh_512.a uintbig512_arm64.o fp512_arm64.o
	@ranlib libhighctidh_512.a

uintbig512_arm64.o: pre_uintbig512 uintbig512_arm64.S ../high-ctidh-20210523/uintbig.h ../high-ctidh-20210523/uintbig_namespace.h Makefile
	@$(SCC) -DBITS=512 -D'NAMESPACEBITS(x)=_highctidh_512_##x' -D'NAMESPACEGENERIC(x)=_highctidh_##x' \
		-I ../high-ctidh-20210523/ \
		-c uintbig512_arm64.S

fp512_arm64.o: pre_fp512_arm64 fp512_arm64.S ../high-ctidh-20210523/fp.h ../high-ctidh-20210523/fp_namespace.h ../high-ctidh-20210523/uintbig.h ../high-ctidh-20210523/uintbig_namespace.h Makefile
	@$(SCC) -DBITS=512 -D'NAMESPACEBITS(x)=_highctidh_512_##x' -D'NAMESPACEGENERIC(x)=_highctidh_##x' \
		-I ../high-ctidh-20210523/ \
		-c fp512_arm64.S

pre_uintbig512:
	@echo "Generating uintbig512_arm64.S from autogen in ctidh/arm64 folder" 
	@./../high-ctidh-20210523/arm64/autogen_uintbig512
	@mv ../uintbig512_arm64.S ./uintbig512_arm64.S

pre_fp512_arm64:
	@echo "Generating fp512_arm64.S from autogen in ctidh/arm64 folder" 
	@./../high-ctidh-20210523/arm64/autogen_fp512
	@mv ../fp512_arm64.S ./fp512_arm64.S

test_uintbig: ./tests/test_uintbig.c \
libhighctidh_512.a ../high-ctidh-20210523/fp.h ./tests/helper.h ./tests/helper.c 
	@$(CC) -DBITS=512 -D'NAMESPACEBITS(x)=highctidh_512_##x' -D'NAMESPACEGENERIC(x)=highctidh_##x' \
		-I ./ \
		-I ./tests/ \
		-I ../high-ctidh-20210523/ \
		./tests/test_uintbig.c \
		./tests/helper.c \
		libhighctidh_512.a \
		-o tests/test_uintbig
	./tests/test_uintbig

test_fp: ./tests/test_fp.c \
libhighctidh_512.a ../high-ctidh-20210523/fp.h ./tests/helper.h ./tests/helper.c 
	@$(CC) -DBITS=512 -D'NAMESPACEBITS(x)=highctidh_512_##x' -D'NAMESPACEGENERIC(x)=highctidh_##x' \
		-I ./ \
		-I ./tests/ \
		-I ../high-ctidh-20210523/ \
		./tests/test_fp.c \
		./tests/helper.c \
		libhighctidh_512.a \
		-o tests/test_fp
	./tests/test_fp

clean:
	@rm -f *.o *.a ./*.S *.out
	@rm -rf *.dSYM tests/*.dSYM
	@rm -f tests/test_uintbig tests/test_fp