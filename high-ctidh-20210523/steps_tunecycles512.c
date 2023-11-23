#include "steps.h"

int steps_guess(long long *bs,long long *gs,long long l)
{
  /* l=3: bs=0 gs=0 bench=74 baseline=68 */
  /* l=5: bs=0 gs=0 bench=94 baseline=92 */
  /* l=7: bs=0 gs=0 bench=118 baseline=121 */
  /* l=11: bs=0 gs=0 bench=176 baseline=183 */
  /* l=13: bs=0 gs=0 bench=204 baseline=212 */
  /* l=17: bs=0 gs=0 bench=262 baseline=269 */
  /* l=19: bs=0 gs=0 bench=292 baseline=301 */
  /* l=23: bs=0 gs=0 bench=349 baseline=363 */
  /* l=29: bs=0 gs=0 bench=437 baseline=449 */
  /* l=31: bs=0 gs=0 bench=465 baseline=485 */
  /* l=37: bs=0 gs=0 bench=553 baseline=567 */
  /* l=41: bs=0 gs=0 bench=612 baseline=625 */
  /* l=43: bs=0 gs=0 bench=642 baseline=659 */
  /* l=47: bs=0 gs=0 bench=697 baseline=721 */
  /* l=53: bs=0 gs=0 bench=784 baseline=804 */
  /* l=59: bs=0 gs=0 bench=874 baseline=895 */
  /* l=61: bs=0 gs=0 bench=901 baseline=920 */
  /* l=67: bs=0 gs=0 bench=1004 baseline=1002 */
  /* l=71: bs=0 gs=0 bench=1060 baseline=1066 */
  /* l=73: bs=0 gs=0 bench=1093 baseline=1086 */
  /* l=79: bs=0 gs=0 bench=1177 baseline=1181 */
  /* l=83: bs=0 gs=0 bench=1235 baseline=1235 */
  /* l=89: bs=0 gs=0 bench=1325 baseline=1320 */
  /* l=97: bs=0 gs=0 bench=1516 baseline=1572 */
  if (l <= 97) { *bs = 0; *gs = 0; return 1; }
  /* l=101: bs=6 gs=4 bench=1562 baseline=1574 */
  /* l=103: bs=6 gs=4 bench=1510 baseline=1610 */
  /* l=107: bs=6 gs=4 bench=1574 baseline=1584 */
  /* l=109: bs=6 gs=4 bench=1585 baseline=1615 */
  if (l <= 109) { *bs = 6; *gs = 4; return 1; }
  /* l=113: bs=0 gs=0 bench=1669 baseline=1666 */
  if (l <= 113) { *bs = 0; *gs = 0; return 1; }
  /* l=127: bs=6 gs=4 bench=1889 baseline=1934 */
  if (l <= 127) { *bs = 6; *gs = 4; return 1; }
  /* l=131: bs=8 gs=4 bench=1839 baseline=1925 */
  /* l=137: bs=8 gs=4 bench=1914 baseline=2011 */
  /* l=139: bs=8 gs=4 bench=1939 baseline=2048 */
  if (l <= 139) { *bs = 8; *gs = 4; return 1; }
  /* l=149: bs=6 gs=6 bench=2073 baseline=2186 */
  /* l=151: bs=6 gs=6 bench=2105 baseline=2222 */
  if (l <= 151) { *bs = 6; *gs = 6; return 1; }
  /* l=157: bs=8 gs=4 bench=2191 baseline=2309 */
  if (l <= 157) { *bs = 8; *gs = 4; return 1; }
  /* l=163: bs=8 gs=5 bench=2135 baseline=2389 */
  /* l=167: bs=8 gs=5 bench=2185 baseline=2453 */
  /* l=173: bs=8 gs=5 bench=2275 baseline=2537 */
  /* l=179: bs=8 gs=5 bench=2347 baseline=2621 */
  /* l=181: bs=8 gs=5 bench=2378 baseline=2652 */
  /* l=191: bs=8 gs=5 bench=2532 baseline=2805 */
  if (l <= 191) { *bs = 8; *gs = 5; return 1; }
  /* l=193: bs=8 gs=6 bench=2408 baseline=2817 */
  /* l=197: bs=8 gs=6 bench=2455 baseline=2883 */
  /* l=199: bs=8 gs=6 bench=2483 baseline=2913 */
  /* l=211: bs=8 gs=6 bench=2644 baseline=3085 */
  /* l=223: bs=8 gs=6 bench=2819 baseline=3271 */
  if (l <= 223) { *bs = 8; *gs = 6; return 1; }
  /* l=227: bs=8 gs=7 bench=2819 baseline=3313 */
  /* l=229: bs=8 gs=7 bench=2845 baseline=3342 */
  /* l=233: bs=8 gs=7 bench=2910 baseline=3398 */
  /* l=239: bs=8 gs=7 bench=2995 baseline=3497 */
  if (l <= 239) { *bs = 8; *gs = 7; return 1; }
  /* l=241: bs=10 gs=6 bench=2877 baseline=3516 */
  /* l=251: bs=10 gs=6 bench=3013 baseline=3666 */
  /* l=257: bs=10 gs=6 bench=3110 baseline=3735 */
  /* l=263: bs=10 gs=6 bench=3180 baseline=3831 */
  /* l=269: bs=10 gs=6 bench=3287 baseline=3920 */
  /* l=271: bs=10 gs=6 bench=3301 baseline=3949 */
  /* l=277: bs=10 gs=6 bench=3398 baseline=4034 */
  if (l <= 277) { *bs = 10; *gs = 6; return 1; }
  /* l=281: bs=10 gs=7 bench=3305 baseline=4091 */
  /* l=283: bs=10 gs=7 bench=3320 baseline=4126 */
  if (l <= 283) { *bs = 10; *gs = 7; return 1; }
  /* l=293: bs=12 gs=6 bench=3424 baseline=4263 */
  /* l=307: bs=12 gs=6 bench=3630 baseline=4470 */
  /* l=311: bs=12 gs=6 bench=3685 baseline=4536 */
  /* l=313: bs=12 gs=6 bench=3702 baseline=4553 */
  /* l=317: bs=12 gs=6 bench=3758 baseline=4613 */
  if (l <= 317) { *bs = 12; *gs = 6; return 1; }
  /* l=331: bs=10 gs=8 bench=3740 baseline=4810 */
  if (l <= 331) { *bs = 10; *gs = 8; return 1; }
  /* l=337: bs=12 gs=7 bench=3788 baseline=4899 */
  /* l=347: bs=12 gs=7 bench=3914 baseline=5047 */
  /* l=349: bs=12 gs=7 bench=3943 baseline=5074 */
  /* l=353: bs=12 gs=7 bench=4006 baseline=5130 */
  /* l=359: bs=12 gs=7 bench=4086 baseline=5220 */
  if (l <= 359) { *bs = 12; *gs = 7; return 1; }
  /* l=367: bs=10 gs=9 bench=4141 baseline=5342 */
  /* l=373: bs=10 gs=9 bench=4170 baseline=5431 */
  if (l <= 373) { *bs = 10; *gs = 9; return 1; }
  /* l=587: bs=16 gs=9 bench=5593 baseline=8495 */
  if (l <= 587) { *bs = 16; *gs = 9; return 1; }
  return 0;
}
