#include <stdio.h>
#include <assert.h> 
#include "helper.h"

extern int mul_vec(int a, int b);
void test_vec(void){
    int a = 1;
    int b = 2;
    int c = mul_vec(a, b);
    printf("c = %d\n", c);
    printf("test_vec entered\n");
}

int main(void){
    test_vec();
    return 0;
}

