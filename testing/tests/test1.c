#include <stdio.h>
#include <assert.h> 
#include "fp.h"
#include "uintbig.h"

void test_add(void){
    uintbig a = {{1,1,1,1,1,1, 1, 1}};
    uintbig b = {{0,1,1,1,1,1,1,1}};
    uintbig result = {{0}};
    uintbig expected = {{1,2,2,2,2,2,2,2}};
    printf("hi");
    printf("limbs: %d", UINTBIG_LIMBS);

    uintbig_add3(&result, &a, &b);

    for(int i = 0; i < UINTBIG_LIMBS; i++) {
        assert(expected.c[i] == result.c[i]);
    }

}


int main(void)
{
    printf("hi\n");
    test_add();
    //test_len();
    //test_eq();
    //test_uint_set();
    //test_uint_bit();
    //test_uint_mul3_64();
    //test_uint_add3();
    //test_uint_sub3();
    //test_uint_random();

    return 0;
}
