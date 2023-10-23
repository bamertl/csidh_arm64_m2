#ifndef UINT_H
#define UINT_H

#include <stdbool.h>
#include <stdint.h>

#include "params.h"

extern const uint uint_0;
extern const uint uint_1;

bool uint_eq(uint const *x, uint const *y);

// sets the first element of x to y and the rest to 0
void uint_set(uint *x, uint64_t y);

// find position of first non-zero bit
size_t uint_len(uint const *x);

// Check if bit at position k is set
bool uint_bit(uint const *x, uint64_t k);

// x = y + z returns carry
bool uint_add3(uint *x, uint const *y, uint const *z); /* returns carry */

// x = y - z return borrow
bool uint_sub3(uint *x, uint const *y, uint const *z); /* returns borrow */

// x = y * z(1 limb) this is weird it ignores overflow (the last 64 bit of the result are simply not factored in ?????????????)
void uint_mul3_64(uint *x, uint const *y, uint64_t z);

void uint_random(uint *x, uint const *m);   /* uniform in the interval [0;m) */

#endif
