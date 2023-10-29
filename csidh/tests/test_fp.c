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

void test_fp_sub_3(void){
    fp a = {{1,2,3,4,5,6,7,8}};
    fp b = {{1,2,3,4,5,6,7,8}};
    fp c = {{1,2,3,4,5,6,7,8}};
    fp expected = {{0}};
    fp_sub3(&a, &b, &c);
    for(int i = 0; i < LIMBS; i++) {
        assert(expected.c[i] == a.c[i]);
    } 
}



int main(void)
{
    //test_fp_eq();
    //test_fp_add();
    //test_mul_3();
    //test_mul_more();
    test_fp_sub_3();

    printf("All tests passed!\n");
    return 0;
}
