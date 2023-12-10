#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "fp.h"
#include <time.h>
#include "primes.h"
#include "csidh.h"
#include "cpucycles.h"

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
  clock_t t0, t1;
  long long target = -1;
  if (argc >= 2) target = atoll(argv[1]);
  unsigned char *stack;
  unsigned long its = KEYS*target;

  printf("its %lu\n",its);
  uint64_t *times = calloc(its, sizeof(uint64_t));
     
   __asm__ __volatile__ ("mov %0, sp" : "=r"(stack));
  stack -= stacksz;
  for (long long key = 0;key < KEYS;++key) {
    csidh_private(&priv_alice[key]);
    csidh_private(&priv_bob[key]);
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

  long long pos = 0;
  for (long long b = 0;b < primes_batches;++b) {
    long long p = primes[pos];
    pos += primes_batchsize[b];
  }
  int total = KEYS*target;    
  printf("Total %d\n",total );
  int i = 0;
  for (long long loop = 0;loop != target;++loop) {

    test_nike_1();
    for (long long key = 0;key < KEYS;++key) {
      if (total < 100 || i % (total / 100) == 0) {
            printf("%2lld%%", 100 * i / total);
            fflush(stdout);
            printf("\r\x1b[K");
        }
      
      fp_mulsq_count = fp_sq_count = fp_addsub_count = 0;
      long long cycles = cpucycles();
      bool ok = validate(&pub_bob[key]);
      //cycles = cpucycles()-cycles;
      assert(ok);

      for (long long b = 0;b < primes_batches;++b)
        csidh_statsucceeded[b] = csidh_stattried[b] = 0;
      fp_mulsq_count = fp_sq_count = fp_addsub_count = 0;
      t0 = clock();   /* uses stack, but not too much */
      action(&action_output[key],&pub_bob[key],&priv_alice[key]);
      t1 = clock();
      times[i] = t1-t0;
      //set loop*key element of timing to cycles
      i = i + 1;
      for (long long b = 0;b < primes_batches;++b)
        assert(csidh_statsucceeded[b] == primes_batchbound[b]);
    }
    fflush(stdout);
  }
  printf("mean wall-clock time: \x1b[34m%6.3lf ms\x1b[0m\n", 1000. * mean(times, its)  / CLOCKS_PER_SEC);
  printf("median wall-clock time: \x1b[34m%6.3lf ms\x1b[0m\n", 1000. * median(times, its)  / CLOCKS_PER_SEC);

  fflush(stdout);
  return 0;
}
