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
    fp b = {{0}};
    fp b_old = {{0}};
    fp_cmov(&b, &a, 0);
    uintbig_assert_equal(&b.x, &b_old.x);
    fp_cmov(&b, &a, 1);
    uintbig_assert_equal(&b.x, &a_old.x);
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
}

void test_fp_mul(void){
    fp a = {{1,2,3,4,5,6,7,8}};
    fp b = {{1, 0, 0, 0, 0, 0, 0, 0}};
    fp c = {{0}};
    fp_mul3(&a, &b, &c);
    fp expected = {{0}};
    uintbig_assert_equal(&a.x, &expected.x);
    c = r_squared_mod_p;
    fp_mul3(&a, &b, &c);
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

int main(void){
    test_fp_cswap();
    test_fp_cmov();
    test_fp_add();
    test_fp_add3();
    test_fp_sub();
    test_fp_mul();
    test_mul_more();
}
