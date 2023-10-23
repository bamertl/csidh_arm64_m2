#include <stdlib.h>
#include <stdio.h>
#include "extras.h"
#include "uint.h"


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
    uint a = {{1,0,0,0,0,0, 0, 0}};
    uint b = {{0,0,0,0,0,0,1,0}};
    uint result = {0};
    uint_add3(&result, &a, &b);
    uint_print(&result);
}


int main(void)
{
    test_add();
    //print_random_number();
    return PASSED;
}
