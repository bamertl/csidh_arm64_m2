#ifndef HELPER_H
#define HELPER_H


#include "fp.h"
#include "uintbig.h"

void uintbig_print(uintbig const *x);                                          

void uintbig_assert_equal(uintbig const *expected, uintbig const *actual);

#endif
