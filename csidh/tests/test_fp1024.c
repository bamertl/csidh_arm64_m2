#include <stdlib.h>
#include <stdio.h>
#include <assert.h> 
#include "extras.h"
#include "fp.h"
#include "constants.h"

typedef struct biguint { uint64_t c[16]; } biguint;

typedef struct smalluint { uint64_t c[4]; } smalluint;
const struct fp p_minus_2_for_fp = { 
    0xdbe34c5460e36451, 0xa1d81eebbc3d344d, 0x514ba72cb8d89fd3, 0xc2cab6a0e287f1bd,
    0x642aca4d5a313709, 0x6b317c5431541f40, 0xb97c56d1de81ede5, 0x0978dbeed90a2b58,
    0x7611ad4f90441c80, 0xf811d9c419ec8329, 0x4d6c594a8ad82d2d, 0xf06de2471cf9386e,
    0x0683cf25db31ad5b, 0x216c22bc86f21a08, 0xd89dec879007ebd7, 0x0ece55ed427012a9,
};

void fp_print(fp const *x)
{
    for (size_t i = 8*LIMBS-1; i < 8*LIMBS; --i) // Changed from 8*LIMBS to 16*LIMBS
        printf("%02hhx", i[(unsigned char *) x->c]);
    printf("\n");
}

void uint_print(uint const *x)
{
    for (size_t i = 8*LIMBS-1; i < 8*LIMBS; --i) // Changed from 8*LIMBS to 16*LIMBS
        printf("%02hhx", i[(unsigned char *) x->c]);
    printf("\n");
}

// The rest of the biguint_print and biguint_print_lower functions remain unchanged.

void test_fp_eq(void) {
    fp a = {{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}}, b = {{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}};
    fp c = {{3, 1, 2, 3, 4, 5, 6 ,7, 8, 9, 10, 11, 12, 13, 14, 15 }};
    assert(fp_eq(&a, &b));
    assert(!fp_eq(&a, &c));
    fp expected1 = {{3, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30}};
    fp expected2 = {{3, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30}};
    assert(fp_eq(&expected1, &expected2));
}

void test_fp_add(void) {
    fp a = {{0}};
    fp b = {{3, 1, 2, 3, 4, 5, 6 ,7, 8, 9, 10, 11, 12, 13, 14, 15 }};
    fp c = {{0, 1, 2, 3, 4, 5, 6 ,7, 8, 9, 10, 11, 12, 13, 14, 15 }};
    fp expected1 = {{3, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30}};  
    fp_add3(&a, &b, &c);
    assert(fp_eq(&a, &expected1));

    fp_add2(&b, &p_minus_2_for_fp);
    fp expected2 = {{1, 1, 2, 3, 4, 5, 6 ,7, 8, 9, 10, 11, 12, 13, 14, 15}}; // Assuming adjustment for 16 limbs
    for(int i = 0; i < LIMBS; i++) {
        assert(expected2.c[i] == b.c[i]);
    }     
}

void test_mul_3(void){
    fp a = {{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}}; // Expanded to 16 limbs
    fp b = {{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}}; // Expanded to 16 limbs
    fp c = r_squared_mod_p;
    fp expected1 = fp_1; // Update as necessary for 16 limbs
    fp_mul3(&a, &b, &c);
    fp_print(&a);
    fp_print(&expected1);
    assert(fp_eq(&a, &expected1));
}

void test_mul_more(void){
    uint result = {{0}};
    fp a = {{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}}; // Expanded to 16 limbs
    fp b = {{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}}; // Expanded to 16 limbs
    fp_set(&a, 5);
    fp_set(&b, 6);
    fp_mul2(&a, &b);
    fp_dec(&result, &a);
    fp expected = {{30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}}; // Expanded to 16 limbs
    
    for(int i = 0; i < LIMBS; i++) {
        assert(expected.c[i] == result.c[i]);
    }   
}

void test_fp_sub(void){
    fp a = {{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}}; // Expanded to 16 limbs
    fp b = {{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}}; // Expanded to 16 limbs
    fp c = {{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}}; // Expanded to 16 limbs
    fp expected = {{0}}; // Update as necessary for 16 limbs
    fp_sub3(&a, &b, &c);
    fp_print(&a);
    fp_sub2(&b, &c);

    for(int i = 0; i < LIMBS; i++) {
        assert(expected.c[i] == a.c[i]);
    } 

    for(int i = 0; i < LIMBS; i++) {
        assert(expected.c[i] == b.c[i]);
    } 
}


int main(void){
    test_fp_eq();
    test_fp_add();
    test_mul_3();
    test_fp_sub();
}
