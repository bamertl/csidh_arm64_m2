
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <assert.h>
#include <inttypes.h>

#include "rng.h"
#include "csidh.h"
#include "benchmark.h"


/* defaults */

#ifndef BENCH_ITS
#define BENCH_ITS 1000
#endif

const unsigned long its = BENCH_ITS;

const size_t stacksz = 0x8000; /* 32k */

/* csidh.c */
bool csidh(public_key *out, public_key const *in, private_key const *priv);

int cmp_uint64_t(const void *x, const void *y) { return *(uint64_t *)x - *(uint64_t *)y; }

extern uint64_t *fp_mul_counter;
extern uint64_t *fp_sq_counter;
extern uint64_t *fp_inv_counter;
extern uint64_t *fp_sqt_counter;
extern uint64_t *xmul_counters;
extern uint64_t *isog_counters;

uint64_t median(uint64_t *vals)
{
    qsort(vals, its, sizeof(*vals), cmp_uint64_t);
    return vals[its / 2];
}

double mean(uint64_t *vals)
{
    uint64_t sum = 0;
    for (size_t i = 0; i < its; ++i)
        sum += vals[i];
    return sum / (double)its;
}

int main(void)
{
 
    private_key priv;
    public_key pub = base;

    printf("now testing private \n");
    measure_csidh_private(csidh_private, &priv);
    printf("\n");
    printf("now the key exchange \n");
    measure_csidh(csidh, &pub, &pub, &priv);
    printf("\n");
}
