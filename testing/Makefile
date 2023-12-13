SCC=gcc
CC=clang -arch arm64 -O3 -Os -g  -mtune=native -std=gnu99 -pedantic -Wall -Wextra -Wno-language-extension-token -fwrapv 
BITS?=512
ifndef MUL_TYPE
	MUL_TYPE = MONTE_MUL
endif

MUL_FOLDER = ../high-ctidh-20210523/arm64/p${BITS}/mul/
ifeq "$(MUL_TYPE)" "MONTE_MUL"
	MUL_FILE =$(MUL_FOLDER)fp_mul_interleaved.s
else ifeq "$(MUL_TYPE)" "MONTE_REDUCTION_SUB_KARATSUBA"
	MUL_FILE =$(MUL_FOLDER)fp_mul_karatsuba_subtractive.s
else ifeq "$(MUL_TYPE)" "MONTE_REDUCTION_KARATSUBA"
	MUL_FILE =$(MUL_FOLDER)fp_mul_karatsuba_normal.s
else ifeq "$(MUL_TYPE)" "MONTE_REDUCTION_SCHOOLBOOK"
	MUL_FILE =$(MUL_FOLDER)fp_mul_schoolbook.s
endif

$(info Taking MUL: $(MUL_FILE))

test: test_mul_vec test_uintbig test_fp



libhighctidh_512.a: uintbig512_arm64.o fp512_mul_file.o fp_sqrt512.o fp512_arm64.o mul_vec512.o Makefile
	@ar cr libhighctidh_512.a fp512_mul_file.o uintbig512_arm64.o fp512_arm64.o fp_sqrt512.o mul_vec512.o
	@ranlib libhighctidh_512.a

uintbig512_arm64.o: pre_uintbig512 ../high-ctidh-20210523/uintbig512_arm64.S ../high-ctidh-20210523/uintbig.h ../high-ctidh-20210523/uintbig_namespace.h Makefile
	@$(SCC) -DBITS=512 -D'NAMESPACEBITS(x)=_highctidh_512_##x' -D'NAMESPACEGENERIC(x)=_highctidh_##x' \
		-I ../high-ctidh-20210523/ \
		-c ../high-ctidh-20210523/uintbig512_arm64.S

fp512_arm64.o: pre_fp512_arm64 ../high-ctidh-20210523/fp512_arm64.S ../high-ctidh-20210523/fp.h ../high-ctidh-20210523/fp_namespace.h ../high-ctidh-20210523/uintbig.h ../high-ctidh-20210523/uintbig_namespace.h Makefile
	@$(SCC) -DBITS=512 -D'NAMESPACEBITS(x)=_highctidh_512_##x' -D'NAMESPACEGENERIC(x)=_highctidh_##x' \
		-I ../high-ctidh-20210523/ \
		-c ../high-ctidh-20210523/fp512_arm64.S

fp512_mul_file.o: ${MUL_FILE} ../high-ctidh-20210523/fp512_arm64.S ../high-ctidh-20210523/fp.h ../high-ctidh-20210523/fp_namespace.h ../high-ctidh-20210523/uintbig.h ../high-ctidh-20210523/uintbig_namespace.h Makefile
	$(SCC) -DBITS=512 -D'NAMESPACEBITS(x)=_highctidh_512_##x' -D'NAMESPACEGENERIC(x)=_highctidh_##x' \
		-I ../high-ctidh-20210523/ \
		-c ${MUL_FILE} -o fp512_mul_file.o

fp_sqrt512.o: ../high-ctidh-20210523/fp_sqrt512.c ../high-ctidh-20210523/fp.h ../high-ctidh-20210523/uintbig.h ../high-ctidh-20210523/uintbig_namespace.h ../high-ctidh-20210523/fp_namespace.h ../high-ctidh-20210523/randombytes.h ../high-ctidh-20210523/crypto_declassify.h Makefile
	$(CC) -DBITS=512 -D'NAMESPACEBITS(x)=highctidh_512_##x' -D'NAMESPACEGENERIC(x)=highctidh_##x' \
		-c ../high-ctidh-20210523/fp_sqrt512.c

