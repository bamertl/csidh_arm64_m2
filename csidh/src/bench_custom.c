
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <assert.h>
#include <inttypes.h>
#include "rng.h"
#include "csidh.h"


// gets current time in ns
static inline unsigned long long get_time_ns(void) {
    struct timespec time;
    clock_gettime(CLOCK_REALTIME, &time);
    return (int64_t)(time.tv_sec*1e9 + time.tv_nsec);
}

/* defaults */

#ifndef BENCH_ITS
    #define BENCH_ITS 100
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
extern uint64_t *fp_addsub_counter;

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
    uint64_t t0_private, t1_private, t0_csidh, t1_csidh;
    size_t bytes = 0;
    unsigned char *stack;

    uint64_t *times_private = calloc(its, sizeof(uint64_t)),
             *times_csidh = calloc(its, sizeof(uint64_t)),
             *mulss = calloc(its, sizeof(uint64_t)),
             *sqss = calloc(its, sizeof(uint64_t)),
             *invss = calloc(its, sizeof(uint64_t)),
             *sqtss = calloc(its, sizeof(uint64_t)),
             *addsubs = calloc(its, sizeof(uint64_t));

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

        t0_private = get_time_ns();
        csidh_private(&priv);

        t1_private = get_time_ns();

        times_private[i] = t1_private - t0_private;

        /* spray stack */
        unsigned char canary;
        randombytes(&canary, 1);
        for (size_t j = 0; j < stacksz; ++j)
            stack[j] = canary;

        fp_mul_counter = &mulss[i];
        fp_sq_counter = &sqss[i];
        fp_inv_counter = &invss[i];
        fp_sqt_counter = &sqtss[i];
        fp_addsub_counter = &addsubs[i];


        // print the unsigned long long value of fp_mul_counter

        t0_csidh = get_time_ns();
        /**************************************/

        ret = csidh(&pub, &pub, &priv);
        assert(ret);

        /**************************************/

        t1_csidh = get_time_ns();

        times_csidh[i] = t1_csidh - t0_csidh;

        fp_mul_counter = NULL;
        fp_sq_counter = NULL;
        fp_inv_counter = NULL;
        fp_sqt_counter = NULL;
        fp_addsub_counter = NULL;

        /* check stack */
        if (*stack != canary) { /* make sure we sprayed enough */
            fprintf(stderr, "\x1b[31moops!\x1b[0m used more stack than expected.\n");
            exit(1);
        }
        for (size_t j = 0; j < stacksz - bytes; ++j)
            if (stack[j] != canary)
                bytes = stacksz - j;
    }

    printf("median private keygen:  %8" PRIu64 " ns\n", median(times_private));
    printf("mean private keygen:    %10.1lf ns\n", mean(times_private));
    printf("mean private keygen in ms: %8.6lf ms\n", (double)mean(times_private) / 1e6);


    printf("median csidh:           %8" PRIu64 " ns\n", median(times_csidh));
    printf("mean csidh:             %10.1lf ns\n", mean(times_csidh));
    printf("mean csidh in ms:     %8.4lf ms\n", mean(times_csidh) / 1e6);

    printf("maximum stack usage:    %6lu b\n\n", bytes);

    printf("median multiplications: %8" PRIu64 "\n", median(mulss));
    printf("mean multiplications:   %10.1lf\n", mean(mulss));

    printf("median squarings:       %8" PRIu64 "\n", median(sqss));
    printf("mean squarings:         %10.1lf\n", mean(sqss));

    printf("mean additions/subs:    %10.1lf\n", mean(addsubs));
    printf("median additions/subs:  %8" PRIu64 "\n", median(addsubs));

    printf("median inversions:      %8" PRIu64 "\n", median(invss));
    printf("mean inversions:        %10.1lf\n", mean(invss));

    printf("median square tests:    %8" PRIu64 "\n", median(sqtss));
    printf("mean square tests:      %10.1lf\n", mean(sqtss));

    printf("\n");
}

