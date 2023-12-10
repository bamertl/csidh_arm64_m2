#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <assert.h>
#include <inttypes.h>

int cmp_uint64_t(const void *x, const void *y) { return *(uint64_t *)x - *(uint64_t *)y; }

uint64_t median(uint64_t *vals, int its)
{
    qsort(vals, its, sizeof(*vals), cmp_uint64_t);
    return vals[its / 2];
}

double mean(uint64_t *vals, int its)
{
    uint64_t sum = 0;
    for (size_t i = 0; i < its; ++i)
        sum += vals[i];
    return sum / (double)its;
}

static inline uint64_t rdtsc(void) {
    uint64_t tickse;
    __asm__ __volatile__("mrs %0,CNTPCT_EL0" : "=r" (tickse));
    return tickse;
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

extern int mul_no_pipeline(int);

extern int mul_pipeline(int);

typedef int (*Operation)(int);

void benchmark_operation(Operation op, int total_instruction, int num_experiments){

    // allocate uint64_t array for num experiments
    uint64_t *cycless = calloc(num_experiments, sizeof(uint64_t));

    for (int i = 0; i < num_experiments; i++){
        uint64_t c0 = cpucycles();
        int result = op(2);
        result +=2;
        uint64_t c1 = cpucycles();

        uint64_t cycles = c1 - c0;
        cycless[i] = cycles;
    }
    // calculate mean and median
    double mean_cycles = mean(cycless, num_experiments);
    uint64_t median_cycles = median(cycless, num_experiments);
    printf("Mean cycles: %f\n", mean_cycles);
    printf("Median cycles: %llu\n", median_cycles);
    // cycles to milliseconds
    double mean_milliseconds = ticks_to_milliseconds(mean_cycles);
    printf("Mean milliseconds: %f\n", mean_milliseconds);
    // calculate instructions per cycle
    float ipc = total_instruction / mean_cycles; 
    printf("Instructions per cycle: %f\n", ipc);

}


int main(void)
{ 
    int amount = 100000;
    int num_experiments = 2000;

    benchmark_operation(mul_no_pipeline, amount, num_experiments); 
    benchmark_operation(mul_pipeline, amount, num_experiments);
    return 0;
}

