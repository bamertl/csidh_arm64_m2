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

void print_random_number(void){
    uint a = {{0,0,0,0,0,0, 0, 0}};
    uint b = {{0,0,0,0,0,0,1,0}};
    uint_random(&a, &b);
    printf("printing random number:");
    uint_print(&a);
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

int main(void)
{
    test_add();
    test_len();
    test_eq();
    //print_random_number();
    return PASSED;
}
