#include <stdio.h>
#include <assert.h> 
#include "helper.h"


void test_fp_cswap(void){
    const uintbig a_remain = {{1,1,1,1,1,1,1,1}};
    fp a = {{1,1,1,1,1,1,1,1}};
    fp b = {{0}};
    const uintbig b_remain = {{0}};
    fp_cswap(&a, &b, 0);
    uintbig_assert_equal(&a_remain, &a.x);
    uintbig_assert_equal(&b_remain, &b.x);
    fp_cswap(&a, &b, 1);
    uintbig_assert_equal(&a_remain, &b.x);
    uintbig_assert_equal(&b_remain, &a.x);
}

void test_fp_cmov(void){
    const fp a = {{1,1,1,1,1,1,1,1}};
    const fp a_old = {{1,1,1,1,1,1,1,1}};
    fp b = {{1,2,3,4,5,6,7,8}};
    fp b_old = {{1,2,3,4,5,6,7,8}};
    fp_cmov(&b, &a, 0);
    uintbig_assert_equal(&b.x, &b_old.x);
    uintbig_assert_equal(&a.x, &a_old.x);
    fp_cmov(&b, &a, 1);
    uintbig_assert_equal(&a.x, &a_old.x);
    uintbig_assert_equal(&b.x, &a_old.x);
    printf("test_fp_cmov passed\n");
}

void test_fp_add(void){
    fp a = {{1,1,1,1,1,1,1,1}};
    fp b = {{3, 1, 2, 3, 4, 5, 6 ,7 }};
    fp c = {{0, 1, 2, 3, 4, 5, 6 ,7 }};

    fp expected1 = {{3, 2, 4, 6, 8, 10, 12, 14}};  
    fp_add2(&b, &c);
    uintbig_assert_equal(&b.x, &expected1.x);
    fp_add3(&a, &expected1, &c);
    fp expected2 = {{3, 3, 6, 9, 12, 15, 18, 21}};
    uintbig_assert_equal(&a.x, &expected2.x);
}

void test_fp_add3(void){
    fp a = {{1,2,3,4,5,6,7,8}};
    fp_add3(&a, &a, &fp_p);
    fp expected = {{1,2,3,4,5,6,7,8}};
    uintbig_assert_equal(&a.x, &expected.x);
}
void test_fp_sub(void){
    fp a = {{1,2,3,4,5,6,7,8}};
    fp b = {{1,2,3,4,5,6,7,8}};
    fp c = {{1,2,3,4,5,6,7,8}};
    fp expected = {{0}};
    fp_sub3(&a, &b, &c);
    fp_sub2(&b, &c);
    uintbig_assert_equal(&a.x, &expected.x);
    uintbig_assert_equal(&b.x, &expected.x);

    fp a2 = {{1,2,3,4,5,6,7,8}};
    fp b2= {{0x123611, 0x58998123,0x19827312, 0x1879237891, 0x198239871, 0x123789, 0x198273, 0x129831298 }};
    fp c2 = {{1,2,3,4,5,6,7,8}};
    fp_sub3(&c2, &a2, &b2);
    fp expected2 = {{0x1b81b90533b4926b, 0xc2721bf3ff132714,0x516730cc0588dc16, 0xa7aac6aceecfdc7a, 0x5afbfcc4faff3161, 0xb42d083aedb654bf, 0xfc8ab0d15e24c9de, 0x65b48e8e4a8c772f }};
    uintbig_assert_equal(&c2.x, &expected2.x);
}

void test_fp_mul(void){

    long long firstcount = fp_mulsq_count;
    fp a = {{1,2,3,4,5,6,7,8}};
    fp b = {{1, 0, 0, 0, 0, 0, 0, 0}};
    fp c = {{0}};
    fp_mul3(&a, &b, &c);
    fp expected = {{0}};
    uintbig_assert_equal(&a.x, &expected.x);
    c = r_squared_mod_p;
    fp_mul3(&a, &b, &c);
    long long secondcount = fp_mulsq_count;
    // assert secondcount == firstcount + 2;
    assert(secondcount == firstcount + 2);
    uintbig_assert_equal(&a.x, &fp_1.x);
}

void test_mul_more(void){
    fp one = {{1,0,0,0,0,0,0,0}};
    fp a = {{5,0,0,0,0,0,0,0}};
    fp b = {{6,0,0,0,0,0,0,0}};
    fp_mul2(&a, &r_squared_mod_p);
    fp_mul2(&b, &r_squared_mod_p);
    fp_mul2(&a, &b);
    fp_mul2(&a, &one);
    fp expected = {{30,0,0,0,0,0,0,0}};
    uintbig_assert_equal(&a.x, &expected.x);
}

void test_square(void){
    fp aa = {{0}};
    fp one = {{1,0,0,0,0,0,0,0}};
    fp a = {{5,0,0,0,0,0,0,0}};
    fp b = {{25,0,0,0,0,0,0,0}};
    fp_mul2(&a, &r_squared_mod_p);
    fp_sq2(&aa, &a);
    fp_mul2(&aa, &one);

    
    uintbig_assert_equal(&aa.x, &b.x);
}

void test_sqrt(void)
{

  for (long long loop = 0;loop < 1;++loop) {
    fp x;
    fp xneg;
    fp x2;
    fp x2neg;
    fp_random(&x);
    fp_sq2(&x2,&x);
    // x2 = x^2
    fp_neg2(&xneg,&x);
    // xneg = fp0 -x
    fp_neg2(&x2neg,&x2);
    long long resultx = fp_sqrt(&x);
    long long result_xneg = fp_sqrt(&xneg);
    long long resultx2 = fp_sqrt(&x2);
    long long resultx2neg = fp_sqrt(&x2neg);
    assert(resultx!= result_xneg);
    assert(resultx2);
    assert(!resultx2neg);
  }
}

void test_sqrt1(void){
    fp one = {{1,0,0,0,0,0,0,0}};
    fp b;
    fp a = {{3,0,0,0,0,0,0,0}};
    fp expected = {{3,0,0,0,0,0,0,0}};
    fp_mul2(&a, &r_squared_mod_p);
    fp_mul2(&a, &a);
    fp_mul3(&b, &a, &one);
    long long is_sqrt = fp_sqrt(&a); 
    fp_mul2(&a, &one);
    uintbig_assert_equal(&a.x, &expected.x);
    assert(is_sqrt == 1);
}

int main(void){
    test_fp_cswap();
    test_fp_cmov();
    test_fp_add();
    test_fp_add3();
    test_fp_sub();
    test_fp_mul();
    test_mul_more();
    test_square();
    test_sqrt();
    test_sqrt1();
}
