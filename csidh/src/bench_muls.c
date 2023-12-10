#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <assert.h>
#include <inttypes.h>
#include "csidh.h"

int cmp_uint64_t(const void *x, const void *y) { return *(uint64_t *)x - *(uint64_t *)y; }
void fp_mul3(fp *x, fp const *y, fp const *z);

uint64_t median(uint64_t *vals, int its)
{
    qsort(vals, its, sizeof(*vals), cmp_uint64_t);
    return vals[its / 2];
}

double mean(uint64_t *vals, int its)
{
    uint64_t sum = 0;
    for (int i = 0; i < its; ++i)
        sum += vals[i];
    return sum / (double)its;
}

// Clock frequency. Indicates the system counter clock frequency, in Hz
static inline uint64_t freq_clock(void) {
    uint64_t freq_clock;
    __asm__ __volatile__("mrs %0, cntfrq_el0" : "=r" (freq_clock));
    return freq_clock;
}

static inline unsigned long long cpucycles(void) {
    struct timespec time;
    clock_gettime(CLOCK_REALTIME, &time);
    return (int64_t)(time.tv_sec*1e9 + time.tv_nsec);
}

float freq_ghz_clock = 0; 
float freq_ghz_cpu = 2.41;

float ticks_to_cycles(uint64_t ticks)
{
    return ticks * freq_ghz_clock / freq_ghz_cpu;
}

// ticks to milliseconds function
double ticks_to_milliseconds(uint64_t ticks) {
    // tick duration in hz
    uint64_t tick_duration_s = ticks * 1000 / freq_clock();

    // convert seconds to milliseconds
    return tick_duration_s;
}

typedef void (*Operation)(fp *x, fp const *y, fp const *z);

void benchmark_operation(Operation op, int total_instruction, int num_experiments){

    int num_ops_per_experiment = 50000;


    fp a = {{1,2,3,4,5,6,7,8}};
    // Generate random fp b
    fp b = {{1,2,3,4,5,6,7,8}};
    
    fp c = {{0}};
    // allocate uint64_t array for num experiments
    uint64_t *cycless = calloc(num_experiments, sizeof(uint64_t));

    for (int i = 0; i < num_experiments; i++){
        uint64_t c0 = cpucycles();
        
        for (int j = 0; j < num_ops_per_experiment; j++){
            op(&c, &a, &b);
        }

        uint64_t c1 = cpucycles();

        uint64_t cycles = c1 - c0;
        cycless[i] = cycles / num_ops_per_experiment ;
    }

    // calculate mean and median
    double mean_cycles = mean(cycless, num_experiments);
    uint64_t median_cycles = median(cycless, num_experiments);
    printf("Mean cycles: %f\n", mean_cycles);
    printf("Median cycles: %llu\n", median_cycles);
    printf("total instructions in this mul: %d\n", total_instruction);
    // calculate instructions per cycle
    //printf("Instructions per cycle: %f\n", ipc);

}

int main(void)
{ 
    int instructions_for_mul = 100000; // we actually need to count them
    int num_experiments = 1000;

    benchmark_operation(fp_mul3, instructions_for_mul, num_experiments); 
    return 0;
}
