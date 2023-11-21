#include <stdio.h>
#include <assert.h> 
#include "helper.h"

void test_uint_set(void){
    uintbig a = {{0,1,1,1,1,1,1,1}};
    uintbig_set(&a, 0x1231245);
    uintbig expected = {{0x1231245,0,0,0,0,0,0,0}};
    assert_equal(&expected, &a);
}

void test_add(void){
    uintbig a = {{1,1,1,1,1,1, 1, 1}};
    uintbig b = {{0,1,1,1,1,1,1,1}};
    uintbig result = {{0}};
    uintbig expected = {{1,2,2,2,2,2,2,2}};
    printf("limbs: %d", UINTBIG_LIMBS);
    uintbig_add3(&result, &a, &b);

    for(int i = 0; i < UINTBIG_LIMBS; i++) {
        assert(expected.c[i] == result.c[i]);
    }
}

int main(void)
{
    test_uint_set();
    //test_add();
    //test_len();
    //test_eq();
    //test_uint_bit();
    //test_uint_mul3_64();
    //test_uint_add3();
    //test_uint_sub3();
    //test_uint_random();

    return 0;
}
