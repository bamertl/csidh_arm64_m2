
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <assert.h>
#include <inttypes.h>
#include "rng.h"
#include "csidh.h"

// static __inline__ uint64_t rdtsc(void)
// {
//     uint32_t hi, lo;
//     __asm__ __volatile__ ("rdtsc" : "=a"(lo), "=d"(hi));
//     return lo | (uint64_t) hi << 32;
// }
static inline uint64_t rdtsc(void) {
    uint64_t ticks;
    __asm__ __volatile__("mrs %0, CNTVCT_EL0" : "=r" (ticks));
    return ticks;
}

/* defaults */

#ifndef BENCH_ITS
    #define BENCH_ITS 250
#endif

const unsigned long its = BENCH_ITS;


const size_t stacksz = 0x8000;  /* 32k */

/* csidh.c */
bool csidh(public_key *out, public_key const *in, private_key const *priv);

int cmp_uint64_t(const void *x, const void *y) { return * (uint64_t *) x - * (uint64_t *) y; }

extern uint64_t *fp_mul_counter;
extern uint64_t *fp_sq_counter;
extern uint64_t *fp_inv_counter;
extern uint64_t *fp_sqt_counter;
extern uint64_t *xmul_counters;
extern uint64_t *isog_counters;


double ticks_to_milliseconds(uint64_t ticks) {
    // Each tick represents 41.666664 nanoseconds
    const double tick_duration_ns = 41.666664;

    // Convert nanoseconds to milliseconds
    double tick_duration_ms = tick_duration_ns / 1000000.0;

    // Convert ticks to milliseconds
    return ticks * tick_duration_ms;
}


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
    return sum / (double) its;
}

int main(void)
{
    bool ret; (void) ret;
    clock_t t0, t1;
    uint64_t c0, c1;
    size_t bytes = 0;
    unsigned char *stack;

    uint64_t *ticks = calloc(its, sizeof(uint64_t)),
             *times = calloc(its, sizeof(uint64_t)),
             *mulss = calloc(its, sizeof(uint64_t)),
             *sqss = calloc(its, sizeof(uint64_t)),
             *invss = calloc(its, sizeof(uint64_t)),
             *sqtss = calloc(its, sizeof(uint64_t));

    private_key priv;
    public_key pub = base;

    // __asm__ __volatile__ ("mov %%rsp, %0" : "=m"(stack));
    __asm__ __volatile__ ("mov %0, sp" : "=r"(stack));
    stack -= stacksz;
    for (unsigned long i = 0; i < its; ++i) {
        if (its < 100 || i % (its / 100) == 0) {
            printf("%2lu%%", 100 * i / its);
            fflush(stdout);
            printf("\r\x1b[K");
        }

        csidh_private(&priv);

        /* spray stack */
        unsigned char canary;
        randombytes(&canary, 1);
        for (size_t j = 0; j < stacksz; ++j)
            stack[j] = canary;

        fp_mul_counter = &mulss[i];
        fp_sq_counter = &sqss[i];
        fp_inv_counter = &invss[i];
        fp_sqt_counter = &sqtss[i];

        // print the unsigned long long value of fp_mul_counter

        t0 = clock();   /* uses stack, but not too much */
        c0 = rdtsc();

        /**************************************/

        ret = csidh(&pub, &pub, &priv);
        assert(ret);

        /**************************************/

        c1 = rdtsc();
        t1 = clock();

        fp_mul_counter = NULL;
        fp_sq_counter = NULL;
        fp_inv_counter = NULL;
        fp_sqt_counter = NULL;

        ticks[i] = c1 - c0;
        times[i] = t1 - t0;

        /* check stack */
        if (*stack != canary) { /* make sure we sprayed enough */
            fprintf(stderr, "\x1b[31moops!\x1b[0m used more stack than expected.\n");
            exit(1);
        }
        for (size_t j = 0; j < stacksz - bytes; ++j)
            if (stack[j] != canary)
                bytes = stacksz - j;
    }

    float freq_ghz_clock = 1 / 41.666664;
    float freq_ghz_cpu = 2.41;


    printf("median clock cycles:  \x1b[34m%10.1lf (%.1lf*10^6)\x1b[0m\n", median(ticks) * freq_ghz_clock / freq_ghz_cpu, 1000. * median(ticks));
    printf("mean clock cycles:      %10.1lf (%.1lf*10^6)\n\n", mean(ticks) * freq_ghz_clock / freq_ghz_cpu, 1000. * mean(ticks));
    printf("median wall-clock time: \x1b[34m%6.3lf ms\x1b[0m\n", 41.666664 * median(ticks) / 1000000.0); // apple seems to tick every 41.666664 ns
    printf("mean wall-clock time:   %6.3lf ms\n\n", 41.666664 * mean(ticks) / 1000000.0);

    printf("maximum stack usage:    %6lu b\n\n", bytes);

    printf("median multiplications: %8" PRIu64 "\n", median(mulss));
    printf("mean multiplications:   %10.1lf\n", mean(mulss));

    printf("median squarings:       %8" PRIu64 "\n", median(sqss));
    printf("mean squarings:         %10.1lf\n", mean(sqss));

    printf("median inversions:      %8" PRIu64 "\n", median(invss));
    printf("mean inversions:        %10.1lf\n", mean(invss));

    printf("median square tests:    %8" PRIu64 "\n", median(sqtss));
    printf("mean square tests:      %10.1lf\n", mean(sqtss));

    printf("\n");
}