mul_vec512.o: pre_mul_vec512 ../high-ctidh-20210523/mul_vec512.S ../high-ctidh-20210523/fp.h ../high-ctidh-20210523/fp_namespace.h ../high-ctidh-20210523/uintbig.h ../high-ctidh-20210523/uintbig_namespace.h Makefile
	@$(SCC) -DBITS=512 -D'NAMESPACEBITS(x)=_highctidh_512_##x' -D'NAMESPACEGENERIC(x)=_highctidh_##x' \
		-I ../high-ctidh-20210523/ \
		-c ../high-ctidh-20210523/mul_vec512.S

pre_uintbig512:
	@echo "Generating uintbig512_arm64.S from autogen in ctidh/arm64 folder" 
	@./../high-ctidh-20210523/arm64/autogen_uintbig512
	@mv ../uintbig512_arm64.S ../high-ctidh-20210523/uintbig512_arm64.S

pre_fp512_arm64:
	@echo "Generating fp512_arm64.S from autogen in ctidh/arm64 folder" 
	@./../high-ctidh-20210523/arm64/autogen_fp512
	@mv ../fp512_arm64.S ../high-ctidh-20210523/fp512_arm64.S

pre_mul_vec512:
	@echo "Generating mul_vec512.S from autogen in ctidh/arm64 folder" 
	@./../high-ctidh-20210523/arm64/autogen_mul_vec
	@mv ../mul_vec512.S ../high-ctidh-20210523/mul_vec512.S

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
libhighctidh_512.a libtest.a ../high-ctidh-20210523/fp.h ./tests/helper.h ./tests/helper.c 
	@$(CC) -DBITS=512 -D'NAMESPACEBITS(x)=highctidh_512_##x' -D'NAMESPACEGENERIC(x)=highctidh_##x' \
		-I ./ \
		-I ./tests/ \
		-I ../high-ctidh-20210523/ \
		./tests/test_fp.c \
		./tests/helper.c \
		libhighctidh_512.a \
		libtest.a \
		-o tests/test_fp
	./tests/test_fp

test_mul_vec: ./tests/test_mul_vec.c \
libhighctidh_512.a ../high-ctidh-20210523/fp.h ./tests/helper.h ./tests/helper.c 
	@$(CC) -DBITS=512 -D'NAMESPACEBITS(x)=highctidh_512_##x' -D'NAMESPACEGENERIC(x)=highctidh_##x' \
		-I ./ \
		-I ./tests/ \
		-I ../high-ctidh-20210523/ \
		./tests/test_mul_vec.c \
		./tests/helper.c \
		libhighctidh_512.a \
		-o tests/test_mul_vec
	./tests/test_mul_vec


libtest.a: crypto_classify.o crypto_declassify.o randombytes.o Makefile
	ar cr libtest.a crypto_classify.o crypto_declassify.o randombytes.o 
	ranlib libtest.a

randombytes.o: ../high-ctidh-20210523/randombytes.c ../high-ctidh-20210523/randombytes.h Makefile
	$(CC) -D'NAMESPACEGENERIC(x)=highctidh_##x' \
		-c ../high-ctidh-20210523/randombytes.c

crypto_declassify.o: ../high-ctidh-20210523/crypto_declassify.c ../high-ctidh-20210523/crypto_declassify.h Makefile
	$(CC) -D'NAMESPACEGENERIC(x)=highctidh_##x' \
		-c ../high-ctidh-20210523/crypto_declassify.c

crypto_classify.o: ../high-ctidh-20210523/crypto_classify.c ../high-ctidh-20210523/crypto_classify.h Makefile
	$(CC) -D'NAMESPACEGENERIC(x)=highctidh_##x' \
		-c ../high-ctidh-20210523/crypto_classify.c

clean:
	@rm -f *.o *.a ./*.S *.out
	@rm -rf *.dSYM tests/*.dSYM
	@rm -f tests/test_uintbig tests/test_fp tests/test_mul_vec tests/test_uint1024