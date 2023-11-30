#ifndef cpucycles_h
#define cpucycles_h
#include <time.h>

// static inline unsigned long long cpucycles(void) {
//   unsigned long long result;

//   asm volatile("rdtsc; shlq $32,%%rdx; orq %%rdx,%%rax"
//     : "=a" (result) : : "%rdx");

//   return result;
// }
// static inline unsigned long long cpucycles(void) {
//   unsigned long long val;
//   asm volatile("mrs %0, cntvct_el0" : "=r" (val));
//   return val;
// }
static inline unsigned long long cpucycles(void) {
    struct timespec time;
    clock_gettime(CLOCK_REALTIME, &time);
    return (int64_t)(time.tv_sec*1e9 + time.tv_nsec);
}
#endif
