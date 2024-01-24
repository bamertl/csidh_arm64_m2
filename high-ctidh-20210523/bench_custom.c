#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "fp.h"
#include <time.h>
#include "primes.h"
#include "csidh.h"
#include "cpucycles.h"

// gets current time in ns
static inline unsigned long long get_time_ns(void) {
    struct timespec time;
    clock_gettime(CLOCK_REALTIME, &time);
    return (int64_t)(time.tv_sec*1e9 + time.tv_nsec);
}


int cmp_uint64_t(const void *x, const void *y) { return * (uint64_t *) x - * (uint64_t *) y; }

uint64_t median(uint64_t *vals, unsigned long its)
{
    qsort(vals, its, sizeof(*vals), cmp_uint64_t);
    return vals[its / 2];
}

double mean(uint64_t *vals, unsigned long its)
{
    uint64_t sum = 0;
    for (size_t i = 0; i < its; ++i)
        sum += vals[i];
    return sum / (double) its;
}

void test_nike_1(void)
{
  private_key priv_alice, priv_bob;
  public_key pub_alice, pub_bob;
  public_key shared_alice, shared_bob;
  bool ok = 1;

  csidh_private(&priv_alice);
  csidh_private(&priv_bob);
  ok &= csidh(&pub_alice, &base, &priv_alice);
  ok &= csidh(&pub_bob, &base, &priv_bob);
  ok &= csidh(&shared_bob, &pub_alice, &priv_bob);
  ok &= csidh(&shared_alice, &pub_bob, &priv_alice);
  ok &= !memcmp(&shared_alice, &shared_bob, sizeof(public_key));

  if (!ok) {
    for (unsigned long long i = 0;i < sizeof(private_key);++i)
    fflush(stdout);
    abort();
  }
}
const size_t stacksz = 0x8000;  /* 32k */
#define KEYS 65

private_key priv_bob[KEYS];
public_key pub_bob[KEYS];
private_key priv_alice[KEYS];
public_key action_output[KEYS];

int main(int argc,char **argv)
{
  uint64_t t0_private, t1_private, t0_csidh, t1_csidh;
  long long target = -1;
  if (argc >= 2) target = atoll(argv[1]);
  unsigned char *stack;
  unsigned long its = KEYS*target;

  printf("its %lu\n",its);
  uint64_t *times_csidh = calloc(its, sizeof(uint64_t));
  uint64_t *times_private = calloc(KEYS, sizeof(uint64_t));  

   __asm__ __volatile__ ("mov %0, sp" : "=r"(stack));
  stack -= stacksz;

  for (long long key = 0;key < KEYS;++key) {
    t0_private = get_time_ns();
    csidh_private(&priv_alice[key]);
    t1_private = get_time_ns();
    times_private[key] = t1_private - t0_private;
  }

  for (long long key = 0;key < KEYS;++key) {
    csidh_private(&priv_bob[key]);
  }


  for (long long key = 0;key < KEYS;++key) {
    action(&pub_bob[key],&base,&priv_bob[key]);
  }

  for (long long key = 0;key < KEYS;++key)
    for (long long key2 = 0;key2 < key;++key2) {
      assert(memcmp(&priv_bob[key],&priv_bob[key2],sizeof(private_key)));
      assert(memcmp(&pub_bob[key],&pub_bob[key2],sizeof(public_key)));
    }

  for (long long key = 0;key < KEYS;++key)
    if (key&1)
      pub_bob[key] = base;


  //int total = KEYS*target;    
  int i = 0;
  for (long long loop = 0;loop != target;++loop) {

    test_nike_1();
    for (long long key = 0;key < KEYS;++key) {
      fp_mulsq_count = fp_sq_count = fp_addsub_count = 0;
      bool ok = validate(&pub_bob[key]);
      //cycles = cpucycles()-cycles;
      assert(ok);

      for (long long b = 0;b < primes_batches;++b)
        csidh_statsucceeded[b] = csidh_stattried[b] = 0;
      fp_mulsq_count = fp_sq_count = fp_addsub_count = 0;
      t0_csidh = get_time_ns();
      action(&action_output[key],&pub_bob[key],&priv_alice[key]);
      t1_csidh = get_time_ns();
      times_csidh[i] = t1_csidh - t0_csidh;
      //set loop*key element of timing to cycles
      i = i + 1;
      for (long long b = 0;b < primes_batches;++b)
        assert(csidh_statsucceeded[b] == primes_batchbound[b]);
    }
    // print i
    printf("last i: %d\n",i);
    fflush(stdout);
  }
 
  printf("Mean private Key gen in ns: %lf\n",mean(times_private,KEYS));
  printf("Mediam private Key gen in ns: %llu\n",median(times_private,KEYS));
  printf("Mean private Key gen in ms: %lf\n",mean(times_private,KEYS)/1000000);

  printf("Mean ctidh in ns: %lf\n",mean(times_csidh,its));
  printf("Mediam ctidh in ns: %llu\n",median(times_csidh,its));
  printf("Mean ctidh in ms: %lf\n",mean(times_csidh,its)/1000000);
  printf("Multiplications: %lld\n",fp_mulsq_count);  
  printf("Squarings: %lld\n",fp_sq_count);
  printf("Additions/subtractions: %lld\n",fp_addsub_count);

  fflush(stdout);
  return 0;
}
