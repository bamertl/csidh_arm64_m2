/* This header can be read by both C and C++ compilers */
#ifndef BENCHMARK_H
#define BENCHMARK_H
extern "C"
{
#include <stdint.h>
#define LIMBS 8

#define NUM_PRIMES 74

  typedef struct myuint
  {
    uint64_t c[LIMBS];
  } myuint;
  typedef struct private_key
  {
    int8_t e[NUM_PRIMES];
  } private_key;

  typedef struct public_key
  {
    myuint A; /* Montgomery coefficient: represents y^2 = x^3 + Ax^2 + x */
  } public_key;

  //extern void measure_csidh_private(void (*function)(void), private_key *priv);
  //extern void measure_csidh(void (*function)(void), public_key *out, public_key const *in, private_key const *priv);
}

#endif /*FRED_H*/