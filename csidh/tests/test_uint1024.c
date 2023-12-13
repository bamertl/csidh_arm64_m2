#include <stdlib.h>
#include <stdio.h>
#include <assert.h> 
#include "extras.h"
#include "uint.h"
#include "constants.h"

void uint_print(uint const *x)
{
    for (size_t i = 8*LIMBS-1; i < 8*LIMBS; --i) // Changed from 8 to 16
        printf("%02hhx", i[(unsigned char *) x->c]);
    printf("\n");
}

void test_add(void){
    uint a = {{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}}; // Doubled the size
    uint b = {{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}}; // Doubled the size
    uint result = {{0}};
    uint expected = {{1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2}}; // Doubled the size
    uint_add3(&result, &a, &b);

    for(int i = 0; i < LIMBS; i++) {
        assert(expected.c[i] == result.c[i]);
    }
}

void test_fp_add(void) {
    uint a = {{0}};
    uint b = {{3, 1, 2, 3, 4, 5, 6 ,7, 8, 9, 10, 11, 12, 13, 14, 15 }};
    uint c = {{0, 1, 2, 3, 4, 5, 6 ,7, 8, 9, 10, 11, 12, 13, 14, 15 }};

    uint expected1 = {{3, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30}};  
    uint_add3(&a, &b, &c);
       for(int i = 0; i < LIMBS; i++) {
        assert(expected1.c[i] == a.c[i]);
    }

}


void test_len(void){
    size_t lenn = uint_len(&p_minus_2);
    assert(lenn == 1020); // Changed from 511 to 1023
}

void test_eq(void){
    uint a = {{1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}}; // Doubled the size
    uint b = {{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}}; // Doubled the size and updated values

    bool result = uint_eq(&a, &b); 
    bool result2 = uint_eq(&a, &a);
    assert(result == false);
    assert(result2 == true);
}

void test_uintbig_set(void){
    uint a = {{0,0,0,0,0,0,0,0,0,1,0,2,0,4,0,0}}; // Doubled the size
    uint_set(&a, 5);
    uint expected = {{5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}}; // Doubled the size
    for(int i = 0; i < LIMBS; i++) {
        assert(expected.c[i] == a.c[i]);
    }
}

void test_uint_bit(void){
    uint a = {{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}}; // Doubled the size
    bool result = uint_bit(&a, 0);
    bool result2 = uint_bit(&a, 1);
    assert(result == true);
    assert(result2 == false);
}

void test_uint_mul3_64(void){
    uint a = {{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}}; // Doubled the size
    uint b = {{2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}}; // Doubled the size
    uint64_t c = 5;
    uint_mul3_64(&a, &b, c);
    uint expected = {{10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}}; // Doubled the size
    for(int i = 0; i < LIMBS; i++) {
        assert(expected.c[i] == a.c[i]);
    }
}

void test_uint_sub3(void){
    uint a = {{1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0}}; // Expanded to 16 limbs
    uint b = {{4,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0}}; // Expanded to 16 limbs
    uint c = {{2,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0}}; // Expanded to 16 limbs
    uint_sub3(&a, &b, &c);
    uint expected = {{2,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0}}; // Expanded to 16 limbs
    for(int i = 0; i < LIMBS; i++) {
        assert(expected.c[i] == a.c[i]);
    }

    uint aa = {{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}}; // Expanded to 16 limbs
    uint ba = {{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}}; // Expanded to 16 limbs
    uint result = {{1}};
    uint_sub3(&result, &aa, &ba);

    uint expected2 = {{0}}; // Expanded to 16 limbs
    for(int i = 0; i < LIMBS; i++) {
        assert(expected2.c[i] == result.c[i]);
    }


}

void test_uint_random(void){
    uint a = {{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}}; // Expanded to 16 limbs
    uint b = {{0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0}}; // Expanded to 16 limbs
    uint_random(&a, &b);
}

int main(void)
{
    test_add();
    test_len();
    test_eq();
    test_uintbig_set();
    test_uint_bit();
    test_uint_mul3_64();
    test_uint_sub3();
    test_fp_add();
    //test_uint_random();


    return PASSED;
}
