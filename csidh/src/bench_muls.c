#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
#include <assert.h>
#include <inttypes.h>
#include "csidh.h"
#include "fp.h"

int cmp_uint64_t(const void *x, const void *y) { return *(uint64_t *)x - *(uint64_t *)y; }
void fp_mul3(fp *x, fp const *y, fp const *z);

uint64_t median(uint64_t *vals, int its)
{
    qsort(vals, its, sizeof(*vals), cmp_uint64_t);
    return vals[its / 2];
}

// Clock ticks
static inline uint64_t rdtsc(void) {
    uint64_t ticks;
    __asm__ __volatile__("mrs %0, CNTVCT_EL0" : "=r" (ticks));
    return ticks;
}

double mean(uint64_t *vals, int its)
{
    uint64_t sum = 0;
    for (int i = 0; i < its; ++i)
        sum += vals[i];
    return sum / (double)its;
}

double mean_double(double *vals, int its) {
    double sum = 0.0;
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

// Should get time in ns
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

void benchmark_operation(Operation op, int num_experiments){

    int num_ops_per_experiment = 10000;

    fp *a_arr = calloc(num_ops_per_experiment, sizeof(fp));
    fp *b_arr = calloc(num_ops_per_experiment, sizeof(fp));
    for (int i = 0; i < num_ops_per_experiment; i++){
        fp_random(&a_arr[i]);
        fp_random(&b_arr[i]);
    }    

    fp c = {{0}};
    // allocate uint64_t array for num experiments
    uint64_t *times_ns = calloc(num_experiments, sizeof(uint64_t));
    double *time_ns_from_ticks_arr = calloc(num_experiments, sizeof(double));

    for (int i = 0; i < num_experiments; i++){
        uint64_t c0 = cpucycles();
        uint64_t ticks0 = rdtsc();
        
        for (int j = 0; j < num_ops_per_experiment; j++){
            op(&c, &a_arr[j], &b_arr[j]);
        }

        uint64_t c1 = cpucycles();
        uint64_t ticks1 = rdtsc();

        uint64_t time_ns = c1 - c0;
        uint64_t ticks = ticks1 - ticks0;
        times_ns[i] = time_ns / num_ops_per_experiment;
        uint64_t freq = freq_clock();

        double time_ns_from_ticks = ((double)ticks * 1e9) / (freq * num_ops_per_experiment);
        time_ns_from_ticks_arr[i] = time_ns_from_ticks;
    }

    // calculate mean and median
    double mean_time_ns = mean(times_ns, num_experiments);
    uint64_t median_time_ns = median(times_ns, num_experiments);

    double mean_time_ns_from_ticks = mean_double(time_ns_from_ticks_arr, num_experiments);
    printf("Mean time per operation: %f ns\n", mean_time_ns);
    printf("Median time per operation: %llu ns\n", median_time_ns);
    printf("Mean time per operation from ticks: %f ns\n", mean_time_ns_from_ticks);

    // calculate instructions per cycle
    //printf("Instructions per cycle: %f\n", ipc);

}

int main(void)
{ 
    int num_experiments = 1000;

    benchmark_operation(fp_mul3, num_experiments); 
    return 0;
}
