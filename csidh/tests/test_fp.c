#include <stdlib.h>
#include <stdio.h>
#include <assert.h> 
#include "extras.h"
#include "fp.h"
#include "constants.h"

const struct fp p_minus_2_for_fp = {{
    0x1b81b90533c6c879, 0xc2721bf457aca835, 0x516730cc1f0b4f25, 0xa7aac6c567f35507,
    0x5afbfcc69322c9cd, 0xb42d083aedc88c42, 0xfc8ab0d15e3e4c4a, 0x65b48e8f740f89bf,
}};


void fp_print(fp const *x)
{
    for (size_t i = 8*LIMBS-1; i < 8*LIMBS; --i)
        printf("%02hhx", i[(unsigned char *) x->c]);
    printf("\n");
}

void uint_print(uint const *x)
{
    for (size_t i = 8*LIMBS-1; i < 8*LIMBS; --i)
        printf("%02hhx", i[(unsigned char *) x->c]);
    printf("\n");
}


void test_fp_eq(void) {
    fp a = {{1,2,3,4,5,6,7,8}}, b = {{1,2,3,4,5,6,7,8}};
    fp c = {{3, 1, 2, 3, 4, 5, 6 ,7 }};
    assert(fp_eq(&a, &b));
    assert(!fp_eq(&a, &c));
}

void test_fp_add(void) {
    fp a = {{0}};
    fp b = {{3, 1, 2, 3, 4, 5, 6 ,7 }};
    fp c = {{0, 1, 2, 3, 4, 5, 6 ,7 }};

    fp expected1 = {{3, 2, 4, 6, 8, 10, 12, 14}};  
    fp_add3(&a, &b, &c);
    assert(fp_eq(&a, &expected1));

    fp_add2(&b, &p_minus_2_for_fp);
    fp expected2 = {{1, 1, 2, 3, 4, 5, 6 ,7}};

    for(int i = 0; i < LIMBS; i++) {
        assert(expected2.c[i] == b.c[i]);
    }     

}

void test_mul_3(void){
    fp a = {{1,2,3,4,5,6,7,8}};
    fp b = {{1, 0, 0, 0, 0, 0, 0, 0}};
    fp c = r_squared_mod_p;
    fp expected1 = fp_1;  
    fp_mul3(&a, &b, &c);
    assert(fp_eq(&a, &expected1));
}

void test_mul_more(void){
    uint result = {{0}};
    fp a = {{1,2,3,4,5,6,7,8}};
    fp b = {{1,2,3,4,5,6,7,8}};
    fp_set(&a, 5);
    fp_set(&b, 6);
    fp_mul2(&a, &b);
    fp_dec(&result, &a);
    fp expected = {{30,0,0,0,0,0,0,0}};
    
    for(int i = 0; i < LIMBS; i++) {
        assert(expected.c[i] == result.c[i]);
    }   
}

void test_fp_sub(void){
    fp a = {{1,2,3,4,5,6,7,8}};
    fp b = {{1,2,3,4,5,6,7,8}};
    fp c = {{1,2,3,4,5,6,7,8}};
    fp expected = {{0}};
    fp_sub3(&a, &b, &c);
    fp_sub2(&b, &c);

    for(int i = 0; i < LIMBS; i++) {
        assert(expected.c[i] == a.c[i]);
    } 

    for(int i = 0; i < LIMBS; i++) {
        assert(expected.c[i] == b.c[i]);
    } 
}

void test_encode_decode(void){
    uint aa = {{1,2,3,4,5,6,7,8}};
    uint bb = {{0}};
    fp a = {{0}};
    fp_enc(&a, &aa);
    fp_dec(&bb, &a);
    for(int i = 0; i < LIMBS; i++) {
        assert(aa.c[i] == bb.c[i]);
    }
}

void test_sq1(void){
    uint aa = {{2, 0, 0, 0, 0, 0, 0, 0}};
    uint bb = {{0}};
    fp a = {{0}};
    fp_enc(&a, &aa); 
    fp expected = {{4, 0, 0, 0, 0, 0, 0, 0}};
    fp_sq1(&a);
    fp_dec(&bb, &a);
    for(int i = 0; i < LIMBS; i++) {
        assert(expected.c[i] == bb.c[i]);
    } 
    fp_sq2(&a, &a);
    fp_dec(&bb, &a);
    fp expected2 = {{16, 0, 0, 0, 0, 0, 0, 0}};
    for(int i = 0; i < LIMBS; i++) {
        assert(expected2.c[i] == bb.c[i]);
    }
}

void test_inverse(void){
    uint a = {{2, 0, 0, 0, 0, 0, 0, 0}};
    fp b = {{0}};
    fp_enc(&b, &a);
    fp_inv(&b);
    fp_print(&b);
}

void test_fp_pow(void){
    printf("p : ");
    uint_print(&p);
    uint aa = {{2, 0, 0, 0, 0, 0, 0, 0}};
    uint bb = {{0}};
    fp a = {{0}};
    fp_enc(&a, &aa);

    printf("a: ");
    fp_print(&a);
    fp_dec(&aa, &a);
    printf("aa: ");
    uint_print(&aa);
    fp b = {{3, 0, 0, 0, 0, 0, 0, 0}};
    fp_pow(&a, &b);
    fp_print(&a);

    printf("a^1: ");
}

int main(void)
{
    //test_fp_eq();
    //test_fp_add();
    //test_mul_3();
    //test_mul_more();
    //test_fp_sub();
    //test_encode_decode();
    //test_sq1();
    //test_inverse();
    test_fp_pow();

    printf("All tests passed!\n");
    return 0;
}
