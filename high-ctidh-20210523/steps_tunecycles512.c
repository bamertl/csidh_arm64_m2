#include "steps.h"

int steps_guess(long long *bs,long long *gs,long long l)
{
  /* l=3: bs=0 gs=0 bench=2048 baseline=2048 */
  /* l=5: bs=0 gs=0 bench=2048 baseline=2048 */
  /* l=7: bs=0 gs=0 bench=2048 baseline=2048 */
  /* l=11: bs=0 gs=0 bench=4096 baseline=3840 */
  /* l=13: bs=0 gs=0 bench=4096 baseline=4096 */
  /* l=17: bs=0 gs=0 bench=5120 baseline=5120 */
  /* l=19: bs=0 gs=0 bench=5888 baseline=6144 */
  /* l=23: bs=0 gs=0 bench=7168 baseline=7168 */
  /* l=29: bs=0 gs=0 bench=8960 baseline=8960 */
  /* l=31: bs=0 gs=0 bench=9984 baseline=9984 */
  /* l=37: bs=0 gs=0 bench=11008 baseline=12032 */
  /* l=41: bs=0 gs=0 bench=12800 baseline=13056 */
  /* l=43: bs=0 gs=0 bench=13056 baseline=13056 */
  /* l=47: bs=0 gs=0 bench=14080 baseline=14848 */
  /* l=53: bs=0 gs=0 bench=16128 baseline=16128 */
  /* l=59: bs=0 gs=0 bench=17920 baseline=17920 */
  /* l=61: bs=0 gs=0 bench=18944 baseline=18944 */
  /* l=67: bs=0 gs=0 bench=20992 baseline=19968 */
  /* l=71: bs=0 gs=0 bench=22016 baseline=22016 */
  /* l=73: bs=0 gs=0 bench=22784 baseline=22016 */
  /* l=79: bs=0 gs=0 bench=24064 baseline=24064 */
  /* l=83: bs=0 gs=0 bench=25088 baseline=25088 */
  /* l=89: bs=0 gs=0 bench=27136 baseline=26880 */
  /* l=97: bs=0 gs=0 bench=29952 baseline=28928 */
  /* l=101: bs=0 gs=0 bench=30976 baseline=30976 */
  /* l=103: bs=0 gs=0 bench=30976 baseline=30976 */
  /* l=107: bs=0 gs=0 bench=33024 baseline=32000 */
  /* l=109: bs=0 gs=0 bench=33024 baseline=33024 */
  /* l=113: bs=0 gs=0 bench=34048 baseline=34048 */
  /* l=127: bs=0 gs=0 bench=38912 baseline=38144 */
  if (l <= 127) { *bs = 0; *gs = 0; return 1; }
  /* l=131: bs=8 gs=4 bench=38912 baseline=39168 */
  /* l=137: bs=8 gs=4 bench=40960 baseline=40960 */
  /* l=139: bs=8 gs=4 bench=40960 baseline=41984 */
  /* l=149: bs=8 gs=4 bench=44032 baseline=45056 */
  /* l=151: bs=8 gs=4 bench=44800 baseline=45056 */
  /* l=157: bs=8 gs=4 bench=46080 baseline=47104 */
  if (l <= 157) { *bs = 8; *gs = 4; return 1; }
  /* l=163: bs=8 gs=5 bench=46080 baseline=48896 */
  /* l=167: bs=8 gs=5 bench=47104 baseline=49920 */
  /* l=173: bs=8 gs=5 bench=48896 baseline=51968 */
  /* l=179: bs=8 gs=5 bench=50176 baseline=54016 */
  /* l=181: bs=8 gs=5 bench=50944 baseline=54016 */
  /* l=191: bs=8 gs=5 bench=54016 baseline=57088 */
  if (l <= 191) { *bs = 8; *gs = 5; return 1; }
  /* l=193: bs=8 gs=6 bench=51968 baseline=57856 */
  /* l=197: bs=8 gs=6 bench=52992 baseline=58880 */
  /* l=199: bs=8 gs=6 bench=54016 baseline=59136 */
  /* l=211: bs=8 gs=6 bench=57088 baseline=62976 */
  /* l=223: bs=8 gs=6 bench=60928 baseline=67072 */
  if (l <= 223) { *bs = 8; *gs = 6; return 1; }
  /* l=227: bs=8 gs=7 bench=60928 baseline=67840 */
  /* l=229: bs=8 gs=7 bench=60928 baseline=68096 */
  /* l=233: bs=8 gs=7 bench=61952 baseline=69120 */
  /* l=239: bs=8 gs=7 bench=64000 baseline=71168 */
  if (l <= 239) { *bs = 8; *gs = 7; return 1; }
  /* l=241: bs=10 gs=6 bench=61184 baseline=71936 */
  /* l=251: bs=10 gs=6 bench=64000 baseline=75008 */
  /* l=257: bs=10 gs=6 bench=67072 baseline=76032 */
  /* l=263: bs=10 gs=6 bench=68096 baseline=78080 */
  /* l=269: bs=10 gs=6 bench=69888 baseline=80128 */
  /* l=271: bs=10 gs=6 bench=70144 baseline=80896 */
  /* l=277: bs=10 gs=6 bench=71936 baseline=82176 */
  if (l <= 277) { *bs = 10; *gs = 6; return 1; }
  /* l=281: bs=10 gs=7 bench=69888 baseline=83968 */
  /* l=283: bs=10 gs=7 bench=69888 baseline=83968 */
  /* l=293: bs=10 gs=7 bench=72960 baseline=87040 */
  /* l=307: bs=10 gs=7 bench=77056 baseline=91136 */
  /* l=311: bs=10 gs=7 bench=78080 baseline=92928 */
  /* l=313: bs=10 gs=7 bench=78848 baseline=92928 */
  /* l=317: bs=10 gs=7 bench=79872 baseline=93952 */
  if (l <= 317) { *bs = 10; *gs = 7; return 1; }
  /* l=331: bs=10 gs=8 bench=79872 baseline=98048 */
  if (l <= 331) { *bs = 10; *gs = 8; return 1; }
  /* l=337: bs=12 gs=7 bench=80896 baseline=100096 */
  /* l=347: bs=12 gs=7 bench=83200 baseline=102912 */
  /* l=349: bs=12 gs=7 bench=83968 baseline=103936 */
  /* l=353: bs=12 gs=7 bench=84992 baseline=104960 */
  /* l=359: bs=12 gs=7 bench=87040 baseline=107008 */
  if (l <= 359) { *bs = 12; *gs = 7; return 1; }
  /* l=367: bs=10 gs=9 bench=87040 baseline=109056 */
  /* l=373: bs=10 gs=9 bench=89088 baseline=111104 */
  if (l <= 373) { *bs = 10; *gs = 9; return 1; }
  /* l=587: bs=16 gs=9 bench=122112 baseline=173824 */
  if (l <= 587) { *bs = 16; *gs = 9; return 1; }
  return 0;
}
