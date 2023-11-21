#include <stdlib.h>
#include <stdio.h>
#include <assert.h> 
#include "extras.h"
#include "uint.h"
#include "constants.h"


void uint_print(uint const *x)
{
    for (size_t i = 8*LIMBS-1; i < 8*LIMBS; --i)
        printf("%02hhx", i[(unsigned char *) x->c]);
}

void test_add(void){
    uint a = {{1,1,1,1,1,1, 1, 1}};
    uint b = {{0,1,1,1,1,1,1,1}};
    uint result = {{0}};
    uint expected = {{1,2,2,2,2,2,2,2}};
    uint_add3(&result, &a, &b);

    for(int i = 0; i < LIMBS; i++) {
        assert(expected.c[i] == result.c[i]);
    }

}

void test_len(void){
    size_t lenn = uint_len(&p_minus_2);
    assert(lenn == 511);
}

void test_eq(void){
    uint a = {{1,1,1,1,1,1,1,1}};
    uint b = {{1,2,3,4,5,6,7,8}};
    bool result = uint_eq(&a, &b); 
    bool result2 = uint_eq(&a, &a);
    assert(result == false);
    assert(result2 == true);
}

void test_uintbig_set(void){
    uint a = {{0,0,0,0,0,0,0,0}};
    uint_set(&a, 1);
    uint expected = {{1,0,0,0,0,0,0,0}};
    for(int i = 0; i < LIMBS; i++) {
        assert(expected.c[i] == a.c[i]);
    }
}

void test_uint_bit(void){
    uint a = {{1,0,0,0,0,0,0,0}};
    bool result = uint_bit(&a, 0);
    bool result2 = uint_bit(&a, 1);
    assert(result == true);
    assert(result2 == false);
}

void test_uint_mul3_64(void){
    uint a = {{1,0,0,0,0,0,0,0}};
    uint b = {{2,0,0,0,0,0,0,0}};
    uint64_t c = 5;
    uint_mul3_64(&a, &b, c);
    uint expected = {{10,0,0,0,0,0,0,0}};
    for(int i = 0; i < LIMBS; i++) {
        assert(expected.c[i] == a.c[i]);
    }
}

void test_uint_add3(void){
    uint a = {{1,0,0,0,0,0,0,1}};
    uint b = {{2,0,0,0,0,0,0,0}};
    uint c = {{3,0,0,0,0,0,0,0}};
    uint_add3(&a, &b, &c);
    uint expected = {{5,0,0,0,0,0,0,0}};
    for(int i = 0; i < LIMBS; i++) {
        assert(expected.c[i] == a.c[i]);
    }
}

void test_uint_sub3(void){
    uint a = {{1,0,0,0,0,0,0,1}};
    uint b = {{4,0,0,0,0,0,0,5}};
    uint c = {{2,0,0,0,0,0,0,3}};
    uint_sub3(&a, &b, &c);
    uint expected = {{2,0,0,0,0,0,0,2}};
    for(int i = 0; i < LIMBS; i++) {
        assert(expected.c[i] == a.c[i]);
    }
}

void test_uint_random(void){
    uint a = {{0,0,0,0,0,0,0,0}};
    uint b = {{0,0,0,0,0,0,1,0}};
    uint_random(&a, &b);
    uint_print(&a); 
}

int main(void)
{
    test_add();
    test_len();
    test_eq();
    test_uintbig_set();
    test_uint_bit();
    test_uint_mul3_64();
    test_uint_add3();
    test_uint_sub3();
    //test_uint_random();


    return PASSED;
}
