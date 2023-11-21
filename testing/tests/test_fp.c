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



int main(void){
    test_fp_cswap();
    test_fp_cmov();
    test_fp_add();
}
