#include "steps.h"

int steps_guess(long long *bs,long long *gs,long long l)
{
  /* l=3: bs=0 gs=0 bench=3072 baseline=3072 */
  /* l=5: bs=0 gs=0 bench=3072 baseline=3072 */
  /* l=7: bs=0 gs=0 bench=4096 baseline=4096 */
  /* l=11: bs=0 gs=0 bench=6144 baseline=6912 */
  /* l=13: bs=0 gs=0 bench=7168 baseline=7936 */
  /* l=17: bs=0 gs=0 bench=9216 baseline=9984 */
  /* l=19: bs=0 gs=0 bench=11008 baseline=11008 */
  /* l=23: bs=0 gs=0 bench=12800 baseline=13056 */
  /* l=29: bs=0 gs=0 bench=16128 baseline=16128 */
  /* l=31: bs=0 gs=0 bench=16896 baseline=16896 */
  /* l=37: bs=0 gs=0 bench=19968 baseline=19968 */
  /* l=41: bs=0 gs=0 bench=22016 baseline=22016 */
  /* l=43: bs=0 gs=0 bench=23040 baseline=23808 */
  /* l=47: bs=0 gs=0 bench=25088 baseline=26112 */
  /* l=53: bs=0 gs=0 bench=28160 baseline=28928 */
  /* l=59: bs=0 gs=0 bench=32000 baseline=32000 */
  /* l=61: bs=0 gs=0 bench=33024 baseline=33024 */
  /* l=67: bs=0 gs=0 bench=36096 baseline=36096 */
  /* l=71: bs=0 gs=0 bench=38144 baseline=38144 */
  /* l=73: bs=0 gs=0 bench=39168 baseline=38912 */
  /* l=79: bs=0 gs=0 bench=43008 baseline=41984 */
  /* l=83: bs=0 gs=0 bench=45056 baseline=44032 */
  /* l=89: bs=0 gs=0 bench=47872 baseline=47104 */
  /* l=97: bs=0 gs=0 bench=51968 baseline=51200 */
  /* l=101: bs=0 gs=0 bench=54016 baseline=54016 */
  if (l <= 101) { *bs = 0; *gs = 0; return 1; }
  /* l=103: bs=6 gs=4 bench=55040 baseline=55040 */
  /* l=107: bs=6 gs=4 bench=57088 baseline=57088 */
  /* l=109: bs=6 gs=4 bench=57088 baseline=57856 */
  if (l <= 109) { *bs = 6; *gs = 4; return 1; }
  /* l=113: bs=0 gs=0 bench=60928 baseline=67840 */
  if (l <= 113) { *bs = 0; *gs = 0; return 1; }
  /* l=127: bs=6 gs=4 bench=66048 baseline=67840 */
  if (l <= 127) { *bs = 6; *gs = 4; return 1; }
  /* l=131: bs=8 gs=4 bench=66048 baseline=69120 */
  /* l=137: bs=8 gs=4 bench=69888 baseline=71936 */
  /* l=139: bs=8 gs=4 bench=70144 baseline=73216 */
  if (l <= 139) { *bs = 8; *gs = 4; return 1; }
  /* l=149: bs=6 gs=6 bench=75008 baseline=78848 */
  if (l <= 149) { *bs = 6; *gs = 6; return 1; }
  /* l=151: bs=8 gs=4 bench=76032 baseline=79872 */
  if (l <= 151) { *bs = 8; *gs = 4; return 1; }
  /* l=157: bs=6 gs=6 bench=79104 baseline=82944 */
  if (l <= 157) { *bs = 6; *gs = 6; return 1; }
  /* l=163: bs=8 gs=5 bench=77824 baseline=86016 */
  /* l=167: bs=8 gs=5 bench=79104 baseline=88064 */
  /* l=173: bs=8 gs=5 bench=82944 baseline=91136 */
  /* l=179: bs=8 gs=5 bench=84992 baseline=93952 */
  /* l=181: bs=8 gs=5 bench=86016 baseline=94976 */
  /* l=191: bs=8 gs=5 bench=91904 baseline=100864 */
  if (l <= 191) { *bs = 8; *gs = 5; return 1; }
  /* l=193: bs=8 gs=6 bench=87808 baseline=101120 */
  /* l=197: bs=8 gs=6 bench=89088 baseline=103168 */
  /* l=199: bs=8 gs=6 bench=90112 baseline=104192 */
  /* l=211: bs=8 gs=6 bench=96000 baseline=110848 */
  /* l=223: bs=8 gs=6 bench=102144 baseline=116992 */
  if (l <= 223) { *bs = 8; *gs = 6; return 1; }
  /* l=227: bs=8 gs=7 bench=102912 baseline=119040 */
  /* l=229: bs=8 gs=7 bench=108032 baseline=120064 */
  /* l=233: bs=8 gs=7 bench=104960 baseline=122112 */
  /* l=239: bs=8 gs=7 bench=110080 baseline=125952 */
  if (l <= 239) { *bs = 8; *gs = 7; return 1; }
  /* l=241: bs=10 gs=6 bench=103936 baseline=143104 */
  /* l=251: bs=10 gs=6 bench=108800 baseline=140032 */
  /* l=257: bs=10 gs=6 bench=113152 baseline=134144 */
  if (l <= 257) { *bs = 10; *gs = 6; return 1; }
  /* l=263: bs=8 gs=8 bench=116992 baseline=137984 */
  if (l <= 263) { *bs = 8; *gs = 8; return 1; }
  /* l=269: bs=10 gs=6 bench=118016 baseline=141056 */
  /* l=271: bs=10 gs=6 bench=119040 baseline=142080 */
  if (l <= 271) { *bs = 10; *gs = 6; return 1; }
  /* l=277: bs=8 gs=8 bench=122880 baseline=144896 */
  if (l <= 277) { *bs = 8; *gs = 8; return 1; }
  /* l=281: bs=10 gs=7 bench=118016 baseline=146944 */
  /* l=283: bs=10 gs=7 bench=119040 baseline=147968 */
  /* l=293: bs=10 gs=7 bench=123904 baseline=153088 */
  /* l=307: bs=10 gs=7 bench=131072 baseline=160000 */
  /* l=311: bs=10 gs=7 bench=132864 baseline=163072 */
  if (l <= 311) { *bs = 10; *gs = 7; return 1; }
  /* l=313: bs=12 gs=6 bench=133120 baseline=163840 */
  if (l <= 313) { *bs = 12; *gs = 6; return 1; }
  /* l=317: bs=10 gs=7 bench=135936 baseline=165888 */
  if (l <= 317) { *bs = 10; *gs = 7; return 1; }
  /* l=331: bs=10 gs=8 bench=134912 baseline=173056 */
  if (l <= 331) { *bs = 10; *gs = 8; return 1; }
  /* l=337: bs=12 gs=7 bench=136960 baseline=175872 */
  /* l=347: bs=12 gs=7 bench=142848 baseline=180992 */
  /* l=349: bs=12 gs=7 bench=142848 baseline=182016 */
  /* l=353: bs=12 gs=7 bench=144128 baseline=184064 */
  /* l=359: bs=12 gs=7 bench=146944 baseline=187904 */
  if (l <= 359) { *bs = 12; *gs = 7; return 1; }
  /* l=367: bs=10 gs=9 bench=147968 baseline=192000 */
  /* l=373: bs=10 gs=9 bench=153088 baseline=194816 */
  if (l <= 373) { *bs = 10; *gs = 9; return 1; }
  /* l=587: bs=16 gs=9 bench=204800 baseline=304896 */
  if (l <= 587) { *bs = 16; *gs = 9; return 1; }
  return 0;
}
