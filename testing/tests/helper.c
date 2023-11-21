#include "helper.h"
#include <stdio.h>
#include <assert.h> 

void uintbig_print(uintbig const *x){
    for (size_t i = 8*UINTBIG_LIMBS-1; i < 8*UINTBIG_LIMBS; --i){
        printf("%02hhx", i[(unsigned char *) x->c]);
    }
    printf("\n");
}

void uintbig_assert_equal(uintbig const *expected, uintbig const *actual){
    for(int i = 0; i < UINTBIG_LIMBS; i++) {
        assert(expected->c[i] == actual->c[i]);
    }
}
