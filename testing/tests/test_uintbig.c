#include <stdio.h>
#include <assert.h> 
#include "helper.h"

void test_uintbig_set(void){
    uintbig a = {{0,1,1,1,1,1,1,1}};
    uintbig_set(&a, 0x1231245);
    uintbig expected = {{0x1231245,0,0,0,0,0,0,0}};
    uintbig_assert_equal(&expected, &a);
}

void test_uintbig_add(void){
    uintbig a = {{1,1,1,1,1,1, 1, 1}};
    uintbig b = {{0,1,1,1,1,1,1,1}};
    uintbig result = {{0}};
    uintbig expected = {{1,2,2,2,2,2,2,2}};
    uintbig_add3(&result, &a,&b);
    uintbig_assert_equal(&expected, &result);
}

void test_uintbig_bit(void){
    uintbig a = {{1,0,0,0,0,0,0,0}};
    bool result = uintbig_bit(&a, 0);
    bool result2 = uintbig_bit(&a, 1);
    assert(result == true);
    assert(result2 == false);
}

void test_uintbig_sub3(void){
    uintbig a = {{1,0,0,0,0,0,0,1}};
    uintbig b = {{4,0,0,0,0,0,0,5}};
    uintbig c = {{2,0,0,0,0,0,0,3}};
    uintbig_sub3(&a, &b, &c);
    uintbig expected = {{2,0,0,0,0,0,0,2}};
    uintbig_assert_equal(&expected, &a);
}

void test_uintbig_mul3_64(void){
    uintbig a = {{1,0,0,0,0,0,0,0}};
    uintbig b = {{2,0,0,0,0,0,0,0}};
    uint64_t c = 5;
    uintbig_mul3_64(&a, &b, c);
    uintbig expected = {{10,0,0,0,0,0,0,0}};
    uintbig_assert_equal(&expected, &a);
}

int main(void)
{
    test_uintbig_set();
    test_uintbig_bit();
    test_uintbig_add();
    test_uintbig_sub3();
    test_uintbig_mul3_64();

    return 0;
}
