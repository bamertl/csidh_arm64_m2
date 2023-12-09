#include <stdio.h>
#include <assert.h> 
#include "helper.h"

extern void mul_vec(uintbig *a, uintbig *b);
void test_vec(void){
    uintbig a = {{1,2,3,4,5,6,7,8}};
    uintbig b = {{1, 2, 3, 4, 5, 6, 7, 8}};
    mul_vec(&a, &b);
    uintbig_print(&a);
    printf("test_vec entered\n");
}

int main(void){
    test_vec();
    return 0;
}

