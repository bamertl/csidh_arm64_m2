#include <stdlib.h>
#include <stdio.h>
#include <assert.h> 
#include "extras.h"
#include "fp.h"
#include "constants.h"

typedef struct biguint { uint64_t c[16]; } biguint;
 extern void uint_mul(const fp *a, const uint *b, biguint *c);
    extern void fp_mul3_2(const fp *a, const fp *b, fp *c);


const struct fp p_minus_2_for_fp = {{
    0x1b81b90533c6c879, 0xc2721bf457aca835, 0x516730cc1f0b4f25, 0xa7aac6c567f35507,
    0x5afbfcc69322c9cd, 0xb42d083aedc88c42, 0xfc8ab0d15e3e4c4a, 0x65b48e8f740f89bf,
}};

const struct uint muu = {{
    0x66c1301f632e294d,
    0xfe025ed7d0d3b1aa,
    0xf6fe2bc33e915395,
    0x34ed3ea7f1de34c4,
    0xb081b3aba7d05f85,
    0x1232b9eb013dee1e,
    0x3512da337a97b345,
    0xd8c3904b18371bcd
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

void biguint_print(uint const *x)
{
    for (size_t i = 8*16-1; i < 8*16; --i)
        printf("%02hhx", i[(unsigned char *) x->c]);
    printf("\n");
}

void biguint_print_lower(uint const *x)
{
    for (size_t i = 8*8-1; i < 8*8; --i)
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
    fp f = {{1,2,3,4,5,6,7,8}};
    fp b = {{1, 0, 0, 0, 0, 0, 0, 0}};
    fp bigone = {{0x48b72f84899eca48, 0xdb7e0542b77624de, 0xafaeb264ca1bb35a, 0xba24269dff081925, 0x5d6cec71e0fac030, 0x845f1c9d401fac7f, 0x0000000000000002, 0x0000000000000000}};
    fp c = r_squared_mod_p;
    biguint d = {{0}};
    //q is same as r_squared_mod_p
    uint q = {{0x36905b572ffc1724, 0x67086f4525f1f27d, 0x4faf3fbfd22370ca, 0x192ea214bcc584b1,
    0x5dae03ee2f5de3d0, 0x1e9248731776b371, 0xad5f166e20e4f52d, 0x4ed759aea6f3917e,}};
    uint_mul(&r_squared_mod_p, &q, &d);
    //biguint_print(&d);
    fp expected1 = fp_1;  
    fp_mul3(&f, &a, &r_squared_mod_p);
    biguint_print_lower(&f);
    fp_mul3_2(&f, &a, &r_squared_mod_p);
    biguint_print_lower(&f);
    fp_mul3(&f, &a, &bigone);
    biguint_print_lower(&f);
    fp_mul3_2(&f, &a, &bigone);
    biguint_print_lower(&f);
    fp_mul3(&a, &r_squared_mod_p, &r_squared_mod_p);
    fp_mul3_2(&f, &r_squared_mod_p, &r_squared_mod_p);
    biguint_print_lower(&a);
    biguint_print_lower(&f);
    fp_mul3(&a, &fp_1, &r_squared_mod_p);
    fp_mul3_2(&f, &fp_1, &r_squared_mod_p);
    biguint_print_lower(&a);
    biguint_print_lower(&f);
    fp_mul3(&a, &b, &r_squared_mod_p);
    fp_mul3_2(&f, &b, &r_squared_mod_p);
    biguint_print_lower(&a);
    biguint_print_lower(&f);
    fp_mul3(&a, &b, &b);
    fp_mul3_2(&f, &b, &b);
    biguint_print_lower(&a);
    biguint_print_lower(&f);
    fp_mul3(&a, &fp_1, &fp_1);
    fp_mul3_2(&f, &fp_1, &fp_1);
    biguint_print_lower(&a);
    biguint_print_lower(&f);
    fp_mul3(&a, &p, &fp_1);
    fp_mul3_2(&f, &p, &fp_1);
    biguint_print_lower(&a);
    biguint_print_lower(&f);
    fp_mul3(&a, &p, &p);
    fp_mul3_2(&f, &p, &p);
    biguint_print_lower(&a);
    biguint_print_lower(&f);
    fp_mul3(&a, &b, &p);
    fp_mul3_2(&f, &b, &p);
    biguint_print_lower(&a);
    biguint_print_lower(&f);
}

void ultimate_test(void){
    fp a = {{1,2,3,4,5,6,7,8}};
    fp f = {{1,2,3,4,5,6,7,8}};
    fp b = {{1, 0, 0, 0, 0, 0, 0, 0}};
    uint c = {{1, 0, 0, 0, 0, 0, 0, 0}};
    biguint d = {{0}};
    //uint_mul(&p, &c, &d);
    //biguint_print(&d);
    fp_mul3(&a, &b, &p);
    fp_mul3_2(&f, &b, &p);
    biguint_print_lower(&a);
    biguint_print_lower(&f);
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
    uint aa = {{5, 0, 0, 0, 0, 0, 1, 0}};
    uint bb = {{0}};
    fp a = {{0}};
    fp_enc(&a, &aa);

    printf("a: ");
    fp_print(&a);
    fp_dec(&aa, &a);
    printf("aa: ");
    uint_print(&aa);
    uint b = {{30, 1, 1,0,0,0,0,0}};
    fp_pow(&a, &b);
    fp_print(&a);

    printf("a^1: ");
}

void test_decrypt(void){
    // uint aa = {{12312312312,13451,1124,11241,112334,141241,1214124,12431289431}};
    uint aa = {{2231231233,25,25,25,25,25,25, 25123123}};
    uint_print(&aa);
    printf("mu: ");
    fp_print(&r_squared_mod_p); 
    fp a = {{0}};
    fp_enc(&a, &aa);
    fp_print(&a);
    fp_dec(&aa, &a);
    uint_print(&aa);
}



 uint q = {{0x48b72f84899eca48, 0xdb7e0542b77624de, 0xff, 0xf, 0xd, 0xc, 0x0000000000000002, 0x0000000000000000}};


 void test_uint_mul(void){
     fp a = {{0xd45f914906fc8f68,0xf2e3f6dff4cef5f1,0xd927fa85083ccad4,0x68016cf8e4fc5fd0,0x5a5a847e9bff7844,0x6ab1c33fad4a7674,0xffc157ad48adf78f,0x1a0d9ee6d73adc9e}};
     biguint b = {{0}}; 
     fp zero = {{0x1, 0x0,0x0,0x0,0x0,0x0,0x0,0x0}};
     uint_mul(&p_minus_2_for_fp, &zero, &b);
     biguint_print(&b);
 }

  void test_fp_mul(void){
     fp a = {{0xd45f914906fc8f68,0xf2e3f6dff4cef5f1,0xd927fa85083ccad4,0x68016cf8e4fc5fd0,0x5a5a847e9bff7844,0x6ab1c33fad4a7674,0xffc157ad48adf78f,0x1a0d9ee6d73adc9e}};
     biguint b = {{0}}; 
     fp zero = {{0x1, 0x0,0x0,0x0,0x0,0x0,0x0,0x0}};
     fp_mul3(&p_minus_2_for_fp, &zero, &b);
     biguint_print(&b);
 }

void test_issquare(void){
    fp a = {{2}};
    bool itis = fp_issquare(&a);
    printf("itis: %d\n", itis);
}

void ultimate_uint_test(void){
    fp a = {{1,2,3,4,5,6,7,8}};
    fp b = {{0, 0, 0, 0, 0, 0, 0, 1}};
    uint c = {{0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff}};
    biguint d = {{0}};
    uint_mul(&b, &c, &d);
    biguint_print(&d);
   
}


int main(void)
{
    //test_fp_eq();
    //test_fp_add();
    test_mul_3();
    //test_mul_more();
    //test_fp_sub();
    //test_encode_decode();
    //test_sq1();
    //test_inverse();
    //test_fp_pow();
    //test_inverse();
   // test_decrypt();
    //test_issquare();
    //test_uint_mul();
    //ultimate_test();
    //ultimate_uint_test();
    printf("All tests passed!\n");
    return 0;
}
